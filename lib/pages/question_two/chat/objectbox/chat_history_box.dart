import 'package:objectbox/objectbox.dart';

@Entity()
class ChatHistoryBox {
  @Id()
  int id;

  @Property()
  final String chatId;

  @Property()
  final String prompt;

  @Property()
  final String response;

  @Property()
  final List<String> imagesUrls;

  @Property()
  final DateTime timestamp;

  ChatHistoryBox({
    this.id = 0,
    required this.chatId,
    required this.prompt,
    required this.response,
    required this.imagesUrls,
    required this.timestamp,
  });
}
