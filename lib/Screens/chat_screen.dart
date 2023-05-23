///snapshot like a camera with open lenses, so as soon as something on its image changes.
///It clicks and stream back a snapshot with the new data.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; //ye to phla/must import
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/Chats/allMessages.dart';
import '../Widgets/Chats/newMessage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// If you will use other Firebase services in the background such as Firestore.
/// make sure you call `initializeApp` before using other Firebase services.

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //It must not be an anonymous function and a top-level function (e.g. not a class method which requires initialization).
  await Firebase.initializeApp();
  //print("Handling a background message: ${message.messageId}");
}

class Chat_Screen extends StatefulWidget {
  const Chat_Screen({Key? key}) : super(key: key);

  @override
  State<Chat_Screen> createState() => _Chat_ScreenState();
}

class _Chat_ScreenState extends State<Chat_Screen> {
  /// kisi bhi service ko start krte hai - wo service.instance se. Ye initstate mai kr lo
  /// Jaise ismai firebase messaging use - to uske methods
  /// OnMessage - foreground [here you have access to context], onBackGroundMessage - bakground mai app, onMessageOpenedApp - jb background se tap krke app khulega
  /// Jb app hi closed - uske liye nahi kiya ,
  /// Topic wise notification bheji hui thi, subscribeToTopic of that topic.
  void initState() {
    super.initState(); //dena parta hai

    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();

    // Get any messages which caused the application to open from
    // a terminated state.
    fbm.getInitialMessage().then(
          (message) => print('Got a message whilst in the terminated state!'),
    );

    // foreground work
    FirebaseMessaging.onMessage.listen((message) {
      print("huehuehuehuehue");
      //your app is in foreground
      //you can directly access your app's state and context
      return;
    });

    //background mai hai
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // jb background mai notifications aaye , to usko click krne pai ye operate
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("huihuihuihui$message");
      return;
    });
    fbm.subscribeToTopic('chats');
  }

  ///UI to pretty simple - aakhir mai whi DropDownButton use jo shopping mai bhi kiya tha
  ///options ko value de dete hai , or onclicked/selected pai us value ke according kaam jaise yaha pai firebaseAuth ka signout mwthod use
  ///Yaha pai token wegrah restAPI request wgerah , managing data for multiple screens [Provider] sb firebase services dekh rahi hai
  /// provide jaise yaha pai iske signout method se wapis auth screen pai chala gaya ,to yaha isnai auth_Provider wala role nibha diya
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: const Icon(Icons.more_vert),
            items: [
              DropdownMenuItem(
                value: 'LogOut',
                child: Row(
                  children: [
                    Icon(Icons.logout,
                        color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: 10.0),
                    const Text('Log Out')
                  ],
                ),
              ),
            ],
            onChanged: (identifier) {
              //dynamic identifier jisse ye function of dynamic input hua , jo ki chahiye tha
              if (identifier == 'LogOut') FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
//some issues in declaring variable here.
      body: Column(
        children: const [
          Expanded(child: allMessages()),
          //a listview inside of column needs to be put in expanded
          newMessage(),
        ],
      ),
    );
  }
}

class Chat_Messages extends StatelessWidget {
  const Chat_Messages({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder/*<Object> - isse stream generic ho jaa rahi thi , snapshot ke methods use nhi kr paa raha tha*/(
        //ye flutter ka hi hota hai
        stream: FirebaseFirestore.instance
            .collection('allChats/7CQ18D2I9iQCeTzu3Ks7/messages/')
            .snapshots(),
        // ab yaha pai - listener nhi since wo wala part flutter handle
        builder: (context,
            snapshot /*latest data snapshots that we get from the stream*/) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(), //isse phli baar mai terminal ek error dikha raha tha [ ki abhi null hai ] wo hat gaya.
            );
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
            //on the basis of update , flutter will go and check in UI what needs to be updated.
            itemCount: docs.length,
            // docs can be null - to jo can be null uske last mai ?.
            itemBuilder: (context, idx) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(docs[idx]['text']),
            ),
          );
        });
  }
}
