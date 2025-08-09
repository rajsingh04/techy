part of 'contact_bloc.dart';

sealed class ContactEvent {}

class FetchContacts extends ContactEvent {}

class AddContacts extends ContactEvent {
  String username;
  AddContacts({required this.username});
}
