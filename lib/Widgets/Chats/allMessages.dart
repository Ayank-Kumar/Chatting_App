///Ye bhai firestore database se chats retrieve krega , tb tk progressIndicator()
/// Yaha pai stream builder, jb bhi koi mssg sent (through firestore methods) --> to provider[ChatProvider type] ko --> wo sends snapshot to re-render
/// CurrUser FireBaseAuth se currUser method (e.g ek baar authenticate to auth provider rakhega).Ye Use ki left mai ya right mai

///i think hr new message pai screen re-render - to each mssg . I would like to do widget recycling for all above
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'MessageBubble.dart';

class allMessages extends StatelessWidget {
  const allMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currUser = FirebaseAuth.instance.currentUser ;
    return StreamBuilder(
        //phle se bhare hue the jo bina timestamp ke the , wo to ayenge hi nhi  agar orderBy timestamp kr denge toh.
        stream: FirebaseFirestore.instance
            .collection('chats')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, messagesSnapshot) {
          if (messagesSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(), //isse phli baar mai terminal ek error dikha raha tha [ ki abhi null hai ] wo hat gaya.
            );
          }

          final chatdocs = messagesSnapshot.data!.docs;

          return ListView.builder(
            //ismai phle se scrollable de rakha hota hai
            reverse: true,
            itemCount: chatdocs.length,
            itemBuilder: (ctx, idx) => MessageBubble(
              chatdocs[idx]['text'],
              chatdocs[idx]['userId'] == currUser!.uid,
              chatdocs[idx]['userId'],
              chatdocs[idx]['imageUrl'],
              ValueKey(chatdocs[idx].id),
            ),
          );
        });
  }
}
