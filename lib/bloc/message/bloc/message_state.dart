part of 'message_bloc.dart';

sealed class MessageState {}

final class MessageInitial extends MessageState {}

final class MessageLoadedState extends MessageState {
  final List<MessageModel> messages;
  MessageLoadedState(this.messages);
}

final class MessageLoadingState extends MessageState {}

final class MessageErrorState extends MessageState {
  final String message;

  MessageErrorState(this.message);
}
