import 'package:bionic/constants/app_constants.dart';
import 'package:bionic/pages/question_two/chat/controller/chat_controller.dart';
import 'package:bionic/pages/question_two/chat/utility/utilites.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/preview_images_widget.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({super.key});

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  final ChatController chatController = Get.find<ChatController>();

  final TextEditingController textController = TextEditingController();

  final FocusNode textFieldFocus = FocusNode();

  @override
  void dispose() {
    textController.dispose();
    textFieldFocus.dispose();
    super.dispose();
  }

  Future<void> sendChatMessage({
    required String message,
    required bool isTextOnly,
  }) async {
    try {
      await chatController.sentMessage(
        message: message,
        isTextOnly: isTextOnly,
      );
    } catch (e) {
      GetSnackBar(
        title: 'Error',
        message: '$e',
        duration: const Duration(milliseconds: 500),
      );
    } finally {
      textController.clear();
      chatController.setImagesFileList([]);
      textFieldFocus.unfocus();
    }
  }

  // pick an image
  void pickImage() async {
    try {
      final pickedImages = await ImagePicker().pickMultiImage(
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 95,
      );
      chatController.setImagesFileList(pickedImages);
    } catch (e) {
      GetSnackBar(
        title: 'Error',
        message: '$e',
        duration: const Duration(milliseconds: 500),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 218, 218, 218),
          borderRadius: BorderRadius.circular(30),
        ),
        child: SizedBox(
          child: Column(
            children: [
              if (chatController.imagesFileList.isNotEmpty) const PreviewImagesWidget(),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (chatController.imagesFileList.isNotEmpty) {
                        showMyAnimatedDialog(
                            context: context,
                            title: AppConstants.dialogTitleDeleteImg,
                            content: AppConstants.dialogContentDeleteImg,
                            actionText: AppConstants.dialogActionDeleteImg,
                            onActionPressed: (value) {
                              if (value) {
                                chatController.setImagesFileList([]);
                              }
                            });
                      } else {
                        pickImage();
                      }
                    },
                    icon: Icon(chatController.imagesFileList.isNotEmpty ? Icons.delete_forever : Icons.image),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextField(
                      focusNode: textFieldFocus,
                      controller: textController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: chatController.isLoading
                          ? null
                          : (String value) {
                              if (value.isNotEmpty) {
                                sendChatMessage(
                                  message: textController.text,
                                  isTextOnly: chatController.imagesFileList.isEmpty,
                                );
                              }
                            },
                      decoration: InputDecoration.collapsed(
                          hintText: 'Enter  a promt...',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(30),
                          )),
                    ),
                  ),
                  GestureDetector(
                    onTap: chatController.isLoading
                        ? null
                        : () {
                            if (textController.text.isNotEmpty) {
                              sendChatMessage(
                                message: textController.text,
                                isTextOnly: chatController.imagesFileList.isEmpty,
                              );
                            }
                          },
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.all(5.0),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_upward, color: Colors.white),
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
