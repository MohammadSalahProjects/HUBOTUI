import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:hubot/slide_menu.dart';

class ChatPage extends StatefulWidget {
  final String userName;
  final String userId;

  const ChatPage({Key? key, required this.userName, required this.userId})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
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

  Widget build(BuildContext context) {
    final RegExp urlRegExp = RegExp(
      r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+',
    );

    String _extractUrl(String message) {
      final RegExpMatch? match = urlRegExp.firstMatch(message);
      return match?.group(0) ?? '';
    }

    Future<void> _handleUrlTap(String url) async {
      try {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      } catch (e) {
        print('Error launching URL: $e');
        // Handle the error gracefully, maybe show a dialog or log the error.
      }
    }


    List<InlineSpan> _getSpans(String message) {
      final List<InlineSpan> spans = [];

      final RegExp urlRegExp =
      RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');

      final Iterable<RegExpMatch> matches = urlRegExp.allMatches(message);

      int currentStart = 0;
      for (RegExpMatch match in matches) {
        final String url = match.group(0)!;
        final int start = match.start;
        final int end = match.end;

        // Add non-URL text as a TextSpan
        if (currentStart != start) {
          final String nonUrlText = message.substring(currentStart, start);
          spans.add(
            TextSpan(
              text: nonUrlText,
              style: TextStyle(
                color: Colors.black, // Customize as needed
                fontSize: 16.0, // Customize as needed
              ),
            ),
          );
        }

        // Add URL text as a TextSpan with a GestureDetector
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: () async {
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Text(
                url,
                style: TextStyle(
                  color: Colors.blue, // Customize as needed
                  fontSize: 16.0, // Customize as needed
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        );

        currentStart = end;
      }

      // Add any remaining non-URL text after the last URL
      if (currentStart != message.length) {
        final String remainingText = message.substring(currentStart);
        spans.add(
          TextSpan(
            text: remainingText,
            style: TextStyle(
              color: Colors.black, // Customize as needed
              fontSize: 16.0, // Customize as needed
            ),
          ),
        );
      }

      return spans;
    }


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
                  RichText(
                    text: TextSpan(
                      children: _getSpans(message),
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



class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  List<MessageBubble> messages = [];

  @override
  void initState() {
    super.initState();
    addInitialBotMessage();
  }

  void addInitialBotMessage() async {
    String initialMessage =
        'Hello! I\'m HUBOT. Ask me anything about the IT faculty 😊';
    addMessageToChat(false, initialMessage, '10:00 AM',
        'assets/images/cute-robot-operating-laptop-cartoon-icon.jpg');
  }

  void addMessageToChat(
      bool isSender, String message, String time, String imageUrl) {
    setState(() {
      messages.insert(
        0,
        MessageBubble(
          isSender: isSender,
          message: message,
          time: time,
          imageUrl: imageUrl,
        ),
      );
    });
  }

  void sendMessage(String text) async {
    addMessageToChat(
      true,
      text,
      '10:02 AM',
      'assets/images/boy-face-avatar-cartoon-free-vector.jpg',
    );

    var response = await http.post(
      Uri.parse(
          'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/api/chat?userInput=$text'),
    );

    if (response.statusCode == 200) {
      addMessageToChat(
        false,
        response.body,
        '10:03 AM',
        'assets/images/cute-robot-operating-laptop-cartoon-icon.jpg',
      );
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SlideMenu(
          username: widget.userName,
          userId: widget.userId,
        ),
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Chat Page',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 227, 225, 225),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent.withOpacity(0.0),
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
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(16.0),
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return MessageBubble(
                    // Pass appropriate parameters here
                    isSender: messages[index].isSender,
                    message: messages[index].message,
                    time: messages[index].time,
                    imageUrl: messages[index].imageUrl,
                  );
                },
              ),
            ),
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
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
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        sendMessage(_messageController.text);
                        _messageController.clear();
                      }
                    },
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


