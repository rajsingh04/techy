import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techy/controller/conversation_controller.dart';
import 'package:techy/core/socket_service.dart';
import 'package:techy/models/conversation_model.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final SocketService _socketService = SocketService();

  _initializeSocketListeners() {
    try {
      _socketService.socket.on('conversationUpdated', _onConversationUpdated);
    } catch (e) {
      log("Error initializing socket listners : $e");
    }
  }

  _onConversationUpdated(data) {
    add(FetchConveration());
  }

  ConversationBloc() : super(ConversationInitial()) {
    _initializeSocketListeners();
    on<FetchConveration>((event, emit) async {
      emit(ConversationLoading());
      try {
        List<ConversationModel> conversations = await ConversationController()
            .fetchConversation();
        emit(ConversationLoaded(conversations));
      } catch (e) {
        emit(ConversationError(e.toString()));
      }
    });
  }
}
