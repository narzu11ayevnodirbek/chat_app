import 'package:chat_app/core/extensions/num_extensions.dart';
import 'package:chat_app/core/extensions/padding_extension.dart';
import 'package:chat_app/core/services/image_service.dart';
import 'package:chat_app/features/chat/data/models/message.dart';
import 'package:chat_app/features/chat/view/widgets/chat_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../blocs/chat_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red),
      body: ChatBody(),
      bottomNavigationBar: IntrinsicHeight(
        child: ColoredBox(
          color: Color(0xFFF6F6F6),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return SafeArea(
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text("Camera"),
                              onTap: () async {
                                Navigator.pop(context);
                                final base64 =
                                    await ImageService.pickAndConvertToBase64(
                                      ImageSource.camera,
                                    );
                                if (base64 != null) {
                                  context.read<ChatBloc>().add(
                                    ChatEvent.sendMessage(
                                      Message(
                                        name: "name",
                                        message: base64,
                                        time: DateTime.now().toIso8601String(),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.photo),
                              title: Text("Gallery"),
                              onTap: () async {
                                Navigator.pop(context);
                                final base64 =
                                    await ImageService.pickAndConvertToBase64(
                                      ImageSource.gallery,
                                    );
                                if (base64 != null) {
                                  context.read<ChatBloc>().add(
                                    ChatEvent.sendMessage(
                                      Message(
                                        name: "name",
                                        message: base64,
                                        time: DateTime.now().toIso8601String(),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: Icon(Icons.add),
              ),
              14.width,
              Expanded(
                child: TextFormField(
                  controller: textEditingController,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<ChatBloc>().add(
                    ChatEvent.sendMessage(
                      Message(
                        name: "name",
                        message: textEditingController.text.trim(),
                        time: DateTime.now().toIso8601String(),
                      ),
                    ),
                  );
                  textEditingController.clear();
                },
                icon: Icon(Icons.send),
              ),
            ],
          ).paddingOnly(bottom: kToolbarHeight),
        ),
      ),
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
