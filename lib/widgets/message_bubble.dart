import 'package:flutter/material.dart';

class Messagebubble extends StatelessWidget {
  const Messagebubble({
    super.key,
    required this.message,
    required this.sender,
    required this.isSender,
    required this.time,
  });

  final String message;
  final String sender;
  final bool isSender;
  final String time;

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender),
          Material(
            borderRadius: BorderRadius.circular(30),
            color: isSender ? Colors.grey : Colors.lightBlueAccent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
          Text(time),
        ],
      ),
    );
  }
}
