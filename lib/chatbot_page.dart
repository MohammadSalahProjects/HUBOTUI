import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'slide_menu.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // actions: const [Icon(Icons.map)],
        title: Text(
          'Chat Page',
          style: GoogleFonts.adamina(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 227, 225, 225)),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent.withOpacity(0.0),
      ),
      drawer: SlideMenu(
        firstName: '',
        lastName: '',
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade200, Colors.pink.shade200],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                reverse: true,
                padding: const EdgeInsets.all(16.0),
                children: const [
                  MessageBubble(
                    isSender: false,
                    message: 'Hello! How can I assist you today?',
                    time: '10:00 AM',
                    imageUrl:
                        'assets/images/cute-robot-operating-laptop-cartoon-icon.jpg',
                  ),
                  MessageBubble(
                    isSender: true,
                    message: 'Hi! I have a question about my GPA.',
                    time: '10:02 AM',
                    imageUrl:
                        'assets/images/boy-face-avatar-cartoon-free-vector.jpg',
                  ),
                  // Add more message bubbles here
                ],
              ),
            ),
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  FloatingActionButton(
                    onPressed: () {},
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final bool isSender;
  final String message;
  final String time;
  final String imageUrl;

  const MessageBubble({
    Key? key,
    required this.isSender,
    required this.message,
    required this.time,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSender) ...[
            CircleAvatar(
              radius: 20.0,
              backgroundImage: AssetImage(imageUrl),
            ),
            const SizedBox(width: 8.0),
          ],
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: isSender ? Colors.purple.shade100 : Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: isSender
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: isSender ? Colors.black : Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSender) ...[
            const SizedBox(width: 8.0),
            CircleAvatar(
              radius: 20.0,
              backgroundImage: AssetImage(imageUrl),
            ),
          ],
        ],
      ),
    );
  }
}
