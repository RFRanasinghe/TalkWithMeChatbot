import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Talk with Me', home: ChatScreen());
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  //Initialize gemini model
  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: 'AIzaSyAn3A9bRjLfYUYkXLoPDMd0CJO60iR-CrI',
  );

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final userText = _controller.text;

    setState(() {
      _messages.add({'sender': 'user', 'text': userText});
      _isLoading = true; // Show loading indicator
      _controller.clear();
    });

    try
    {
      final content = [Content.text(userText)];
      final response = await model.generateContent(content);

      setState(() {
        _messages.add({'sender': 'bot', 'text': response.text ?? 'Sorry, I could not generate a response.'});
        _isLoading = false; // Hide loading indicator
      });

    }
    catch (e)
    {
      setState(() {
        _messages.add({'sender': 'bot', 'text': 'Error: Check your internet and API key.'});
        _isLoading = false; // Hide loading indicator
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Talk With Me')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isUser = _messages[index]['sender'] == 'user';
                return ListTile(
                  title: Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(_messages[index]['text']!),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller)),
                IconButton(onPressed: () {}, icon: Icon(Icons.send)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
