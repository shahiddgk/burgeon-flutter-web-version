// ignore_for_file: unnecessary_import, avoid_print, prefer_final_fields, unused_local_variable


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/video_screen.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/constants.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../Widgets/sub_categoy_border.dart';
import '../../Widgets/video_player_in_pop_up.dart';
import '../Payment/payment_screen.dart';
import '../PireScreens/widgets/PopMenuButton.dart';
import '../UserActivity/user_activity.dart';
import '../Widgets/toast_message.dart';
import '../dashboard_tiles.dart';
import '../utill/userConstants.dart';

class PireCategoryScreen extends StatefulWidget {
  const PireCategoryScreen({Key? key}) : super(key: key);

  @override
  State<PireCategoryScreen> createState() => _PireCategoryScreenState();
}

class _PireCategoryScreenState extends State<PireCategoryScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  bool _isLoading = false;
  String email = "";
  String timeZone = "";
  String userType = "";


  bool isTextField = true;
  bool isYesNo = false;
  bool isOptions = false;

  String userPremium = "";
  String userPremiumType = "";
  String userCustomerId = "";
  String userSubscriptionId = "";
  String allowEmail = "";

  String naqListLength = "";
  String bodyScanVideoUrl = "https://www.youtube.com/watch?v=whc21PAm4tQ";
  String favPlaceOnEarth = "https://www.youtube.com/watch?v=26ArgGvNTAE";

  late bool isPhone;
  late bool isTable;
  late bool isDesktop;

  bool otherUserLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState

    _getUserData();
    super.initState();
  }

  getScreenDetails() {
    setState(() {
    });
    if(MediaQuery.of(context).size.width< 650) {
      isPhone = true;
      isDesktop = false;
      isTable = false;
    } else if (MediaQuery.of(context).size.width >= 650 && MediaQuery.of(context).size.width < 1100) {
      isTable = true;
      isPhone = false;
      isDesktop = false;
    } else if(MediaQuery.of(context).size.width >= 1100) {
      isPhone = false;
      isDesktop = true;
      isTable = false;
    }
    setState(() {
    });
  }

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    print("Data getting called");
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
      allowEmail = sharedPreferences.getString(UserConstants().allowEmail)!;
      userPremium = sharedPreferences.getString(UserConstants().userPremium)!;
      userPremiumType =
      sharedPreferences.getString(UserConstants().userPremiumType)!;
      userCustomerId =
      sharedPreferences.getString(UserConstants().userCustomerId)!;
      userSubscriptionId =
      sharedPreferences.getString(UserConstants().userSubscriptionId)!;

      // _getNAQResonseList(id);
      // _getSkippedReminderList();
    }

    // _getNAQResonseList(id);
    //
    setState(() {
      _isUserDataLoading = false;
    });
  }

  // _getNAQResonseList(String id) {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   HTTPManager().naqResponseList(LogoutRequestModel(userId: id)).then((value) {
  //     print(value);
  //     setState(() {
  //       _isLoading = false;
  //       // naqListResponse = value.values;
  //       naqListLength = value.values.length.toString();
  //     });
  //     print("Naq list length");
  //     print(naqListLength);
  //   }).catchError((e){
  //     print(e);
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  // }


  Future<bool> _onWillPop() async {

    if(otherUserLoggedIn) {
      Navigator.of(context).pop();
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const Dashboard()),
              (Route<dynamic> route) => false
      );
    }
    // int count = 0;
    // Navigator.of(context).popUntil((_) => count++ >= 11);
    return true;
  }
  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    getScreenDetails();
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBarWidget().appBarGeneralButtonsWithOtherUserLogged(
            context,
                () {
              if(otherUserLoggedIn) {
                Navigator.of(context).pop();
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => const Dashboard()),
                        (Route<dynamic> route) => false
                );
              }
            }, true, true, true, id, true,true,0,false,0,otherUserLoggedIn,name),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LogoScreen("PIRE"),
              Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.only(top: 10),
                height:!isPhone ? MediaQuery.of(context).size.height/1.27  : MediaQuery.of(context).size.height/1.93,
                width: MediaQuery.of(context).size.width,
                child: _isLoading ? const Center(child: CircularProgressIndicator(),) : GridView.count(
                  padding:  EdgeInsets.symmetric(vertical:10,horizontal:!isPhone ? MediaQuery.of(context).size.width/5 : 20),
                  crossAxisCount:isPhone ? 2 : isTable ? 3 : 4,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 2.0,
                  childAspectRatio: 1.6,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    InkWell(
                      onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (
                              context) => const VideoScreen()));

                      },
                      child: OptionMcqAnswerSubCategory(
                           Card(
                            elevation: 0,
                            color: AppColors.backgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: Text("P.I.R.E. Challenge",textAlign: TextAlign.center,style: TextStyle(fontSize:isPhone ? AppConstants.mobileHeadingFontSize : isTable ? AppConstants.tabletHeadingFontSize : AppConstants.headingFontSize),),
                              ),
                            ),
                          )
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showToastMessage(context, "Coming Soon...",false);
                        //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const PireCategoryScreen()));
                      },
                      child: OptionMcqAnswerSubCategory(
                            Card(
                            elevation: 0,
                            color: AppColors.greyColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: Text("P.I.R.E. Positive",textAlign: TextAlign.center,style: TextStyle(fontSize:isPhone ? AppConstants.mobileHeadingFontSize : isTable ? AppConstants.tabletHeadingFontSize : AppConstants.headingFontSize),),
                              ),
                            ),
                          )
                      ),
                    ),
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
                          playerController.loadVideo(bodyScanVideoUrl);
                          playerController.stopVideo();
                        };

                        // showToastMessage(context, "Coming Soon...",false);
                        // String? videoId = YoutubePlayer.convertUrlToId(bodyScanVideoUrl);
                        // YoutubePlayerController playerController0 = YoutubePlayerController(
                        //     initialVideoId: videoId!,
                        //     flags: const YoutubePlayerFlags(
                        //       autoPlay: false,
                        //       controlsVisibleAtStart: false,
                        //     )
                        //
                        // );
                        videoPopupDialog(context,"Body Scan",playerController);
                      },
                      child: OptionMcqAnswerSubCategory(
                            Card(
                            elevation: 0,
                            color: AppColors.backgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: Text("Body Scan",textAlign: TextAlign.center,style: TextStyle(fontSize:isPhone ? AppConstants.mobileHeadingFontSize : isTable ? AppConstants.tabletHeadingFontSize : AppConstants.headingFontSize),),
                              ),
                            ),
                          )
                      ),
                    ),
                    InkWell(
                      onTap: () {

                        late YoutubePlayerController playerController0;
                        playerController0 = YoutubePlayerController(
                            params: const YoutubePlayerParams(
                              showControls: true,
                              mute: false,
                              showFullscreenButton: true,
                              loop: false,
                              strictRelatedVideos: true,
                              enableJavaScript: true,
                            ))..onInit = () {
                          playerController0.loadVideo(favPlaceOnEarth);
                          playerController0.stopVideo();
                        };
                        // showToastMessage(context, "Coming Soon...",false);
                        // String? videoId = YoutubePlayer.convertUrlToId(favPlaceOnEarth);
                        // YoutubePlayerController playerController0 = YoutubePlayerController(
                        //     initialVideoId: videoId!,
                        //     flags: const YoutubePlayerFlags(
                        //       autoPlay: false,
                        //       controlsVisibleAtStart: false,
                        //     )
                        //
                        // );
                        videoPopupDialog(context,"Favourite Place on Earth",playerController0);
                      },
                      child: OptionMcqAnswerSubCategory(
                            Card(
                            elevation: 0,
                            color: AppColors.backgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: Text("Favorite Place on Earth",textAlign: TextAlign.center,style: TextStyle(fontSize:isPhone ? AppConstants.mobileHeadingFontSize : isTable ? AppConstants.tabletHeadingFontSize : AppConstants.headingFontSize),),
                              ),
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ),
              // const FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
