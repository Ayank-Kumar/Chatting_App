/// isMe lega input mai for deciding ternary operators. left ya right rakhna hai
/// to wo row mai rakh liya aur mainaxis alignment iske basis pai

///usrId - t ye future builder se aata hai - tb tk loading... fir firestore se retrieve

/// imageUrl se circular avatar - loadingBuilder ke through [ye network imag mai hota hi hai]

///Key kyunki bhai list of widgets na - to having key helps flutter in maintaining order.
/// otherwise it does on indexes, by this it does on object.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  String message;

  MessageBubble(this.message, this.isMe, this.userId, this.imageUrl, this.Key, {super.key});

  bool isMe;
  String imageUrl;

  String userId;
  final Key;

  @override
  Widget build(BuildContext context) {
    final dimensions = MediaQuery.of(context).size;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: dimensions.width * 0.6,
              ),
              //hmesha aise hi use karo.
              decoration: BoxDecoration(
                color: isMe
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: isMe
                      ? const Radius.circular(12)
                      : const Radius.circular(15),
                  topRight: isMe
                      ? const Radius.circular(15)
                      : const Radius.circular(12),
                  bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
                  bottomRight: isMe ? Radius.zero : const Radius.circular(12),
                ),
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 8.0,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 8.0,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    //khali user ka uid chahiye hota to future ki need nahi parti
                    //pr hme userData chahiye the - jo ki get() se - Ye future ,
                    // hence jab tk na aye loading dikhao , else userName -
                    // future ke snapshot ke basis pai kaam ho raha , isliye future builder.
                    future: FirebaseFirestore.instance
                        .collection(
                            'users') //phle ye galat tha null aa gaya , mtlb is path pai koi exist nhi krta,
                        .doc(userId)
                        .get(),
                    builder: (context, futureSnapshot) => Center(
                      child: Text(
                        (futureSnapshot.connectionState ==
                                ConnectionState.waiting)
                            ? 'Loading....'
                            : futureSnapshot.data!['username'],
                        //bolte ye field exist nhi krta , to check kiya aur correct kiya , case sensitive to hongi hi key
                        style: TextStyle(
                            color: isMe
                                ? Theme.of(context).textTheme.displayLarge!.color
                                : Theme.of(context).textTheme.displayMedium!.color),
                      ),
                    ),
                  ),
                  Divider(
                    color: isMe
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.tertiary,
                  ),
                  Text(
                    message,
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                    style: TextStyle(
                        color: isMe
                            ? Theme.of(context).textTheme.displayLarge!.color
                            : Theme.of(context).textTheme.displayMedium!.color),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          left: isMe ? 0 : dimensions.width * 0.18,
          right: isMe ? dimensions.width * 0.18 : 0,
          child: CircleAvatar(
            backgroundColor: Colors.blueGrey,
            radius: 24.0,
            //phle fit nhi baith raha tha, to stack overflow pai jake dekha
            //seedhe use krne wala code example mil gaya clip oval ka
            child: ClipOval(
              child: Image.network(
                imageUrl,
                height: 48.0,
                width: 48.0,
                fit: BoxFit.fill,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
