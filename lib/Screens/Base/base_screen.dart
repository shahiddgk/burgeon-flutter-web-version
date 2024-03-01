
// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/dashboard_tiles.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/constants.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../Widgets/video_player_in_pop_up.dart';
import '../Column/Widgets/search_text_field.dart';
import '../Payment/payment_screen.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../PireScreens/widgets/PopMenuButton.dart';
import '../Trellis/widgets/dropdown_field.dart';
import '../utill/userConstants.dart';
import 'package:intl/intl.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  String email = "";
  String timeZone = "";
  String userType = "";
  bool _isLoading = true;
  bool _isDataLoading = true;
  late bool isPhone;
  late bool isTable;
  late bool isDesktop;
  int badgeCount1 = 0;
  int badgeCountShared = 0;

  bool otherUserLoggedIn = false;

  bool isVideos = true;
  final TextEditingController _searchController = TextEditingController();

  bool isSearch = false;

  List<baseListResponse> generalBaseList = [];
  List<baseListResponse> searchBaseList = [];

  List<baseListResponse> allVideoItemBaseList = [
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/O4fsrMcxRqc/hqdefault.jpg",date: "05-06-2023",videoDocumentLink:"https://youtu.be/O4fsrMcxRqc" ,videoDocumentTitle: "Introduction to Burgeon",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/8KgbGXH35Mg/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=8KgbGXH35Mg" ,videoDocumentTitle: "How are you?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/nbjQXrj14bg/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=nbjQXrj14bg" ,videoDocumentTitle: "Person, Comment or Event",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/HNKjInU3OYc/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=HNKjInU3OYc" ,videoDocumentTitle: "Tell us what happened?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/e21IMsPV24s/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=e21IMsPV24s" ,videoDocumentTitle: "How did it make you feel?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/NRJv5AUsU_8/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=NRJv5AUsU_8" ,videoDocumentTitle: "How do you feel it in your body?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/4ea8gMc1O0k/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=4ea8gMc1O0k" ,videoDocumentTitle: "If that feeling had a voice or were a picture what is it saying or showing you",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/-Gg4a-D8bgQ/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=-Gg4a-D8bgQ" ,videoDocumentTitle: "what do you need to be empowered",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/xj6FyDn3Cxw/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=xj6FyDn3Cxw" ,videoDocumentTitle: "What do you want to believe and how would you like to feel?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/8KgbGXH35Mg/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=8KgbGXH35Mg" ,videoDocumentTitle: "How are you",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/GFqe2n4vnNU/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=GFqe2n4vnNU" ,videoDocumentTitle: "Introduction to trellis",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/Z_9dsRt2cvQ/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=Z_9dsRt2cvQ" ,videoDocumentTitle: "what is name?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/SMc9h2t-W4U/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=SMc9h2t-W4U" ,videoDocumentTitle: "What is purpose?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/6g8EcajHQPY/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=6g8EcajHQPY" ,videoDocumentTitle: "What is ladder?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/8yhH70QFBQ4/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=8yhH70QFBQ4" ,videoDocumentTitle: "What is Organizational Principle?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/iqUEdMLACs8/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=iqUEdMLACs8" ,videoDocumentTitle: "What is identity?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/4_9pRALrO1k/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=4_9pRALrO1k" ,videoDocumentTitle: "What is Rhythm?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/2PqaSGRZgI0/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=2PqaSGRZgI0" ,videoDocumentTitle: "What is Tribe?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/v6wVjS_w_6Q/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=v6wVjS_w_6Q" ,videoDocumentTitle: "What is Need?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/6g8EcajHQPY/hqdefault.jpg",date: "07-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=6g8EcajHQPY" ,videoDocumentTitle: "Introduction to Ladder",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/zhhv_BVSXgI/hqdefault.jpg",date: "07-10-2023",videoDocumentLink:"https://youtu.be/zhhv_BVSXgI" ,videoDocumentTitle: "Introduction to Column",type: "Videos"),
  ];

  List<baseListResponse> allItemBaseList = [
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/O4fsrMcxRqc/hqdefault.jpg",date: "05-06-2023",videoDocumentLink:"https://youtu.be/O4fsrMcxRqc" ,videoDocumentTitle: "Introduction to Burgeon",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/8KgbGXH35Mg/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=8KgbGXH35Mg" ,videoDocumentTitle: "How are you?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/nbjQXrj14bg/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=nbjQXrj14bg" ,videoDocumentTitle: "Person, Comment or Event",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/HNKjInU3OYc/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=HNKjInU3OYc" ,videoDocumentTitle: "Tell us what happened?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/e21IMsPV24s/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=e21IMsPV24s" ,videoDocumentTitle: "How did it make you feel?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/NRJv5AUsU_8/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=NRJv5AUsU_8" ,videoDocumentTitle: "How do you feel it in your body?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/4ea8gMc1O0k/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=4ea8gMc1O0k" ,videoDocumentTitle: "If that feeling had a voice or were a picture what is it saying or showing you",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/-Gg4a-D8bgQ/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=-Gg4a-D8bgQ" ,videoDocumentTitle: "what do you need to be empowered",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/xj6FyDn3Cxw/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=xj6FyDn3Cxw" ,videoDocumentTitle: "What do you want to believe and how would you like to feel?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/8KgbGXH35Mg/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=8KgbGXH35Mg" ,videoDocumentTitle: "How are you",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/GFqe2n4vnNU/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=GFqe2n4vnNU" ,videoDocumentTitle: "Introduction to trellis",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/Z_9dsRt2cvQ/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=Z_9dsRt2cvQ" ,videoDocumentTitle: "what is name?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/SMc9h2t-W4U/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=SMc9h2t-W4U" ,videoDocumentTitle: "What is purpose?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/6g8EcajHQPY/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=6g8EcajHQPY" ,videoDocumentTitle: "What is ladder?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/8yhH70QFBQ4/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=8yhH70QFBQ4" ,videoDocumentTitle: "What is Organizational Principle?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/iqUEdMLACs8/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=iqUEdMLACs8" ,videoDocumentTitle: "What is identity?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/4_9pRALrO1k/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=4_9pRALrO1k" ,videoDocumentTitle: "What is Rhythm?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/2PqaSGRZgI0/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=2PqaSGRZgI0" ,videoDocumentTitle: "What is Tribe?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/v6wVjS_w_6Q/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=v6wVjS_w_6Q" ,videoDocumentTitle: "What is Need?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/6g8EcajHQPY/hqdefault.jpg",date: "07-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=6g8EcajHQPY" ,videoDocumentTitle: "Introduction to Ladder",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/zhhv_BVSXgI/hqdefault.jpg",date: "07-10-2023",videoDocumentLink:"https://youtu.be/zhhv_BVSXgI" ,videoDocumentTitle: "Introduction to Column",type: "Videos"),
    baseListResponse(thumbnailLink: "assets/pdf_logo.png",date: "10-21-2023",videoDocumentLink:"https://dashboard.burgeon.app/uploads/true-increase.pdf" ,videoDocumentTitle: "What must be true to reach your greatest potential",type: "PDF")
  ];

  List<baseListResponse> pdfDocumentList = [
    baseListResponse(thumbnailLink: "assets/pdf_logo.png",date: "10-21-2023",videoDocumentLink:"https://dashboard.burgeon.app/uploads/true-increase.pdf" ,videoDocumentTitle: "What must be true to reach your greatest potential",type: "PDF")
  ];

  List<baseListResponse> introVideoList = [
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/O4fsrMcxRqc/hqdefault.jpg",date: "05-06-2023",videoDocumentLink:"https://youtu.be/O4fsrMcxRqc" ,videoDocumentTitle: "Introduction to Burgeon",type: "Videos")
  ];

  List<baseListResponse> pireVideoList = [
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/8KgbGXH35Mg/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=8KgbGXH35Mg" ,videoDocumentTitle: "How are you?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/nbjQXrj14bg/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=nbjQXrj14bg" ,videoDocumentTitle: "Person, Comment or Event",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/HNKjInU3OYc/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=HNKjInU3OYc" ,videoDocumentTitle: "Tell us what happened?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/e21IMsPV24s/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=e21IMsPV24s" ,videoDocumentTitle: "How did it make you feel?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/NRJv5AUsU_8/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=NRJv5AUsU_8" ,videoDocumentTitle: "How do you feel it in your body?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/4ea8gMc1O0k/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=4ea8gMc1O0k" ,videoDocumentTitle: "If that feeling had a voice or were a picture what is it saying or showing you",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/-Gg4a-D8bgQ/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=-Gg4a-D8bgQ" ,videoDocumentTitle: "what do you need to be empowered",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/xj6FyDn3Cxw/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=xj6FyDn3Cxw" ,videoDocumentTitle: "What do you want to believe and how would you like to feel?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/8KgbGXH35Mg/hqdefault.jpg",date: "05-10-2023",videoDocumentLink:"https://www.youtube.com/watch?v=8KgbGXH35Mg" ,videoDocumentTitle: "How are you",type: "Videos"),

  ];

  List<baseListResponse> trellisVideoList = [
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/GFqe2n4vnNU/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=GFqe2n4vnNU" ,videoDocumentTitle: "Introduction to trellis",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/Z_9dsRt2cvQ/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=Z_9dsRt2cvQ" ,videoDocumentTitle: "what is name?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/SMc9h2t-W4U/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=SMc9h2t-W4U" ,videoDocumentTitle: "What is purpose?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/6g8EcajHQPY/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=6g8EcajHQPY" ,videoDocumentTitle: "What is ladder?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/8yhH70QFBQ4/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=8yhH70QFBQ4" ,videoDocumentTitle: "What is Organizational Principle?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/iqUEdMLACs8/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=iqUEdMLACs8" ,videoDocumentTitle: "What is identity?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/4_9pRALrO1k/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=4_9pRALrO1k" ,videoDocumentTitle: "What is Rhythm?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/2PqaSGRZgI0/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=2PqaSGRZgI0" ,videoDocumentTitle: "What is Tribe?",type: "Videos"),
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/v6wVjS_w_6Q/hqdefault.jpg",date: "05-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=v6wVjS_w_6Q" ,videoDocumentTitle: "What is Need?",type: "Videos"),

  ];

  List<baseListResponse> ladderVideoList = [
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/6g8EcajHQPY/hqdefault.jpg",date: "07-20-2023",videoDocumentLink:"https://www.youtube.com/watch?v=6g8EcajHQPY" ,videoDocumentTitle: "Introduction to Ladder",type: "Videos")
  ];

  List<baseListResponse> columnVideoList = [
    baseListResponse(thumbnailLink: "https://i.ytimg.com/vi/zhhv_BVSXgI/hqdefault.jpg",date: "07-10-2023",videoDocumentLink:"https://youtu.be/zhhv_BVSXgI" ,videoDocumentTitle: "Introduction to Column",type: "Videos")
  ];

  String initialValueForType = "All";
  List itemsForType = ["All","Introduction","P.I.R.E.","Trellis","Column","Ladder"];

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();

    generalBaseList = allVideoItemBaseList;

    super.initState();
  }

  _getUserData() async {
    //showUpdatePopup(context);

    //  print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    otherUserLoggedIn = sharedPreferences.getBool(UserConstants().otherUserLoggedIn)!;

    if(otherUserLoggedIn) {

      id = sharedPreferences.getString(UserConstants().otherUserId)!;
      name = sharedPreferences.getString(UserConstants().otherUserName)!;
      email = sharedPreferences.getString(UserConstants().userEmail)!;
      timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
      userType = sharedPreferences.getString(UserConstants().userType)!;

    } else {
      name = sharedPreferences.getString(UserConstants().userName)!;
      id = sharedPreferences.getString(UserConstants().userId)!;
      email = sharedPreferences.getString(UserConstants().userEmail)!;
      timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
      userType = sharedPreferences.getString(UserConstants().userType)!;

    }

  }

  getScreenDetails() {
    setState(() {
      _isDataLoading = true;
    });
    if(MediaQuery.of(context).size.width<= 600) {
      isPhone = true;
    } else {
      isPhone = false;
    }
    setState(() {
      _isDataLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();
    return Scaffold(
      appBar: AppBarWidget().appBarGeneralButtonsWithOtherUserLogged(
          context,
              () {
            Navigator.of(context).pop();
          }, true, true, true, id, true,true,0,false,0,otherUserLoggedIn,name),

      body:Container(
        color: AppColors.backgroundColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal:!isPhone ? MediaQuery.of(context).size.width/4:10),
            child: Column(
              children: [
                LogoScreen("Base"),
                const SizedBox(width: 20,),
                Visibility(
                  visible: isSearch,
                  child: SearchTextField((value) {
                    if(value.isEmpty) {
                      setState(() {
                        searchBaseList = allItemBaseList;
                      });
                    } else {
                      setState(() {
                        filterSearchResults(value);
                      });
                    }
                  }, _searchController, 1, false, "search here with title"),
                ),
                if(!isSearch)
                  const SizedBox(height:5),
                Visibility(
                  visible: !isSearch,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              // isGoalsTabActive = true;
                              isVideos = true;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            //width: MediaQuery.of(context).size.width/2,
                            padding:const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                color: isVideos ? AppColors.primaryColor : AppColors.backgroundColor,
                                border: Border.all(color: AppColors.primaryColor),
                                borderRadius:const BorderRadius.only(bottomLeft: Radius.circular(30),topLeft:Radius.circular(30), )),
                            child: Text("Videos",maxLines: 1,style: TextStyle(fontSize:!isPhone ? AppConstants.defaultFontSize : AppConstants.mobileDefaultFontSize,color: isVideos ? AppColors.backgroundColor : AppColors.primaryColor),),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              // isGoalsTabActive = false;
                              isVideos = false;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            // width: MediaQuery.of(context).size.width/2,
                            padding:const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                color: !isVideos ? AppColors.primaryColor : AppColors.backgroundColor,
                                border: Border.all(color: AppColors.primaryColor),
                                borderRadius:const BorderRadius.only(bottomRight: Radius.circular(30),topRight:Radius.circular(30), )),
                            child: Text("PDF",maxLines: 1,style: TextStyle(fontSize:!isPhone ? AppConstants.defaultFontSize : AppConstants.mobileDefaultFontSize,color: !isVideos ? AppColors.backgroundColor : AppColors.primaryColor),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5,),
                Visibility(
                  visible: isVideos && !isSearch,
                  child:OptionMcqAnswer(
                    DropDownField(initialValueForType, itemsForType.map((item) {
                      return  DropdownMenuItem(
                        value: item.toString(),
                        child: Text(item.toString()),
                      );
                    }).toList(), (value) {
                      setState(() {
                        initialValueForType = value;

                        if(initialValueForType == "All") {

                          generalBaseList = allVideoItemBaseList;

                        }
                        else if(initialValueForType == "Introduction") {

                          generalBaseList = introVideoList;

                        } else if(initialValueForType == "P.I.R.E.") {

                          generalBaseList = pireVideoList;

                        } else if(initialValueForType == "Trellis") {

                          generalBaseList = trellisVideoList;

                        } else if(initialValueForType == "Column") {

                          generalBaseList = columnVideoList;

                        } else {

                          generalBaseList = ladderVideoList;

                        }

                      });
                    }),
                  ), ),
                const SizedBox(height: 5,),

                Visibility(
                  visible: isSearch,
                  child: GridView.builder(
                      gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // number of items in each row
                        mainAxisSpacing: 8.0, // spacing between rows
                        crossAxisSpacing: 8.0, // spacing between columns
                        childAspectRatio: (4 / 4),
                      ),
                      shrinkWrap: true,
                      physics:const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8.0),
                      itemCount: searchBaseList.length,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          physics:const NeverScrollableScrollPhysics(),
                          child: Container(
                            alignment: Alignment.topCenter,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child:  Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                searchBaseList[index].type! != "PDF" ? InkWell(
                                  onTap: () {

                                    late YoutubePlayerController playerController;
                                    playerController = YoutubePlayerController(
                                        params: const YoutubePlayerParams(
                                          showControls: true,
                                          mute: false,
                                          showFullscreenButton: true,
                                          loop: false,
                                          strictRelatedVideos: true,
                                          enableJavaScript: true,
                                        ))..onInit = () {
                                      playerController.loadVideo(searchBaseList[index].videoDocumentLink!);
                                      playerController.stopVideo();
                                    };

                                    videoPopupDialog(context,searchBaseList[index].videoDocumentTitle!,playerController);
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      FadeInImage(
                                        placeholder: const AssetImage("assets/placeholder.png"),
                                        image: NetworkImage(searchBaseList[index].thumbnailLink!),
                                        fit: BoxFit.fill,
                                      ),
                                      Image.asset("assets/icon _play circle.png"),
                                    ],
                                  ),
                                ) : InkWell(
                                    onTap: () {
                                      _launchURL(searchBaseList[index].videoDocumentLink!);
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: Image.asset("assets/pdf_logo.png",fit: BoxFit.fill,))),
                                const SizedBox(height: 5,),
                                Text(searchBaseList[index].videoDocumentTitle!,maxLines: 1,overflow: TextOverflow.ellipsis,style:  TextStyle(fontSize:!isPhone ? AppConstants.defaultFontSize : AppConstants.mobileDefaultFontSize),),
                                const SizedBox(height: 3,),
                                Text(searchBaseList[index].date!,maxLines: 1,overflow: TextOverflow.ellipsis,style:  TextStyle(fontSize: !isPhone ? AppConstants.defaultFontSize : AppConstants.mobileDefaultFontSize),),
                              ],
                            ),
                          ),
                        );
                      }
                  ),
                ),

                Visibility(
                  visible: isVideos && !isSearch,
                  child: GridView.builder(
                      gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // number of items in each row
                        mainAxisSpacing: 8.0, // spacing between rows
                        crossAxisSpacing: 8.0, // spacing between columns
                        childAspectRatio: (4 / 4),
                      ),
                      shrinkWrap: true,
                      physics:const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8.0),
                      itemCount: generalBaseList.length,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          physics:const NeverScrollableScrollPhysics(),
                          child: Container(
                            alignment: Alignment.topCenter,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child:  Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {

                                    late YoutubePlayerController playerController;
                                    playerController = YoutubePlayerController(
                                        params: const YoutubePlayerParams(
                                          showControls: true,
                                          mute: false,
                                          showFullscreenButton: true,
                                          loop: false,
                                          strictRelatedVideos: true,
                                          enableJavaScript: true,
                                        ))..onInit = () {
                                      playerController.loadVideo(generalBaseList[index].videoDocumentLink!);
                                      playerController.stopVideo();
                                    };

                                    videoPopupDialog(context,generalBaseList[index].videoDocumentTitle!,playerController);
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      FadeInImage(
                                        placeholder: const AssetImage("assets/placeholder.png"),
                                        image: NetworkImage(generalBaseList[index].thumbnailLink!),
                                        fit: BoxFit.fill,
                                      ),
                                      Image.asset("assets/icon _play circle.png"),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Text(generalBaseList[index].videoDocumentTitle!,maxLines: 1,overflow: TextOverflow.ellipsis,style:  TextStyle(fontSize: !isPhone ? AppConstants.defaultFontSize : AppConstants.mobileDefaultFontSize),),
                                const SizedBox(height: 3,),
                                Text(generalBaseList[index].date!,maxLines: 1,overflow: TextOverflow.ellipsis,style:  TextStyle(fontSize: !isPhone ? AppConstants.defaultFontSize : AppConstants.mobileDefaultFontSize),),
                              ],
                            ),
                          ),
                        );
                      }
                  ),
                ),

                Visibility(
                  visible: !isVideos && !isSearch,
                  child: GridView.builder(
                      gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // number of items in each row
                        mainAxisSpacing: 8.0, // spacing between rows
                        crossAxisSpacing: 8.0, // spacing between columns
                        childAspectRatio: (4 / 4),
                      ),
                      shrinkWrap: true,
                      physics:const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8.0),
                      itemCount: pdfDocumentList.length,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          physics:const NeverScrollableScrollPhysics(),
                          child: Container(
                            alignment: Alignment.topCenter,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child:  Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                    onTap: () {
                                      _launchURL(pdfDocumentList[index].videoDocumentLink!);
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: Image.asset("assets/pdf_logo.png",fit: BoxFit.fill,))),
                                const SizedBox(height: 5,),
                                Text(pdfDocumentList[index].videoDocumentTitle!,maxLines: 1,overflow: TextOverflow.ellipsis,style:  TextStyle(fontSize: !isPhone ? AppConstants.defaultFontSize : AppConstants.mobileDefaultFontSize),),
                                const SizedBox(height: 3,),
                                Text(pdfDocumentList[index].date!,maxLines: 1,overflow: TextOverflow.ellipsis,style:  TextStyle(fontSize: !isPhone ? AppConstants.defaultFontSize : AppConstants.mobileDefaultFontSize),),
                              ],
                            ),
                          ),
                        );
                      }
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchURL(String url1) async {
    String url = url1;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void filterSearchResults(String query) {
    // ignore: avoid_print
    print(query);
    print("THis IS Search item");
    setState(() {
      // ignore: avoid_print
      searchBaseList = allItemBaseList
          .where((baseListResponse item) => (" ${item.videoDocumentTitle.toString()}").toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

}

class baseListResponse {
  String? thumbnailLink;
  String? videoDocumentLink;
  String? date;
  String? videoDocumentTitle;
  String? type;

  baseListResponse( {
    this.thumbnailLink,
    this.videoDocumentLink,
    this.date,
    this.videoDocumentTitle,
    this.type
  });

}
