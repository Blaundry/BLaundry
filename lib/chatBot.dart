import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  DialogFlowtter? dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    DialogFlowtter.fromFile(path: "assets/laundrybot.json").then((instance) {
      setState(() {
        dialogFlowtter = instance;
      });
    }).catchError((e) {
      debugPrint("Error initializing DialogFlowtter: $e");
    });
  }

  void sendMessage(String text) async {
    if (text.isEmpty || dialogFlowtter == null) return;

    setState(() {
      messages.add({'isUser': true, 'message': text});
    });

    _controller.clear();

    try {
      DetectIntentResponse response = await dialogFlowtter!.detectIntent(
        queryInput: QueryInput(text: TextInput(text: text)),
      );

      if (response.message != null && response.message!.text != null) {
        setState(() {
          messages.add({
            'isUser': false,
            'message': response.message!.text!.text?.first ?? 'No response',
          });
        });
      }
    } catch (e) {
      debugPrint("Error sending message: $e");
      setState(() {
        messages.add({
          'isUser': false,
          'message': "Error occured.",
        });
      });
    }
  }

  Widget _buildMessage(Map<String, dynamic> msg) {
    return Align(
      alignment: msg['isUser'] ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: msg['isUser'] ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          msg['message'],
          style: TextStyle(
            color: msg['isUser'] ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LaundryBot Chat', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF05588A),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) => _buildMessage(messages[messages.length - 1 - index]),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Enter message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF05588A)),
                  onPressed: () => sendMessage(_controller.text.trim()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    dialogFlowtter?.dispose();
    _controller.dispose();
    super.dispose();
  }
}
