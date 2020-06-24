import 'dart:io';

import 'package:chatsapp/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthCard extends StatefulWidget {
  final void Function(BuildContext context, String email, String username,
      String password, File image, bool isLogin) submitForm;
  const AuthCard(this.submitForm);
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  var email = '';
  var password = '';
  var username = '';
  bool _isLogin = true;
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _key = GlobalKey<FormState>();
  File _userImageFile;

  void pickedImage(File image) {
    _userImageFile = image;
  }

  void saveForm() {
    final valid = _key.currentState.validate();

    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('please pick an image'),
        duration: Duration(seconds: 1),
      ));
      return;
    }
    if (valid) {
      _key.currentState.save();
      widget.submitForm(
          context, email.trim(), username, password, _userImageFile, _isLogin);
    }
  }

  @override
  void dispose() {
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      margin: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (!_isLogin) USerImagePicker(pickedImage),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email'),
                  onFieldSubmitted: (_) {
                    _isLogin
                        ? FocusScope.of(context).requestFocus(_usernameFocus)
                        : FocusScope.of(context).requestFocus(_passwordFocus);
                  },
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email id';
                    } else
                      return null;
                  },
                  onSaved: (value) {
                    email = value;
                  },
                ),
                if (!_isLogin)
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: 'Username'),
                    focusNode: _usernameFocus,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_passwordFocus),
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Username length should be greater than 5';
                      } else
                        return null;
                    },
                    onSaved: (value) {
                      username = value;
                    },
                  ),
                TextFormField(
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  focusNode: _passwordFocus,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).unfocus();
                    saveForm();
                  },
                  validator: (value) {
                    if (value.isEmpty || value.length < 7) {
                      return 'Password is too short';
                    } else
                      return null;
                  },
                  onSaved: (value) {
                    password = value;
                  },
                ),
                SizedBox(height: 10),
                RaisedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    saveForm();
                  },
                  child: Text(
                    _isLogin ? 'Login' : 'Sign up',
                  ),
                ),
                FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(_isLogin
                        ? 'create a new account'
                        : 'Already have an account'))
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
