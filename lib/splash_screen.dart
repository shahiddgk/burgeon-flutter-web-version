// ignore_for_file: library_private_types_in_public_api, avoid_print, unused_import

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/utill/UserState.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'Screens/AuthScreens/login_screen.dart';
import 'Screens/TreeScreen/tree_screen111.dart';
import 'Screens/utill/userConstants.dart';
import 'Widgets/video_player_in_pop_up.dart';

class SplashScreen extends StatefulWidget {

  // YoutubePlayerController _playerController;

  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late bool isUserLoggedIn = false;
  String introUrl = "https://www.youtube.com/watch?v=O4fsrMcxRqc";
  String imageUrl = "https://i.ytimg.com/vi/O4fsrMcxRqc/hqdefault.jpg";
   late YoutubePlayerController _playerController;
   bool _isLoading = false;
  late bool isPhone;
  bool _isLoadingVideo = true;
  late String id;

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();

    setPlayerControllerForIframe();

      print("Controller calling");

    // _getPckageInfo();
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

    super.initState();
  }

  setPlayerControllerForIframe() {
    setState(() {
      _isLoadingVideo = true;
    });


    setState(() {
      _isLoadingVideo = false;
    });
  }

  _getUserData() async {
    setState(() {
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(UserConstants().otherUserLoggedIn, false);
    setState(() {
      isUserLoggedIn = sharedPreferences.getBool(UserConstants().userLoggedIn)!;
      id = sharedPreferences.getString(UserConstants().userId)!;
    });

  }
  getScreenDetails() {
    setState(() {
    });
    if(MediaQuery.of(context).size.width<= 600) {
      isPhone = true;
    } else {
      isPhone = false;
    }
    setState(() {
    });
  }

  Future<void> createDocumentIfNotExists(String collectionPath, String documentId) async {
    // Get the document reference.
    final documentReference = FirebaseFirestore.instance.collection(collectionPath).doc(documentId);

    // Check if the document exists.
    final documentSnapshot = await documentReference.get();
    if (!documentSnapshot.exists) {
      // Create a new document.
      await documentReference.set({
        'shared_response':0,
        'con_request':0,
        'module_requested':0,
        'user_id':id
      });
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> TreeScreen1(true)));
  }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();
    return Scaffold(
      body: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColors.backgroundColor,
          alignment: Alignment.center,
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    LogoScreen(""),
                    _isLoading || _isLoadingVideo ? const Center(child: CircularProgressIndicator(),)
                       :  Card(
                     color: AppColors.primaryColor,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: SizedBox(
                        height: !isPhone ? MediaQuery.of(context).size.height/2 : null,
                        width:!isPhone ? MediaQuery.of(context).size.width/3 : null,
                        child: InkWell(
                          onTap: () {
                            _playerController = YoutubePlayerController(
                                params: const YoutubePlayerParams(
                                  showControls: true,
                                  mute: false,
                                  showFullscreenButton: true,
                                  loop: false,
                                  strictRelatedVideos: true,
                                  enableJavaScript: true,
                                ))..onInit = () {
                              _playerController.loadVideo(introUrl);
                              _playerController.stopVideo();
                            };

                            videoPopupDialog(context,"Introduction to Needs",_playerController);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.network(imageUrl,fit: BoxFit.fill,height: !isPhone ? MediaQuery.of(context).size.height/2 : null, width:!isPhone ? MediaQuery.of(context).size.width/3 : null,),
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Image.asset("assets/youtube_play_video_icon.png"),
                                )
                              ],
                            )
                          ),
                        ),
                      ),
                    ),
                    _isLoading ? Container() : SizedBox(height: !isPhone ? MediaQuery.of(context).size.height/40.5 : MediaQuery.of(context).size.height/2.5,),
                    _isLoading ? Container() : ElevatedButton(
                      onPressed: (){
                        setState(() {
                          _isLoading = true;
                        });
                        if(isUserLoggedIn) {
                          createDocumentIfNotExists("connections",id);
                        } else {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder:
                                  (context) =>
                              const LoginPage()
                              )
                          );
                        }

                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ), backgroundColor: AppColors.primaryColor,
                        minimumSize: Size(!isPhone ? MediaQuery.of(context).size.width/4 : MediaQuery.of(context).size.width/2, 40), // Set the minimum width and height
                        padding: EdgeInsets.zero, // Remove any default padding
                      ),
                      child:const Text("Tap to Proceed",style: TextStyle(color: AppColors.backgroundColor),),)
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}
