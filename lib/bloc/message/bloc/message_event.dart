part of 'message_bloc.dart';

sealed class MessageEvent {}

class LoadMessageEvent extends MessageEvent {
  final String conversationId;
  LoadMessageEvent(this.conversationId);
}

class SendMessageEvent extends MessageEvent {
  final String senderId;
  final String receiverId;
  final String convesationId;
  final String content;

  SendMessageEvent({
    required this.convesationId,
    required this.content,
    required this.receiverId,
    required this.senderId,
  });
}

class ReceiveMessageEvent extends MessageEvent {
  final Map<String, dynamic> message;
  ReceiveMessageEvent(this.message);
}
