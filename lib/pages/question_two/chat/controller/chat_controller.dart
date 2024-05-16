import 'dart:async';
import 'dart:typed_data';
import 'package:bionic/app_initializer.dart';
import 'package:bionic/constants/app_constants.dart';
import 'package:bionic/constants/env.dart';
import 'package:bionic/objectbox.g.dart';
import 'package:bionic/pages/question_two/chat/models/message.dart';
import 'package:bionic/pages/question_two/chat/objectbox/chat_history_box.dart';
import 'package:bionic/pages/question_two/chat/objectbox/message_box.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  final historyBox = objectbox.store.box<ChatHistoryBox>();
  final messageBox = objectbox.store.box<MessageBox>();

  final _inChatMessages = <Message>[].obs;
  final _pageController = PageController().obs;
  final _imagesFileList = <XFile>[].obs;
  final _currentIndex = 0.obs;
  final _currentChatId = ''.obs;
  final _isLoading = false.obs;

  late final GenerativeModel _textModel;
  late final GenerativeModel _visionModel;
  GenerativeModel? _model;

  List<Message> get inChatMessages => _inChatMessages;
  PageController get pageController => _pageController.value;
  List<XFile> get imagesFileList => _imagesFileList;
  int get currentIndex => _currentIndex.value;
  String get currentChatId => _currentChatId.value;
  GenerativeModel? get model => _model;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _textModel = GenerativeModel(
      model: AppConstants.modelGeminiPro,
      apiKey: Env.geminiKey,
    );
    _visionModel = GenerativeModel(
      model: AppConstants.modelGeminiProVision,
      apiKey: Env.geminiKey,
    );
  }

  Future<void> setInChatMessages(String chatId) async {
    final messagesFromDB = await _loadMessagesFromDB(chatId: chatId);
    _inChatMessages.value = [
      ..._inChatMessages,
      ...messagesFromDB.where((message) => !_inChatMessages.contains(message)),
    ];
  }

  void setImagesFileList(List<XFile> listValue) {
    _imagesFileList.value = listValue;
  }

  Future<void> setModel(bool isTextOnly) async {
    _model = isTextOnly ? _textModel : _visionModel;
  }

  void setCurrentIndex(int newIndex) {
    _currentIndex.value = newIndex;
  }

  void setCurrentChatId(String newChatId) {
    _currentChatId.value = newChatId;
  }

  Future<List<Message>> _loadMessagesFromDB({required String chatId}) async {
    final messages = messageBox.query(MessageBox_.chatId.equals(chatId)).build().find();
    return messages
        .map((messageBox) => Message(
              messageId: messageBox.messageId,
              chatId: messageBox.chatId,
              isUser: messageBox.isUser,
              message: StringBuffer(messageBox.message),
              imagesUrls: messageBox.imagesUrls,
              timeSent: messageBox.timeSent,
            ))
        .toList();
  }

  Stream<List<ChatHistoryBox>> getUniqueChatHistoriesStream() {
    final streamController = StreamController<List<ChatHistoryBox>>();

    final subscription = historyBox.query().watch(triggerImmediately: true).listen((event) {
      final allChatHistories = historyBox.getAll();
      final uniqueChatIds = <String>{};
      final uniqueChatHistories = <ChatHistoryBox>[];

      for (var chatHistory in allChatHistories) {
        if (uniqueChatIds.add(chatHistory.chatId)) {
          uniqueChatHistories.add(chatHistory);
        }
      }

      streamController.add(uniqueChatHistories.reversed.toList());
    });

    streamController.onCancel = () {
      subscription.cancel();
      streamController.close();
    };

    return streamController.stream;
  }

  Future<void> deleteChatMessages(String chatId) async {
    historyBox.query(ChatHistoryBox_.chatId.equals(chatId)).build().remove();

    if (currentChatId == chatId) {
      setCurrentChatId('');
      _inChatMessages.clear();
      update();
    }
  }

  Future<void> prepareChatRoom({
    required bool isNewChat,
    required String chatID,
  }) async {
    if (!isNewChat) {
      final chatHistory = await _loadMessagesFromDB(chatId: chatID);
      _inChatMessages.clear();
      _inChatMessages.addAll(chatHistory);
      setCurrentChatId(chatID);
      update();
    } else {
      _inChatMessages.clear();
      setCurrentChatId(chatID);
      update();
    }
  }

  Future<void> sentMessage({
    required String message,
    required bool isTextOnly,
  }) async {
    await setModel(isTextOnly);
    _isLoading.value = true;

    String chatId = getChatId();
    List<Content> history = await _getHistory(chatId: chatId);
    List<String> imagesUrls = _getImagesUrls(isTextOnly: isTextOnly);

    final userMessageId = const Uuid().v4();
    final assistantMessageId = const Uuid().v4();

    final userMessage = Message(
      messageId: userMessageId.toString(),
      chatId: chatId,
      isUser: true,
      message: StringBuffer(message),
      imagesUrls: imagesUrls,
      timeSent: DateTime.now(),
    );

    _inChatMessages.add(userMessage);

    if (currentChatId.isEmpty) {
      setCurrentChatId(chatId);
    }

    await _sendMessageAndWaitForResponse(
      message: message,
      chatId: chatId,
      isTextOnly: isTextOnly,
      history: history,
      userMessage: userMessage,
      modelMessageId: assistantMessageId.toString(),
    );
    update();
  }

  Future<void> _sendMessageAndWaitForResponse({
    required String message,
    required String chatId,
    required bool isTextOnly,
    required List<Content> history,
    required Message userMessage,
    required String modelMessageId,
  }) async {
    final chatSession = _model!.startChat(
      history: history.isEmpty || !isTextOnly ? null : history,
    );

    final content = await _getContent(
      message: message,
      isTextOnly: isTextOnly,
    );

    final assistantMessage = userMessage.copyWith(
      messageId: modelMessageId,
      isUser: false,
      message: StringBuffer(),
      timeSent: DateTime.now(),
    );

    _inChatMessages.add(assistantMessage);

    chatSession.sendMessageStream(content).asyncMap((event) {
      return event;
    }).listen((event) {
      _inChatMessages.value = _inChatMessages.map((element) {
        if (element.messageId == assistantMessage.messageId && element.isUser == false) {
          return element.copyWith(
            message: element.message..write(event.text),
          );
        }
        return element;
      }).toList();
    }, onDone: () async {
      await _saveMessagesToDB(
        chatID: chatId,
        userMessage: userMessage,
        assistantMessage: assistantMessage,
      );
      _isLoading.value = false;
    }).onError((error, stackTrace) {
      _isLoading.value = false;
    });
    update();
  }

  Future<void> _saveMessagesToDB({
    required String chatID,
    required Message userMessage,
    required Message assistantMessage,
  }) async {
    await messageBox.putAsync(MessageBox(
      messageId: userMessage.messageId,
      chatId: userMessage.chatId,
      isUser: userMessage.isUser!,
      message: userMessage.message.toString(),
      imagesUrls: userMessage.imagesUrls,
      timeSent: userMessage.timeSent,
    ));
    await messageBox.putAsync(MessageBox(
      messageId: assistantMessage.messageId,
      chatId: assistantMessage.chatId,
      isUser: assistantMessage.isUser!,
      message: assistantMessage.message.toString(),
      imagesUrls: assistantMessage.imagesUrls,
      timeSent: assistantMessage.timeSent,
    ));

    final chatHistory = ChatHistoryBox(
      chatId: chatID,
      prompt: userMessage.message.toString(),
      response: assistantMessage.message.toString(),
      imagesUrls: userMessage.imagesUrls,
      timestamp: DateTime.now(),
    );

    await historyBox.putAsync(chatHistory);
  }

  Future<Content> _getContent({
    required String message,
    required bool isTextOnly,
  }) async {
    if (isTextOnly) {
      return Content.text(message);
    } else {
      final imageBytes = await Future.wait(
        _imagesFileList.map((imageFile) => imageFile.readAsBytes()).toList(),
      );
      final prompt = TextPart(message);
      final imageParts = imageBytes.map((bytes) => DataPart('image/jpeg', Uint8List.fromList(bytes))).toList();
      return Content.multi([prompt, ...imageParts]);
    }
  }

  List<String> _getImagesUrls({required bool isTextOnly}) {
    return isTextOnly ? [] : _imagesFileList.map((image) => image.path).toList();
  }

  Future<List<Content>> _getHistory({required String chatId}) async {
    await setInChatMessages(chatId);
    return _inChatMessages.map((message) {
      if (message.isUser == true) {
        return Content.text(message.message.toString());
      } else {
        return Content.model([TextPart(message.message.toString())]);
      }
    }).toList();
  }

  String getChatId() {
    return currentChatId.isEmpty ? const Uuid().v4() : currentChatId;
  }
}
