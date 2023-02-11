import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  //creating controller to clear input text field after the message is sent
  final _controller = new TextEditingController();

  // to manage state as we only want the button to appear if something has been input
  var _enteredMessage = '';

  void _sendMessage() {
    FocusScope.of(context)
        .unfocus(); // to close the keyboard which might be open after sending a message

    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt':
          Timestamp.now(), // creating timestamp to order the messages sent
    });
    _controller.clear(); // calling here and binding with text field
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      // row here as we want to have two items next to each other ->> the actual text input field and send message button
      child: Row(
        children: <Widget>[
          Expanded(
            // expanded again as it might take too much space
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            //enabling/disabling button based on entereedmessage
            onPressed: _enteredMessage.trim().isEmpty
                ? null
                : _sendMessage, // no parenthesis like this _sendMessage(), as we're just poiting at the function
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
