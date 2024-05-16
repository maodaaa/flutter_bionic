import 'dart:io';

import 'package:bionic/pages/question_two/chat/controller/chat_controller.dart';
import 'package:bionic/pages/question_two/chat/models/message.dart';
import 'package:flutter/material.dart';

import 'package:get/get_state_manager/src/simple/get_state.dart';

class PreviewImagesWidget extends StatelessWidget {
  const PreviewImagesWidget({
    super.key,
    this.message,
  });

  final Message? message;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (ChatController controller) {
        final messageToShow = message != null ? message!.imagesUrls : controller.imagesFileList;
        return Container(
          padding: const EdgeInsets.all(14),
          width: MediaQuery.sizeOf(context).width * 0.8,
          height: MediaQuery.sizeOf(context).height * 0.2,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: messageToShow.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(
                    message != null ? message!.imagesUrls[index] : controller.imagesFileList[index].path,
                  ),
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
