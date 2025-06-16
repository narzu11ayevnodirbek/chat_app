import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chat_app/core/services/web_socket_services.dart';
import 'package:chat_app/features/chat/data/models/message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'chat_event.dart';
part 'chat_state.dart';
part 'chat_bloc.freezed.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  List<Message> chat = [];
  late Box<Message> chatBox;

  ChatBloc() : super(const ChatState.success([])) {
    _init();

    on<_FetchChat>(_fetchChat);
    on<_AddData>(_onAddData);
    on<_SendMessage>(_onSendMessage);
    on<_DeleteMessage>(_onDeleteMessage);
  }

  void _init() async {
    Hive.registerAdapter(MessageAdapter());
    chatBox = await Hive.openBox<Message>('chatBox');
    chat = chatBox.values.toList().reversed.toList();
    add(ChatEvent.fetchChat());

    WebSocketServices.getInstance(
      "wss://s14781.nyc1.piesocket.com/v3/1?api_key=kLgGoDV7ablppHkpGtqwvb1kGOru8svXMwpu47C3&notify_self=1",
    );

    WebSocketServices.channel.stream.listen((event) {
      if (event is String && event.isNotEmpty) {
        try {
          final message = Message.fromJson(json.decode(event));
          add(ChatEvent.addData(message));
        } catch (e) {
          print("Xatolik: $e");
        }
      }
    });
  }

  void _fetchChat(_FetchChat event, Emitter<ChatState> emit) {
    emit(ChatState.success(chat));
  }

  void _onAddData(_AddData event, Emitter<ChatState> emit) {
    chat = [event.data, ...chat];
    chatBox.add(event.data);
    add(ChatEvent.fetchChat());
  }

  void _onSendMessage(_SendMessage event, Emitter<ChatState> emit) {
    WebSocketServices.channel.sink.add(json.encode(event.data.toJson()));
  }

  void _onDeleteMessage(_DeleteMessage event, Emitter<ChatState> emit) {
    chat.removeAt(event.index);
    chatBox.deleteAt(chatBox.length - 1 - event.index);
    add(ChatEvent.fetchChat());
  }
}
