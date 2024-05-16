import 'package:bionic/constants/app_constants.dart';
import 'package:bionic/pages/question_two/chat/controller/chat_controller.dart';
import 'package:bionic/pages/question_two/chat/objectbox/chat_history_box.dart';
import 'package:bionic/pages/question_two/chat/utility/utilites.dart';
import 'package:bionic/pages/question_two/chat/widgets/empty_history_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../widgets/bottom_chat_field.dart';
import '../widgets/chat_messages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final chatController = Get.find<ChatController>();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && _scrollController.position.maxScrollExtent > 0.0) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      init: ChatController(),
      builder: (ChatController controller) {
        if (controller.inChatMessages.isNotEmpty) {
          _scrollToBottom();
        }

        controller.addListener(() {
          if (controller.inChatMessages.isNotEmpty) {
            _scrollToBottom();
          }
        });
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            centerTitle: true,
            title: const Text('Chat with Gemini'),
            actions: [
              controller.inChatMessages.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        iconSize: 28,
                        icon: const Icon(
                          Icons.edit_note_outlined,
                        ),
                        onPressed: () async {
                          showMyAnimatedDialog(
                            context: context,
                            title: 'Start New Chat',
                            content: 'Are you sure you want to start a new chat?',
                            actionText: 'Yes',
                            onActionPressed: (value) async {
                              if (value) {
                                await controller.prepareChatRoom(isNewChat: true, chatID: '');
                              }
                            },
                          );
                        },
                      ),
                    )
                  : const Center()
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: controller.inChatMessages.isEmpty
                        ? const Center(
                            child: Text('No messages yet'),
                          )
                        : ChatMessages(
                            scrollController: _scrollController,
                            chatController: controller, // Pass the controller
                          ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: BottomChatField(),
                  )
                ],
              ),
            ),
          ),
          drawer: NavigationDrawer(
            chatController: controller, //
          ),
        );
      },
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  final ChatController chatController;
  const NavigationDrawer({super.key, required this.chatController});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 18,
          ),
          const ListTile(
            title: Text(
              'List of Chat History',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ),
          const Divider(),
          StreamBuilder<List<ChatHistoryBox>>(
            stream: chatController.getUniqueChatHistoriesStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final chatHistory = snapshot.data ?? [];
                return chatHistory.isEmpty
                    ? const EmptyHistoryWidget()
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: chatHistory.length,
                        itemBuilder: (context, index) {
                          final chat = chatHistory[index];
                          return HistoryWidget(
                            history: chat,
                            chatController: chatController,
                          );
                        },
                      );
              }
            },
          ),
        ],
      ),
    );
  }
}

class HistoryWidget extends StatelessWidget {
  final ChatHistoryBox history;
  final ChatController chatController;
  const HistoryWidget({
    super.key,
    required this.history,
    required this.chatController,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        history.prompt,
        maxLines: 2,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      ),
      onTap: () async {
        Navigator.pop(context);
        await chatController.prepareChatRoom(
          isNewChat: false,
          chatID: history.chatId,
        );
      },
      onLongPress: () {
        showMyAnimatedDialog(
          context: context,
          title: AppConstants.dialogTitleDelete,
          content: AppConstants.dialogContentDelete,
          actionText: AppConstants.dialogActionDelete,
          onActionPressed: (value) async {
            if (value) {
              await chatController.deleteChatMessages(history.chatId);
            }
          },
        );
      },
    );
  }
}
