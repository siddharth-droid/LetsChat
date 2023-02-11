import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AuthForm extends StatefulWidget {
  //constructor
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;

  //now to accept argument and store that as in a property of this class
  final void Function(
    String email,
    String userName,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //'_' as they are private and only  be called from inside this class

  //will help to trigger form when login button is pressed
  final _formKey = GlobalKey<FormState>();

  //managing state for switching between login and signup page
  var _isLogin = true;

//storing value in global property
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();

    // will close the soft keyboard as we hit submit
    // will move the focus from text field to nothing
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail
            .trim(), // trim to remove any whitespace in beginning or ending
        _userName.trim(),
        _userPassword.trim(),
        _isLogin,
        context, // so when we calls up function as a last argument of forward my context, because this here is the context that has
        // access to the scaffold here which in turn is the context where the snack bar should be mounter on
        //because of screen context does not have access to scaffold because this scaffold here is rendered by the authscreen
        //the context of auth screen is one level above that so in order to access this scaffold on which the snack bar should be rendered
        //we have to deive into a widget which is inside that scaffold and the context of that widget and just the case for auth form
        // lecture 322 implementation authentication
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  key: ValueKey('email'),
                  validator: (value) {
                    if (value!.isEmpty && value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email address',
                  ),
                  onSaved: (value) {
                    // we dont need setState here because setState would only make one important difference , it would reevaluate
                    //the widget and possibly re render the UI but this is just some behind the scenesdata which we need internally
                    // and changing data has no impact on UI, so there is no need to re-evaluate and re-render the ui hence just saved
                    // like this
                    _userEmail = value!;
                  },
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey('username'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'Username must be atleast 4 characters long';
                      }
                      return null;
                    },
                    // keyboardType, // no keyboard type as we need the default one for username
                    decoration: InputDecoration(labelText: 'Username'),
                    onSaved: (value) {
                      _userName = value!;
                    },
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'Password must be atleast 7 characters long';
                    }
                    return null;
                  },
                  // in keyboard tyoe we have only visible password option therefore using default and then hiding the password
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true, // will hide the text
                  onSaved: (value) {
                    _userPassword = value!;
                  },
                ),
                SizedBox(height: 12),
                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  ElevatedButton(
                    child: Text(_isLogin ? 'Login' : 'Signup'),
                    onPressed: _trySubmit,
                  ),
                if (!widget.isLoading)
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: Text(_isLogin
                        ? 'Create new account'
                        : 'I already have an account'),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
