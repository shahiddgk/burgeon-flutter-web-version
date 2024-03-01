// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../splash_screen.dart';
import '../utill/userConstants.dart';
import 'login_screen.dart';

class SplashScreenUpdate extends StatefulWidget {
  const SplashScreenUpdate({Key? key}) : super(key: key);

  @override
  State<SplashScreenUpdate> createState() => _SplashScreenUpdateState();
}

class _SplashScreenUpdateState extends State<SplashScreenUpdate> {

  bool isUserLoggedIn = false;
  String introUrl = "https://www.youtube.com/watch?v=O4fsrMcxRqc";
  // late YoutubePlayerController _playerController;

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();

    // _playerController = YoutubePlayerController(
    //     params: const YoutubePlayerParams(
    //       showControls: true,
    //       mute: false,
    //       showFullscreenButton: true,
    //       loop: false,
    //       strictRelatedVideos: true,
    //       enableJavaScript: true,
    //     ))..onInit = () {
    //   _playerController.loadVideo(introUrl);
    //   _playerController.stopVideo();
    // };

    Timer(const Duration(seconds: 3),
            ()=>isUserLoggedIn ? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SplashScreen()), (route) => false)
                : Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const LoginPage()), (route) => false)
    );
    super.initState();
  }

  _getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isUserLoggedIn = sharedPreferences.getBool(UserConstants().userLoggedIn)!;
    });

    // isUserLoggedIn ? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SplashScreen(_playerController)), (route) => false)
    //     : Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const LoginPage()), (route) => false);
  }

  // _getUserData() async {
  //   setState(() {
  //   });
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     isUserLoggedIn = sharedPreferences.getBool(UserConstants().userLoggedIn)!;
  //   });
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
