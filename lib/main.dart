///feature builder mai return stream builder.

/// home mai future builder ke andar initialise app - future connection establish krne gaya hua hai
/// agar error return kar jaye - to show dialog - ki connectin hi establish nhi kr paye.
/// baki waiting tk circular dikhate raho.

/// Inside stream builder jb tk snapshot [auth ka check krne jayega] waiting state mai - show loading spinner
/// ab snapshow data leke aate hai - to authenticated - move to chat screen, else signing screen

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './Screens/chat_screen.dart';
import './Screens/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';

//firebase mai ap add krne waqt android wale mai jaise bolte gye waise krte gaye.
//kotlin aur flutter ka version update krna para.
//package se associated bhi error thi [hai hi ismai] - wo video dekh ke
//long term - multi sequence process - ke liye - video dekh lo - chhote ke liye documentation/stack-overflow.
//easy/common error ke liye flutter/android studio khud bata dega.
void main() {
  runApp(
      const MyApp()); //east or best stack-overflow best - copy error focussing on key-word [google search algo] and put - jispai green tick
  //top answers with significant votes.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatting_App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.pinkAccent,
            secondary: Colors.deepPurpleAccent,
            tertiary: Colors.greenAccent,
            background: Colors.blueGrey),
        textTheme: const TextTheme(
          headline1: TextStyle(
            color: Colors.black,
          ),
          headline2: TextStyle(
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ),
      home: FutureBuilder(
        //home ko route chahiye hota hai jo ek widget tk lead kare.
        // Initialize FlutterFire
        future: Firebase.initializeApp(),
        //ye phle nhi kiya tha to error ki firebasa ka app hi initialize nhi kiya, kahi bhi kr skte ho ,
        //jaha bhi firebase, instance use - usse phle hua hona chahiye.
        // yhi app ke root mai hi kr liye - app ke cloud databse se connection - jaise hi app start hoga ye sbse phle hoga hi
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return const Dialog(
              backgroundColor: Colors.grey,
              elevation: 10.0,
              child: Text(
                  "We are having an issue currently in establishing the connection"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.green, // Ye kahi nhi aata waise - pr likhna jaruri par raha tha error hatane ke liye
                ),
              ),
            );
            //isse phli baar mai terminal ek error dikha raha tha [ ki abhi null hai ] wo hat gaya.
            //jb tk initialize nhi hua app - aapko nhi chalane hai ape functions.
          }

          //kahi bhi logOut to ye call ,aur wapis se re-render main widget.
          return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),              builder: (ctx, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child:
                          CircularProgressIndicator(), //phle ye aata hai - jb authentication check kr raha
                    ),
                  );
                }
                if (snapshots.hasData) {
                  return const Chat_Screen(); // Fir jb authenticated to iska circular indicator aata hai .
                  // (jb tk wo chats ki list laa raha hota hai database se)
                } else {
                  return const Auth_Screen();//ismai koi future nhi [async task] - ye to hamara hi banay hua - seedhe load .
                }
              });
        },
      ),
    );
  }
}
