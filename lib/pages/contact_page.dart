import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techy/bloc/contacts/bloc/contact_bloc.dart';
import 'package:techy/core/theme.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  void initState() {
    super.initState();
    context.read<ContactBloc>().add(FetchContacts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text("Conacts", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          if (state is ContactLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            );
          } else if (state is ContactLoaded) {
            if (state.contacts.isEmpty) {
              return Center(child: Text("No contacts found"));
            }
            return ListView.builder(
              itemCount: state.contacts.length,
              itemBuilder: (context, index) {
                final contact = state.contacts[index];
                return ListTile(
                  leading: CircleAvatar(backgroundColor: Colors.pink.shade100),
                  title: Text(
                    contact.username,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    contact.email,
                    style: TextStyle(color: Colors.white70),
                  ),
                  onTap: () {
                    Navigator.pop(context, contact);
                  },
                );
              },
            );
          } else if (state is ContactError) {
            return Center(
              child: Text(state.message, style: TextStyle(color: Colors.white)),
            );
          }
          return Center(child: Text("No contacts found"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddContact(context);
        },
        backgroundColor: DefaultColors.buttonColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  _showAddContact(BuildContext context) {
    final usernameController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Contact'),
        content: TextField(
          controller: usernameController,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(hintText: 'Enter username'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final username = usernameController.text.trim();
              if (username.isNotEmpty) {
                context.read<ContactBloc>().add(
                  AddContacts(username: username),
                );
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
