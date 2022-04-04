// import 'dart:html';
import 'dart:io';
// import 'dart:js';
import 'package:chat/allConstants/app_constants.dart';
import 'package:chat/allConstants/color_constants.dart';
import 'package:chat/allConstants/constants.dart';
import 'package:chat/allModels/user_chat.dart';
import 'package:chat/allprovider/setting_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat/allWidgets/loading_view.dart';
import 'package:firebase_storage/firebase_storage.dart';



class SettingPage extends StatelessWidget{
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isWhite? Colors.white : Colors.black,
      appBar: AppBar(
        backgroundColor:isWhite? Colors.white : Colors.black ,
        iconTheme: IconThemeData(
            color:ColorConstants.primaryColor
        ),
        title: Text(
          AppConstants.settingsTitle,
          style: TextStyle(color: ColorConstants.primaryColor),
        ),
        centerTitle: true,
      ),
      body: SettingsPageState(),





    );
  }
}
class SettingsPageState extends StatefulWidget {
  const SettingsPageState({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingsPageState> {
  TextEditingController? controllerUsername;
  String dialCodeDigits = "+00";
  final TextEditingController _controller = TextEditingController();
  String id = "";
  String username = "";
  String photoUrl = "";
  bool isLoading = false;
  File? avatarImageFile;
  late SettingProvider settingProvider;

  final FocusNode FocusNodeUsername = FocusNode();

  @override
  void initState() {
    super.initState();
    settingProvider = context.read<SettingProvider>();
    readLocal();
  }

  void readLocal() {
    setState(() {
      id = settingProvider.getPref(FirestoreConstants.id) ?? "";
      username = settingProvider.getPref(FirestoreConstants.username) ?? "";
      photoUrl = settingProvider.getPref(FirestoreConstants.photoUrl) ?? "";
    });
    controllerUsername = TextEditingController(text: username);
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile = await imagePicker.getImage(
        source: ImageSource.gallery).catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
    });
    File? image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = id;

    UploadTask uploadTask = settingProvider.uploadFile(
        avatarImageFile!, fileName);
    try{
      TaskSnapshot snapshot = await uploadTask;
      photoUrl = await snapshot.ref.getDownloadURL();

      UserChat updateInfo = UserChat(
          id: id,
          username: username,
          photoUrl: photoUrl);
      settingProvider.updateDataFirestore(
          FirestoreConstants.pathUserCollection, id, updateInfo.tojson()).then(
              (data) async {
            await settingProvider.setpref(
                FirestoreConstants.photoUrl, photoUrl);
            setState(() {
              isLoading = false;
            });
          }).catchError((err) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: err.toString());
      });
    } on FirebaseException catch (e){
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());

    }
  }
void handleUpdateData(){
    FocusNodeUsername.unfocus();
    setState(() {
      isLoading = true;

    });
    UserChat updateInfo = UserChat(id: id, username: username, photoUrl: photoUrl);
    settingProvider.updateDataFirestore(FirestoreConstants.pathUserCollection, id, updateInfo.tojson()).then((data)async{
      await settingProvider.setpref(FirestoreConstants.username, username);
      await settingProvider.setpref(FirestoreConstants.photoUrl, photoUrl);
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Update success");
    });
}

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:<Widget> [
        SingleChildScrollView(
           padding: EdgeInsets.only(left: 15,right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                  onPressed: getImage,
              child: Container(
                margin: EdgeInsets.all(20),
                child: avatarImageFile == null
                ? photoUrl.isNotEmpty
                  ?ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: Image.network(
                    photoUrl,
                  fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                    errorBuilder: (context,object,stackTrace){
                    return Icon(
                      Icons.account_circle,
                      size: 90,
                      color: ColorConstants.greyColor,
                    );
                    },
                    loadingBuilder: (BuildContext context , Widget child, ImageChunkEvent? loadingProcess){
                      if(loadingProcess == null) return child;
                      return Container(
                        width: 90,
                        height: 90,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.grey,
                            value: loadingProcess.expectedTotalBytes != null &&
                                loadingProcess.expectedTotalBytes != null
                                ? loadingProcess.cumulativeBytesLoaded / loadingProcess.expectedTotalBytes! : null,
                          ),

                        ),
                      );
                    },
                  ),

                ): Icon(
                      Icons.account_circle,
                      size: 90,
                        color: ColorConstants.greyColor,

                ):ClipRRect(
                    borderRadius: BorderRadius.circular(45),
                    child: Image.file(
                   avatarImageFile!,
                   width: 90,
                   height: 90,
                   fit: BoxFit.cover,

              ),
              ),
              ),
              ),

              Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Name',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,fontWeight: FontWeight.bold, color: ColorConstants.primaryColor),

                    ),
                    margin: EdgeInsets.only(left: 10,bottom: 5,top: 10),

                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30,right: 30),
                    child: Theme(
                      data: Theme.of(context).copyWith(primaryColor: ColorConstants.primaryColor),
                      child: TextField(
                        style: TextStyle(color: Colors.grey),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorConstants.greyColor)
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorConstants.primaryColor)
                          ),
                          hintText: 'Write Your Name.....'
                        ),
                        controller: controllerUsername,
                        onChanged: (value){
                          username = value;
                        },
                        focusNode: FocusNodeUsername,

                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 30,right: 30),
                child: TextButton(
                  onPressed: handleUpdateData,
                  child: Text(
                    'update now',
                    style: TextStyle(
                      fontSize: 16,
                      color:Colors.white,
                    ),

                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(ColorConstants.primaryColor),
                      padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(30, 10, 30, 10))
                  ),
                ),
              )

            ],
          ),
        ),
        Positioned(child: isLoading? LoadingView():SizedBox.shrink())
      ],
    );
  }

}