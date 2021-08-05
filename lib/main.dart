import 'package:flutter/material.dart';

import 'package:polls_app/blocs/provider.dart';
import 'package:polls_app/screens/create_poll.dart';
import 'package:polls_app/screens/create_question.dart';

import 'package:polls_app/screens/login.dart';
import 'package:polls_app/screens/home.dart';
import 'package:polls_app/screens/poll_answers.dart';
import 'package:polls_app/screens/user_polls.dart';
import 'package:polls_app/screens/user_pref.dart';

import 'package:polls_app/user_preferences/user_preferences.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'login': (_) => LoginScreen(),
          'home': (_) =>  HomeScreen(),
          'user_pref':  (_) => UserPreferences(),
          'user_polls': (_) => UserPolls(),
          'create_poll':  (_) =>  CreatePoll(),
          'create_question': (_) => CreateQuestion(),
          'poll_answers': (_) => PollAnswers(),
        },
        // theme: myTheme,
      ),
    );
  }
}
