///Ek boolean rakha hai sendable to check textfield controller.data empty to nhi before sending.
///button dabne pai setSTate call for sendable validation - fir uske basis pai send method call ya nahi

///send method - userAuthData layega from FireBaseAuth,instance.currUSer se,
///ab isse foirestore users mai apna user find krke uska data retrieve
///mssg ko chats mai dalega firebase ke - ab isse re-render hoga all messages.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class newMessage extends StatefulWidget {
  const newMessage({Key? key}) : super(key: key);

  @override
  State<newMessage> createState() => _newMessageState();
}

class _newMessageState extends State<newMessage> {
  var tc = TextEditingController();
  bool sendable = false;

  void send() async {
    FocusScope.of(context).unfocus();
    final currUser = FirebaseAuth.instance.currentUser ;
    final userData = await FirebaseFirestore.instance.collection('users').doc(currUser!.uid).get() ;
    FirebaseFirestore.instance.collection('chats').add({
      'text': tc.text,
      //Ye aise hi jaa raha tha , empty since isko change hi nhi kiya input lene pai , mujh laga kaam nahi kr raha
      //card widget display kr raha tha , wo space occupy kr raha tha pr text nhi aa rha tha.
      //firebase database mai document ban rahe the pr empty text ke saath.
      //isse ye conclusion nikalte ki text empty ho raha pr allMessages kaam kr raha hai ,
      //saath hi new Message bhi bhej raha hai , bs text nhi jaa raha saath mai.
      'createdAt': Timestamp.now(),
      'imageUrl' : userData['imageUrl'],
      'userId' : currUser.uid , //phle future hua krta tha ab nahi hai
    });
    tc.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4.0), //outside
      padding: const EdgeInsets.all(8.0), //inside
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              controller: tc,
              decoration: const InputDecoration(labelText: 'Send a message...'),
              onChanged: (change) {
                setState(() {
                  sendable = tc.text.trim().isNotEmpty;
                });
              },
            ),
          ),
          IconButton(
            onPressed: sendable ? send : null,
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
    );
  }
}
