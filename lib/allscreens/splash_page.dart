import 'package:chat/allConstants/color_constants.dart';
import 'package:chat/allprovider/auth_provider.dart';
import 'package:chat/allscreens/home_page.dart';
import 'package:chat/allscreens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5),(){
      checkSignIn();
    });
  }
  void checkSignIn() async{
    AuthProvider authProvider=context.read<AuthProvider>();
    bool IsLogedIn= await authProvider.isLoggedIn();
    if(IsLogedIn)
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
        return;
      }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));

  }
  Widget build(BuildContext context) {
return Scaffold(
  body:Center(
    child: Column(mainAxisSize: MainAxisSize.min,
    children: [Image.asset("images/splash.png",width: 300, height: 300,),
    SizedBox(height: 20),
    Text("Private Chat App", style: TextStyle(color: ColorConstants.themeColor)),
      SizedBox(height: 20),
Container(width: 20,
  height: 20,
child: CircularProgressIndicator(color: ColorConstants.themeColor,),
)
    ],

    ),
  ) ,

);
  }
}