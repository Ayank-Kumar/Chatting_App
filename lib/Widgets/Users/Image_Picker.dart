///ispai function pass  kiya jo execute hoke auth_popup class ke field mai ye taken file bhar dega

/// ye jb leke ayenge [gallery/camera - dono image picker lib ka use karke].
/// to class ki field mai bhar diya aur setState called - usse circular avatar mai ayega.
/// Jo constructor method usse authpop ko mil jayega ki apne firebaseStorage mai store krne ke liye image.

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // ye plugin ko sdk version 33 chahiye tha.
//android studio nai khud se install kiya aur maine pubspec.yaml mai change kr di dependancy.
import 'dart:io'; //ye File ke liye chahiye hota hai.

//stateful mai bhi constructor wale kaam upar wale mai hi

class Image_Picker extends StatefulWidget {
  void Function(File image) imageHolder ;
  Image_Picker(this.imageHolder, {super.key}) ;//Ye jake pop_up mai kaam krega

  @override
  State<Image_Picker> createState() => _Image_PickerState();
}

class _Image_PickerState extends State<Image_Picker> {
  File? _file;
  //chhota sa fixation tha bahut time laga diya - neeche wale ko fileImage chahiye tha
  //aur uske File - to pickedimage pai null check laga do.

  void selectFromGallery() async {
    final _pickedFile =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery,imageQuality: 50,maxWidth: 100.0);

    if(_pickedFile!=null){
      setState(() {
        _file = File(_pickedFile.path);
      });
      widget.imageHolder( _file! ) ;
    }
  }

  void clickFromCamera() async {
    final _pickedFile = await ImagePicker.platform.pickImage(
        source: ImageSource.camera,
        imageQuality: 100); //Ye Picked File return krta hai
    //Ye to dekha karo ki kis type ka return kr raha hai.

    //flutter mai aap kaafi kuchh sirf functions: ko kya chahiye aur
    //.returner - kya return kr raha hai - aur match kr krke hi kr skte ho.
    if(_pickedFile!=null){
      setState(() {
        _file = File(_pickedFile.path);
      });
      widget.imageHolder( _file! ) ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
            radius: 40.0,
            backgroundColor: Colors.grey,
            backgroundImage://circe avatar ko fileImage hi chahiye tha , file se uska nahi ho paa raha tha.
                _file != null ? FileImage(_file!) : null),
        //jbki jo storage bucket mai dala , to usko bhi file hi diya pr usnai save kr liya .
        // jis extension se save krenge , us file format mai save krne ki koshish krega filedata ko.
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: selectFromGallery,
                icon: const Icon(Icons.image),
                iconSize: 27.0,
                color: Theme.of(context).colorScheme.primary),
            IconButton(
              onPressed: clickFromCamera,
              icon: const Icon(Icons.add_a_photo),
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        )
      ],
    );
  }
}
