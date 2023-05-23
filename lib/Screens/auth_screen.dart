/// Ye to kuchh nhi body mai ek aur widget chala de raha aur uspai auth method bhej de raha, yhi pai bhi kr lete

/// Bhai function jo chlega elevated button ke dabne pai- to phle to setState authenticating=true.
/// fir chalayega firebase auth ke function as per signing mode , jo photo hogi wo firebase storage mai
/// userid.jpg name ki file se userImages folder mai.
/// FireBase Storage mai bhi save [ismai users aur chats ka] imageUrl pichhli request se mil jayegi.

import 'package:flutter/material.dart';
import '../Widgets/Users/Auth_PopUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class Auth_Screen extends StatefulWidget {
  const Auth_Screen({Key? key}) : super(key: key);

  @override
  State<Auth_Screen> createState() => _Auth_ScreenState();
}

class _Auth_ScreenState extends State<Auth_Screen> {
  //achha phli baat to , ki snackbar dikhaega - to UI change ho raha , pure screen ka hi , isliye stateful chahiye.
  bool authenticating = false ;

  //context chahiye tha , isliye neeche ke state wale mai kiya . upar wale mai cotext nhi hota , context state ka hota hai
  void acceptUser(String email, String username, String password,File? file, bool isLogin,
      BuildContext ctx) async {
    UserCredential userAuth;
    try {
      setState(() {
        authenticating = !authenticating;
      }); //Ye wale mai abhi tk move nhi kiya hoga since login nahi hua.

      if (isLogin) {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } else {
        userAuth = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password) ;
        // await ek promise - jb aapko catch krna ho tb chhaiye hota hai ye , ki us samay to ayega nhi.
        //promise ki future mai jaise hi ayega aapke bucket mai return kr denge. aap aage baro

        final ref = FirebaseStorage.instance.ref().child('userImages').child( "${userAuth.user!.uid}.jpg") ;
        //sb on the fly create hote hai , 'userImages' hoga to usmai se , nhi to create and then usmai kaam
        await ref.putFile(file!) ;

        final url = await ref.getDownloadURL() ;

        FirebaseFirestore.instance
            .collection('users')
            .doc(userAuth.user!.uid)//wo document jiski ye value hai - to ye tabhi kaam
            // jb userAuth aa jaye (!null ho jaye kyunki uska check).
            .set({'username': username, 'e-mail': email, 'imageUrl': url}) ;
        //phle isko neeche call kr rakha tha , to kya ho raha tha , sing up/in ka process chalu chhor ke
        //neeche bar ja raha , isse phle ki wo wale incomplete hoke error aaye , ye neeche wale execute ho jaa rahe the
        //to bina correct credentials ke banda email daal ke update kr jaa raha tha.
        //aur achha login mai, jaha koi username hi nhi , wo bhi isko run krke username empty kr de rahe the.

      }

      //ab yaha tk move (if correct credentials) . auth screen nhi raha .
      // setState call krne pai error ki jo render ho hi nahi raha , uska stState call kr rahe ho
      /*if (mounted) {
        setState(() {
        authenticating = !authenticating ;
      });
      }*/

    } catch (error) {
      //these are the errors thrown by firebase
      String errMssg = 'Could not verify credentials! Please re-check input';
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            errMssg,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      );
      //yaha pai nhi hi paya sign up/in . To usi screen pai rah gaya ,
      // hence failure ke baad wapis se elevated button dikhana hoga na spinner ki jagah
      setState(() {
        authenticating = !authenticating;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20.0,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Auth_PopUp(authenticating,acceptUser), //Ye function jo ki pass hi kiye gaye hai yaha pai use nahi .
      // Inhe waha bhi likha ja skta tha par lamba ho raha tha to yaha likh ke pass.
    );
  }
}
