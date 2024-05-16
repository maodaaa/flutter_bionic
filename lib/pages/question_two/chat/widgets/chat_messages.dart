import 'package:bionic/pages/question_two/chat/controller/chat_controller.dart';
import 'package:bionic/pages/question_two/chat/widgets/assistance_message_widget.dart';
import 'package:bionic/pages/question_two/chat/widgets/my_message_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({
    super.key,
    required this.scrollController,
    required this.chatController,
  });

  final ScrollController scrollController;
  final ChatController chatController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        controller: scrollController,
        itemCount: chatController.inChatMessages.length,
        itemBuilder: (context, index) {
          final message = chatController.inChatMessages[index];
          return message.isUser == true
              ? MyMessageWidget(message: message)
              : AssistantMessageWidget(message: message.message.toString());
        },
      ),
    );
  }
}
