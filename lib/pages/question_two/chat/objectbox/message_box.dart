import 'package:objectbox/objectbox.dart';

@Entity()
class MessageBox {
  @Id()
  int id = 0;

  @Property()
  String messageId;

  @Property()
  String chatId;

  @Property()
  bool isUser;

  @Property()
  String message;

  @Property()
  List<String> imagesUrls;

  @Property()
  DateTime timeSent;

  // @Property(type: PropertyType.date)
  // int timeSent; // Storing timestamp as milliseconds since epoch

  // constructor
  MessageBox({
    required this.messageId,
    required this.chatId,
    required this.isUser,
    required this.message,
    required this.imagesUrls,
    required this.timeSent,
  });
}
