import 'package:bionic/constants/app_constants.dart';
import 'package:bionic/pages/question_two/chat/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyHistoryWidget extends StatelessWidget {
  const EmptyHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find<ChatController>();

    return Center(
      child: GestureDetector(
        onTap: () async {
          await chatController.prepareChatRoom(
            isNewChat: true,
            chatID: '',
          );
          chatController.setCurrentIndex(1);
          chatController.pageController.jumpToPage(1);
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            AppConstants.emptyHistoryPlaceholder,
          ),
        ),
      ),
    );
  }
}
