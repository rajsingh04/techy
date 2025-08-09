part of 'conversation_bloc.dart';

sealed class ConversationState {}

final class ConversationInitial extends ConversationState {}

final class ConversationLoading extends ConversationState {}

final class ConversationLoaded extends ConversationState {
  final List<ConversationModel> conversations;
  ConversationLoaded(this.conversations);
}

final class ConversationError extends ConversationState {
  final String message;

  ConversationError(this.message);
}
