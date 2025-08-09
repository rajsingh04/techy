import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techy/controller/contact_controller.dart';
import 'package:techy/models/contact_model.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc() : super(ContactInitial()) {
    on<FetchContacts>(_onFetchContacts);
    on<AddContacts>(_onAddContacts);
  }
  _onFetchContacts(FetchContacts event, Emitter<ContactState> emit) async {
    emit(ContactLoading());
    try {
      final contacts = await ContactController().fetchContacts();

      emit(ContactLoaded(contacts: contacts));
    } catch (e) {
      emit(ContactError(message: e.toString()));
    }
  }

  _onAddContacts(AddContacts event, Emitter<ContactState> emit) async {
    emit(ContactLoading());
    try {
      await ContactController().addContact(event.username);
      final contacts = await ContactController().fetchContacts();
      emit(ContactLoaded(contacts: contacts));
    } catch (e) {
      emit(ContactError(message: e.toString()));
    }
  }
}
