import 'package:chat/allWidgets/loading_view.dart';
import 'package:chat/allprovider/auth_provider.dart';
import 'package:chat/allscreens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    switch(authProvider.status){
      case Status.authenticateError:
        Fluttertoast.showToast(msg: "SignIn fail");
        break;
      case Status.authenticateCanceled:
        Fluttertoast.showToast(msg: "SignIn Canceled");
        break;
      case Status.authenticated:
        Fluttertoast.showToast(msg: "SignIn Success");
        break;
      default:
        break;
    }

  return  Scaffold(
  backgroundColor: Colors.black45,
    body: Column(
mainAxisAlignment:MainAxisAlignment.center ,
      children: <Widget>[
        Padding(padding: const EdgeInsets.all(20.0),
        child:Image.asset("image/back.png")
        ),
        const SizedBox(height:20),
        Padding(padding: const EdgeInsets.all(20.0),
            child:GestureDetector(onTap: () async{
            bool IsSuccess= await authProvider.handelSignIn();
            if(IsSuccess)
              {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));

              }
            },
              child: Image.asset("image/google_Login.jpg"),
            ),
        ),
        Positioned(
            child: authProvider.status==Status.authenticating ? LoadingView():SizedBox.shrink(),

        ),

      ],

    ),

  );
}
}
