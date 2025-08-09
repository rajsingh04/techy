import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:techy/controller/message_controller.dart';
import 'package:techy/core/socket_service.dart';
import 'package:techy/models/message_model.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final SocketService _socketService = SocketService();
  final List<MessageModel> _messages = [];

  MessageBloc() : super(MessageInitial()) {
    on<LoadMessageEvent>((event, emit) async {
      emit(MessageLoadingState());
      try {
        List<MessageModel> messages = await MessageController().fetchMessages(
          event.conversationId,
        );

        if (messages.isEmpty) {
          return emit(MessageErrorState("No messages found"));
        }

        _socketService.socket.emit('joinConversation', event.conversationId);

        _socketService.socket.off('newMessage');
        _socketService.socket.on('newMessage', (data) {
          log('data Recieve : $data');
          add(ReceiveMessageEvent(data));
        });
        _messages.clear();
        _messages.addAll(messages);

        emit(MessageLoadedState(List.from(_messages)));
      } catch (e) {
        emit(MessageErrorState(e.toString()));
      }
    });
    on<SendMessageEvent>((event, emit) async {
      final newMessage = {
        'sender_id': event.senderId,
        'conversation_id': event.convesationId,
        'content': event.content,
        'receiver_id': event.receiverId,
      };

      _socketService.socket.emit('sendMessage', newMessage);
    });
    on<ReceiveMessageEvent>((event, emit) async {
      log('Recieved');
      final message = MessageModel(
        id: event.message['_id'],
        conversationId: event.message['conversation_id'],
        senderId: event.message['sender_id'],
        receiverId: event.message['receiver_id'],
        content: event.message['content'],
        createdAt: DateTime.parse(event.message['createdAt']),
        updatedAt: DateTime.parse(event.message['updatedAt']),
      );
      _messages.add(message);
      emit(MessageLoadedState(List.from(_messages)));
    });
  }
}
