import 'package:firebase_day36/providers/chat_room_provider.dart';
import 'package:firebase_day36/widgets/main_drawer.dart';
import 'package:firebase_day36/widgets/message_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoomPage extends StatefulWidget {
  static const routeName = '/chat';

  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  bool isFirst = true;
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (isFirst) {
      Provider.of<ChatRoomProvider>(context, listen: false)
          .getChatRoomMessages();
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text("Chat Room"),
      ),
      body: Consumer<ChatRoomProvider>(
        builder: (context, provider, _) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                  itemCount: provider.msgList.length,
                  itemBuilder: (context, index) {
                    final messageModel = provider.msgList[index];
                    return MessageItem(messageModel: messageModel);
                  }),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24)),
                        hintText: "Type your message here"),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (textController.text.isEmpty) return;
                    provider.addMessage(textController.text);
                    textController.clear();
                  },
                  icon: Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
