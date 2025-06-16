import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 0)
class Message {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final String time;

  Message({required this.name, required this.message, required this.time});

  Map<String, dynamic> toJson() => {
    "name": name,
    "message": message,
    "time": time,
  };

  factory Message.fromJson(Map<String, dynamic> json) =>
      Message(name: json["name"], message: json["message"], time: json["time"]);
}
