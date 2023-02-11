import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:chatapp/widgets/chat/messages.dart';
import 'package:chatapp/widgets/chat/new_message.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlutterChat'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout')
                    ],
                  ),
                ),
                value: 'logout',
              )
            ],
            //itemidentifier so the value specified here(value:'logout'), if you had multiple items you could find out which
            //item was pressed by looking at the itemidentifier
            // here of course i have only one item still for completeness sake we use itemidentifier is equal to logout which should be
            // as its our only value
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                //if logout then logout // using firebase_auth package
                FirebaseAuth.instance.signOut();
                // now if we click logout , if will automatically destory the token and emit a new event in main.dart home streambuilder
                //onauthstatechanged and there we will find out that we no longer have a token and will take us back to auth screen
              }
            },
          )
        ],
      ),
      // now in body instead of having a streambuilder we create a container
      body: Container(
        child: Column(
          children: <Widget>[
            // messages ofcourse return a listview at the end and a listview inside a coulumn wouldnt work that well
            // so we wrap it inside an expanded otherwise we get an error
            // now it ensures that listview only takes that much space as available in the current screen whilst being scrollable
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
