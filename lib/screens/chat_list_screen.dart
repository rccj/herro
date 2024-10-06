import 'package:flutter/material.dart';
import 'package:konwyou/screens/chat_room.dart';
import 'chat_room.dart'; // Comment this out if the file doesn't exist

class ChatListScreen extends StatelessWidget {
  final List<ChatPreview> chatPreviews = [
    ChatPreview(
      name: "Alice",
      lastMessage: "Hey, how are you?",
      imageUrl: "https://picsum.photos/id/1001/100/100",
      messages: [
        ChatMessage(text: "Hey, how are you?", isMe: false),
        ChatMessage(text: "I'm good, thanks! How about you?", isMe: true),
      ],
    ),
    ChatPreview(
      name: "Bob",
      lastMessage: "Want to meet up?",
      imageUrl: "https://picsum.photos/id/1002/100/100",
      messages: [
        ChatMessage(text: "Hey, want to grab coffee?", isMe: false),
        ChatMessage(text: "Sure, when and where?", isMe: true),
        ChatMessage(text: "How about tomorrow at 3 PM?", isMe: false),
      ],
    ),
    ChatPreview(
      name: "Charlie",
      lastMessage: "That's great!",
      imageUrl: "https://picsum.photos/id/1003/100/100",
      messages: [
        ChatMessage(text: "I got the job!", isMe: false),
        ChatMessage(text: "Congratulations! That's awesome news!", isMe: true),
        ChatMessage(text: "Thanks! I'm so excited!", isMe: false),
        ChatMessage(text: "You deserve it. Let's celebrate soon!", isMe: true),
        ChatMessage(text: "That's great!", isMe: false),
      ],
    ),
    ChatPreview(
      name: "Diana",
      lastMessage: "See you tomorrow!",
      imageUrl: "https://picsum.photos/id/1004/100/100",
      messages: [
        ChatMessage(text: "Are we still on for tomorrow?", isMe: true),
        ChatMessage(text: "Yes, definitely!", isMe: false),
        ChatMessage(text: "Great, what time should we meet?", isMe: true),
        ChatMessage(text: "How about 2 PM?", isMe: false),
        ChatMessage(text: "Sounds good. See you tomorrow!", isMe: true),
        ChatMessage(text: "See you tomorrow!", isMe: false),
      ],
    ),
    ChatPreview(
      name: "Ethan",
      lastMessage: "The movie was amazing!",
      imageUrl: "https://picsum.photos/id/1005/100/100",
      messages: [
        ChatMessage(text: "Have you seen the new superhero movie?", isMe: false),
        ChatMessage(text: "Not yet, is it good?", isMe: true),
        ChatMessage(text: "It's fantastic! You should definitely watch it.", isMe: false),
        ChatMessage(text: "Thanks for the recommendation. I'll check it out this weekend.", isMe: true),
        ChatMessage(text: "The movie was amazing!", isMe: false),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('聊天列表'),
      ),
      body: ListView.builder(
        itemCount: chatPreviews.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(chatPreviews[index].imageUrl),
            ),
            title: Text(chatPreviews[index].name),
            subtitle: Text(chatPreviews[index].lastMessage),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoom(chatPartner: chatPreviews[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatPreview {
  final String name;
  final String lastMessage;
  final String imageUrl;
  final List<ChatMessage> messages;

  ChatPreview({
    required this.name,
    required this.lastMessage,
    required this.imageUrl,
    required this.messages,
  });
}