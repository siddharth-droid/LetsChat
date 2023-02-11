import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Widgets import
import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/screens/auth_screen.dart';

//firebase core plugin
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // no firebase default has been created solution
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ChatApp',
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.light,
        // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.amber),
        colorScheme:
            Theme.of(context).colorScheme.copyWith(secondary: Colors.black),
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.amber,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      // the auth state change gives us a stream and this stream wil emit a new value everytime the auth state changes when we sign up,
      // login ,logout and also when the app is loading it will also check if there is a cached token and that caching and storage
      // will be managed by firebase
      // and if it finds such a token it will still validate the token and will use that token even after a new app startup
      // the builder will fire everytime the auth state changes
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            // in this function we then can return different widgets based on the user snapshot
            if (userSnapshot.hasData) // if we find token
            {
              return ChatScreen();
            }
            return AuthScreen(); // if we dont find token then we need to authenticate
          }),
    );
  }
}
