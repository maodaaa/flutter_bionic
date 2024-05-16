import 'package:bionic/constants/app_constants.dart';
import 'package:bionic/pages/question_two/chat/controller/chat_controller.dart';
import 'package:bionic/pages/question_two/chat/objectbox/chat_history_box.dart';
import 'package:bionic/pages/question_two/chat/utility/utilites.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ChatHistoryWidget extends StatelessWidget {
  const ChatHistoryWidget({
    super.key,
    required this.chat,
  });

  final ChatHistoryBox chat;

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find<ChatController>();
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
        leading: const CircleAvatar(
          radius: 30,
          child: Icon(Icons.chat),
        ),
        title: Text(
          chat.prompt,
          maxLines: 1,
        ),
        subtitle: Text(
          chat.response,
          maxLines: 2,
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () async {
          await chatController.prepareChatRoom(
            isNewChat: false,
            chatID: chat.chatId,
          );
          chatController.setCurrentIndex(1);
          chatController.pageController.jumpToPage(1);
        },
        onLongPress: () {
          showMyAnimatedDialog(
            context: context,
            title: AppConstants.dialogTitleDelete,
            content: AppConstants.dialogContentDelete,
            actionText: AppConstants.dialogActionDelete,
            onActionPressed: (value) async {
              if (value) {
                await chatController.deleteChatMessages(chat.chatId);
                // await chat.delete();
              }
            },
          );
        },
      ),
    );
  }
}
