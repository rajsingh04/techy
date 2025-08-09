part of 'contact_bloc.dart';

sealed class ContactState {}

final class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  final List<ContactModel> contacts;
  ContactLoaded({required this.contacts});
}

class ContactError extends ContactState {
  final String message;
  ContactError({required this.message});
}

class ContactAdded extends ContactState {}
