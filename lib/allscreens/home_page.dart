import 'package:chat/allConstants/color_constants.dart';
import 'package:chat/allprovider/auth_provider.dart';
import 'package:chat/allscreens/setting_page.dart';
import 'package:flutter/material.dart';
import '../allModels/popup_choices.dart';
import '../main.dart';
import 'package:provider/src/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login_page.dart';


class HomePage extends StatefulWidget{
  const HomePage ({
    Key ? key
}):super(key:key);
  @override
  _HomePageState createState () => _HomePageState();

}
class _HomePageState extends State<HomePage>
{
  final GoogleSignIn googleSignIn=GoogleSignIn();
  final ScrollController listScrollController =ScrollController();
  int _limit=20;
  int _LimitIncrement=20;
  String _TextSearch ="";
  bool IsLoading =false;
  late AuthProvider authProvider;
  late String currentUserId;
  List<PopupChoices>choises=<PopupChoices>[PopupChoices(title: 'Settings', icon: Icons.settings),
    PopupChoices(title: 'Signout', icon: Icons.exit_to_app)];
  Future<void>handelSignout() async{

    authProvider.handelSignOut();
    Navigator.push(context, MaterialPageRoute(builder:(context)=>LoginPage()));

  }
  void scrollListener (){
    if(listScrollController.offset>=listScrollController.position.maxScrollExtent&&listScrollController.position.outOfRange)
    {
      setState(() {
        _limit +=_LimitIncrement;
      });
    }
  }

  void onItemMenuPress(PopupChoices choices)
  {
    if(choices.title=="Signout")
      {
        handelSignout();
      }
    else
    {
      Navigator.push(context, MaterialPageRoute(builder:(context)=>SettingPage()));
    }
  }

  Widget buildPopupMenu(){
    return PopupMenuButton<PopupChoices>(
        icon: const Icon(Icons.more_vert,
          color: Colors.grey
        ),
        onSelected: onItemMenuPress,
        itemBuilder: (BuildContext context){
      return choises.map((PopupChoices choice) {
        return PopupMenuItem<PopupChoices>(
          value: choice,
          child: Row(
            children: <Widget>[
              Icon(choice.icon, color: ColorConstants.primaryColor,
              ),
              Container(width: 10,
              ),
              Text(
                choice.title,style: 
              const TextStyle(
                color: ColorConstants.primaryColor
              )
                ,)
              
            ],
          ),
        );
      }).toList();
    });
  }
  @override
  void initState(){
    super.initState();
    authProvider= context.read<AuthProvider>();
   // homeProvider= context.read<HomeProvider>();
    if(authProvider.getUserFirebaseId()?.isNotEmpty==true){
      currentUserId=authProvider.getUserFirebaseId() !;
    }
    else{
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginPage()) ,
              (Route<dynamic>route) => false);
    }
    listScrollController.addListener(scrollListener);
  }
  Widget build (BuildContext context){
    return Scaffold(
      backgroundColor: isWhite? Colors.white : Colors.black,
      appBar: AppBar(
        backgroundColor: isWhite? Colors.white : Colors.black,
        leading: IconButton(
          icon: Switch(
            value: isWhite,
            onChanged: (value){
              setState(() {
                isWhite= value;
                print(isWhite);
              });
            },
            activeTrackColor: Colors.grey,
            activeColor:Colors.white ,
            inactiveTrackColor: Colors.grey,
            inactiveThumbColor: Colors.black45,
          ),
          onPressed: () => "",
        ),
        actions: <Widget>[buildPopupMenu()],
        
      ),
    );
  }
}