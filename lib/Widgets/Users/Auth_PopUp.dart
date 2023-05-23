import 'package:flutter/material.dart';
import 'Image_Picker.dart';
import 'dart:io';

class Auth_PopUp extends StatefulWidget {
  Auth_PopUp(this.authenticating, this.acceptUser, {super.key}); //Constructor yhi declare
  //aur constructor mai jo jo var expect kr rahe ho. wo declare

  bool authenticating ;
  final void Function(String email, String username, String password,
  File? pickedFile, bool isLogin, BuildContext ctx) acceptUser;

  //function bhi ek variable hi
  //function chahiye jo void return kre aur ye parameter le.

  @override
  State<Auth_PopUp> createState() => _Auth_PopUpState();
}

class _Auth_PopUpState extends State<Auth_PopUp> {
  final _formKey = GlobalKey<FormState>();

  bool _isLogin = true;

  String _email = '';
  String _username = ''; // ? lagane se mtlb ki ye null ho skta hai.
  String _password = '';
  File? _file ;

  void _imageHolder(File image) {
    _file = image ;
  }
  ///Form ka field - isse say - sare textfields ka ek hi baar mai validation/save kr leta hai.
  ///baki userInput mai koi error nahi hua, image hai sb dala hai to function call kr du us input ke saath
  void _onSubmit() {
    // void [return type dena hota hai] function to hai hi wo to syntax pata lag raha .
    // Mai function type likh raha tha , mtlb function return krega.
    final _isValid = _formKey.currentState!
        .validate(); //Ye null check bhi sahi kaam krta hai.
    if (!_isLogin && _file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an Image!'),
        ),
      );
      return;
    }
    if (_isValid) {
      FocusScope.of(context).unfocus();
      _formKey.currentState!.save();
      widget.acceptUser(
          _email.trim(),
          _username.trim(),
          //isse kya hai extra space first aur last mai [galti se] to wo remove,wrna string matching mai issue.
          _password.trim(),
          _file,
          _isLogin,
          context //Ye Auth_PopUp ke state ka jise iska build bhi leta hai , hr build apne widget ka hi state leta hoga mp.
      );
    }
  }

  ///login method ke according banega . Elevated button - onPressed - yeh upar wala method chalega.
  ///TextButton - pressed pai signing status field change krne ka setState chala dega.
  ///onSaved mai kya hai - jo input use apne class variables ko de dete hai.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin) Image_Picker(_imageHolder),
                TextFormField(
                  key: const ValueKey('email'),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  //key helps because it is maintained as array , as the array size ws changing from 3 to 2.
                  //the element of index 0 and 1 got assigned respectively although username[1] should not be assigned to password[new 1].
                  validator: (input) {
                    if (input!.isEmpty || !input.contains('@')) {
                      return 'Please provide a valid e-mail';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "Email"),
                  onSaved: (input) {
                    _email = input!;
                  },
                ),
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('username'),
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    validator: (input) {
                      if (input!.length < 4) {
                        return 'Please provide a Username of atleast 4 characters';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: "Username"),
                    onSaved: (input) {
                      _username = input!;
                    },
                  ),
                TextFormField(
                  key: const ValueKey('password'),
                  validator: (input) {
                    if (input!.length < 7) {
                      return 'Please provide atleast 7 characters!';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: "Password"),
                  onSaved: (input) {
                    _password = input!;
                  },
                  obscureText: true,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                (!widget.authenticating)
                    ? ElevatedButton(
                        onPressed: _onSubmit,
                        //pointer whose function  gets executed every time
                        child: Text(_isLogin ? 'Login' : 'SignUp'),
                      )
                    : const CircularProgressIndicator(),
                TextButton(
                  onPressed: () => setState(() {
                    _isLogin = !_isLogin;
                  }),
                  child: Text(
                    _isLogin
                        ? 'Create a new Account'
                        : 'I already have an account',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
