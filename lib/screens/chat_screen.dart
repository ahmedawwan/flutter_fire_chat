import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_flutter/widgets/message_bubble.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static String id = 'chat_screen';

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  dynamic currentUser;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    try {
      if (_auth.currentUser != null) {
        currentUser = _auth.currentUser;
        log(currentUser.email);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void sendMessage() {
    try {
      if (messageController.text.isNotEmpty) {
        var time = DateTime.now();
        firestore.collection('messages').add({
          'message': messageController.text.trim(),
          'sender': _auth.currentUser?.email,
          'time':
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
          'format': time.toString(),
        }).then((value) => messageController.clear());
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void getMessages() async {
    await for (var snapshots in firestore
        .collection('messages')
        .orderBy('format', descending: false)
        .snapshots()) {
      for (var snapshot in snapshots.docs) {
        log(snapshot['message'].toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: getMessages,
          )
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height -
              (MediaQuery.of(context).padding.top + kToolbarHeight),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('messages')
                    .orderBy('format', descending: false)
                    .snapshots(),
                builder: (context, snapshots) {
                  if (!snapshots.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final messages = snapshots.data?.docs;
                  List<Messagebubble> messageWidgets = [];
                  for (QueryDocumentSnapshot<Object?> message in messages!) {
                    messageWidgets.add(
                      Messagebubble(
                        message: message['message'],
                        sender: message['sender'],
                        isSender: currentUser.email == message['sender'],
                        time: message['time'],
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      children: messageWidgets,
                    ),
                  );
                },
              ),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    TextButton(
                      onPressed: sendMessage,
                      child: const Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
