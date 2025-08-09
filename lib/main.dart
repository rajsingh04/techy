import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techy/bloc/auth/bloc/auth_bloc.dart';
import 'package:techy/bloc/contacts/bloc/contact_bloc.dart';
import 'package:techy/bloc/conversation/bloc/conversation_bloc.dart';
import 'package:techy/bloc/message/bloc/message_bloc.dart';
import 'package:techy/core/socket_service.dart';
import 'package:techy/core/theme.dart';
import 'package:techy/pages/contact_page.dart';

import 'package:techy/pages/login_page.dart';
import 'package:techy/pages/conversation_page.dart';
import 'package:techy/pages/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final socketService = SocketService();
  await socketService.initSocket();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => ConversationBloc()),
        BlocProvider(create: (_) => MessageBloc()),
        BlocProvider(create: (_) => ContactBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        routes: {
          '/login': (_) => LoginPage(),
          '/register': (_) => RegisterPage(),
          '/message-page': (_) => ConversationPage(),
          '/contact-page': (_) => ContactPage(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Techy - Chat App")));
  }
}
