// import 'package:bloc/bloc.dart';
import 'package:chat_app/core/services/app_bloc_observer.dart';
import 'package:chat_app/features/chat/view/blocs/chat_bloc.dart';
import 'package:chat_app/features/chat/view/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc()..add(ChatEvent.fetchChat()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const ChatPage(),
      ),
    );
  }
}
