// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables, camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'constants.dart';

class userName extends StatefulWidget {
  userName(this._usernameController,{Key? key}) : super(key: key);
  final TextEditingController _usernameController;
  @override
  _userNameState createState() => _userNameState();
}

class _userNameState extends State<userName> {

  FocusNode usernameFocusNode = FocusNode();



  @override
  void dispose() {
    usernameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (node, event) {
        if(event.logicalKey == LogicalKeyboardKey.tab){
          FocusScope.of(context).nextFocus();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: TextFormField(
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        style: const TextStyle(fontSize: AppConstants.defaultFontSize),
        controller: widget._usernameController,
        validator: (value) => value!.isEmpty ? "User name required" : null,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            focusColor:  Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),

            ),
            filled: true,
            prefixIcon: const Icon(Icons.person),
            hintStyle: TextStyle(color: Colors.grey[800]),
            hintText: "Type your User name",
            fillColor: AppColors.hoverColor),
      ),
    );
  }
}
