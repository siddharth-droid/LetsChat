import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats/KYf0uG4XuLvSGsAHwvcA/messages')
            .snapshots(),
        builder: (ctx, streamSnapshot) {
          // initially when the request is sent behind the scenes at the data is recieved no data is there
          // so we check in our snapshot if our connectionstate is equal to connection state waiting
          //connectionstate is an object in flutter has an waiting property which tells us that currently we re waiting for some data here
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child:
                  CircularProgressIndicator(), // we wont see the indicator as it loads too fast in milliseconds ms
            );
          }

          final documents = streamSnapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (ctx, index) => Container(
              padding: EdgeInsets.all(8),
              child: Text(documents[index]['text']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/KYf0uG4XuLvSGsAHwvcA/messages')
              .add({'text': 'This was added by clicking the button'});
        },
      ),
    );
  }
}
