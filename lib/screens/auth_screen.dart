import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:chatapp/widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth
      .instance; // gives us instance to the firebase auth object which is automatically setup and managed by firebase package

  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String userName,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) async {
    // now using firebase SDK to create a new user
    UserCredential authresult;

    //as async await can potentially fail
    try {
      setState(() {
        // to change the signup button to a loading spinner whilst we are waiting for a result
        _isLoading = true;
      });
      if (isLogin) {
        //used async await as signinwithemailandpassword is a future user credential
        authresult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authresult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // adding user after the signup  is successfull using firestore instance to add extra data ->> to add username// importing firestore

        //reaching out to the users collection, this collection doesnt exist yet but will be created on the fly
        //there we target a specific document which uses the id of our user as id
        // normally if we add document by .add() method a new id is generated dynamically , we dont want that here
        // instead we use doc to access existing users id

        // as set returns a future so we use await
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authresult.user?.uid)
            .set({
          // the extra document you stored is a map in flutter , you can have any key value pairs as you want
          'username': userName,
          'email': email
        });
      }
    } on PlatformException catch (err) {
      // catching specific platform exception error using keyword on
      var message = "An error occured, please check your connection";
      if (err.message != null) {
        // message = err.message!;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.black,
        ),
      );

      setState(() {
        _isLoading = false; // back to false if we have an error
      });
    } catch (err) // any other error or exception
    {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(
          _submitAuthForm,
          _isLoading,
        ));
  }
}
