import 'package:flutter/material.dart';
import 'chat_list_screen.dart';

class ChatRoom extends StatefulWidget {
  final ChatPreview chatPartner;

  const ChatRoom({Key? key, required this.chatPartner}) : super(key: key);

  @override
  ChatRoomState createState() => ChatRoomState();
}

class ChatRoomState extends State<ChatRoom> {
  late List<ChatMessage> messages;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    messages = List.from(widget.chatPartner.messages.reversed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(  
              backgroundImage: NetworkImage(widget.chatPartner.imageUrl),
            ),
            SizedBox(width: 10),
            Text(widget.chatPartner.name),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return messages[index];
              },
            ),
          ),
          buildMessageComposer(),
        ],
      ),
    );
  }

  Widget buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: '输入消息...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: handleSubmitted,
          ),
        ],
      ),
    );
  }

  void handleSubmitted() {
    if (textController.text.isNotEmpty) {
      ChatMessage message = ChatMessage(
        text: textController.text,
        isMe: true,
      );
      setState(() {
        messages.insert(0, message);
      });
      textController.clear();
      scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      
      // 模拟对方回复
      Future.delayed(Duration(seconds: 1), () {
        ChatMessage reply = ChatMessage(
          text: '这是一个自动回复消息',
          isMe: false,
        );
        setState(() {
          messages.insert(0, reply);
        });
        scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isMe;

  const ChatMessage({
    Key? key,
    required this.text,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 8.0),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.0),
        ],
      ),
    );
  }
}