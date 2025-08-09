import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:techy/bloc/message/bloc/message_bloc.dart';
import 'package:techy/core/theme.dart';

class ChatPage extends StatefulWidget {
  final String conversationId;
  final String senderId;
  final String receiver;
  final String receiverId;
  const ChatPage({
    super.key,
    required this.conversationId,
    required this.receiver,
    required this.receiverId,
    required this.senderId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  final _storage = FlutterSecureStorage();
  String userId = '';

  @override
  void initState() {
    super.initState();
    context.read<MessageBloc>().add(LoadMessageEvent(widget.conversationId));
    fetchId();
  }

  fetchId() async {
    userId = await _storage.read(key: 'userId') ?? '';
    setState(() {
      userId = userId;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  _sendMessage() {
    final content = _messageController.text.trim();
    _messageController.text = '';
    if (content.isNotEmpty) {
      context.read<MessageBloc>().add(
        SendMessageEvent(
          senderId: widget.senderId,
          receiverId: widget.receiverId,
          convesationId: widget.conversationId,
          content: content,
        ),
      );
      setState(() {});
    }
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: Colors.white),
          ),
        ],
        title: Row(
          children: [
            CircleAvatar(backgroundColor: Colors.pink),
            SizedBox(width: 10),
            Text(
              widget.receiver,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                if (state is MessageLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.blueAccent),
                  );
                } else if (state is MessageLoadedState) {
                  return ListView.builder(
                    padding: EdgeInsets.all(20),

                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final isSentMessage = message.senderId == userId;
                      if (isSentMessage) {
                        return _buildSentMessage(message.content, context);
                      } else {
                        return _buildReceivedMessage(message.content, context);
                      }
                    },
                  );
                } else if (state is MessageErrorState) {
                  return Center(child: Text(state.message));
                }
                return Text("Something wrong");
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildReceivedMessage(String message, BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(right: 30, top: 5, bottom: 5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: DefaultColors.recieverMessage,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }

  Widget _buildSentMessage(String message, BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(left: 30, top: 5, bottom: 5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: DefaultColors.senderMessage,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        color: DefaultColors.sentMessageInput,
        borderRadius: BorderRadius.circular(25),
      ),
      margin: EdgeInsets.all(25),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          GestureDetector(
            child: Icon(Icons.camera_alt, color: Colors.grey),
            onTap: () {},
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Message",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            child: Icon(Icons.send, color: Colors.grey),
            onTap: () {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }
}
