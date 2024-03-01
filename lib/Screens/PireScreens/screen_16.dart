// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/video_screen.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/option_mcq_widget.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../Widgets/video_player_in_pop_up.dart';
import '../../model/reponse_model/Sage/accepted_connections_list_response.dart';
import '../../model/request_model/logout_user_request.dart';
import '../../network/http_manager.dart';
import '../Widgets/share_pop_up_dialogue.dart';
import '../utill/userConstants.dart';

class Screen16 extends StatefulWidget {
  Screen16(this.number,this.pireId,{Key? key}) : super(key: key);

  String number;
  String pireId;

  @override
  // ignore: library_private_types_in_public_api
  _Screen16State createState() => _Screen16State();
}

class _Screen16State extends State<Screen16> with SingleTickerProviderStateMixin {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  late final AnimationController _animationController;
  List<AcceptedConnectionItem> acceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> searchAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> selectedUserAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  bool _isLoading = true;
  late bool isPhone;


  @override
  void initState() {
    _getUserData();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.repeat(reverse: true);

    // TODO: implement initState
    super.initState();
  }

  String email = "";
  String timeZone = "";
  String userType = "";
  int badgeCount1 = 0;
  int badgeCountShared = 0;

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    // print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
    // badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;

    getConnectionList();

    setState(() {
      _isUserDataLoading = false;
    });
  }


  getConnectionList() {
    setState(() {
      _isLoading = true;
    });

    HTTPManager().getAcceptedConnectionList(LogoutRequestModel(userId: id)).then((value) {
      setState(() {

        acceptedConnectionsListResponse = value.data!;
        searchAcceptedConnectionsListResponse = acceptedConnectionsListResponse;
        // searchAcceptedConnectionsListResponse = value.data!;

        for(int i = 0;i<acceptedConnectionsListResponse.length;i++ ) {
          if(id == acceptedConnectionsListResponse[i].firstUserDetail!.id) {
            acceptedConnectionsListResponse.sort((a, b) {
              return a.secondUserDetail!.name!.toLowerCase().compareTo(b.secondUserDetail!.name!.toLowerCase());
            });
            searchAcceptedConnectionsListResponse.sort((a, b) {
              return a.secondUserDetail!.name!.toLowerCase().compareTo(b.secondUserDetail!.name!.toLowerCase());
            });
          } else {
            acceptedConnectionsListResponse.sort((a, b) {
              return a.firstUserDetail!.name!.toLowerCase().compareTo(b.firstUserDetail!.name!.toLowerCase());
            });
            searchAcceptedConnectionsListResponse.sort((a, b) {
              return a.firstUserDetail!.name!.toLowerCase().compareTo(b.firstUserDetail!.name!.toLowerCase());
            });
          }
        }

        _isLoading = false;
        print("LIST RESPONSE CALLED");
        print(searchAcceptedConnectionsListResponse);

      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
    });
  }
  Future<bool> _onWillPop() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const VideoScreen()),
            (Route<dynamic> route) => false
    );
    // int count = 0;
    // Navigator.of(context).popUntil((_) => count++ >= 11);
      return true;
    }


  getScreenDetails() {
    setState(() {
      // _isDataLoading = true;
    });
    if(MediaQuery.of(context).size.width<= 600) {
      isPhone = true;
    } else {
      isPhone = false;
    }
    setState(() {
      // _isDataLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar:  AppBarWidget().appBarGeneralButtons(
            context,
                () {
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (BuildContext context) =>const Dashboard()),
              //         (Route<dynamic> route) => false
              // );
            }, true, true, true, id, false,true,badgeCount1,false,badgeCountShared),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: !isPhone ? MediaQuery.of(context).size.width/4 : 0),
          color: AppColors.backgroundColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child:_isLoading ? const Center(
            child: CircularProgressIndicator(),
          ) : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            const  Padding(padding: EdgeInsets.only(top: 40)),
              LogoScreen("PIRE"),
             // QuestionTextWidget(widget.number),
              SizedBox(
                width: MediaQuery.of(context).size.width/4,
                child: QuestionTextWidget(widget.number=="Worse" ?
                "I'm so sorry…This will get easier, promise!"
                    : widget.number=="Same"
                    ? "That's okay. Often it just takes a little practice."
                    :widget.number=="Mixed Emotions"
                    ? "That's totally normal when processing hard situations. It will get better."
                    : widget.number=="Better"
                    ? "That's great! Keep up the good work."
                    : widget.number=="Awesome" ? "Yes! That's wonderful. Enjoy!" : "","",(){
                  String urlQ1 = "https://www.youtube.com/watch?v=RHiFWm5-r3g";

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
                    playerController.loadVideo(urlQ1);
                    playerController.stopVideo();
                  };

                  // String? videoId = YoutubePlayer.convertUrlToId(urlQ1);
                  // YoutubePlayerController youtubePlayerController = YoutubePlayerController(
                  //     initialVideoId: videoId!,
                  //     flags: const YoutubePlayerFlags(
                  //       autoPlay: false,
                  //       controlsVisibleAtStart: false,
                  //     )
                  //
                  // );
                  videoPopupDialog(context, "Introduction to question#1", playerController);
                },true),
              ),
                  const SizedBox(
                    height: 10,
                  ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height/3,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset("assets/thumbs_up_like.gif")),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) =>const VideoScreen()),
                              (Route<dynamic> route) => false
                      );
                    },
                    child:OptionMcqAnswer(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                        child: const Column(
                          children: [
                            Icon(Icons.home,size:30,color: AppColors.primaryColor,),
                            Text("Back to Home Screen",style: TextStyle(color: AppColors.textWhiteColor))
                          ],
                        ),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      showThumbsUpDialogue(context, _animationController, id, 'pire', widget.pireId, selectedUserAcceptedConnectionsListResponse, searchAcceptedConnectionsListResponse, acceptedConnectionsListResponse);
                    },
                    child:OptionMcqAnswer(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                        child: const Column(
                          children: [
                            Icon(Icons.share,size:30,color: AppColors.primaryColor,),
                            Text("Share you Response",style: TextStyle(color: AppColors.textWhiteColor))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
                  //QuestionTextWidget("Good luck"),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.pushAndRemoveUntil(
                  //         context,
                  //         MaterialPageRoute(builder: (BuildContext context) =>const VideoScreen()),
                  //             (Route<dynamic> route) => false
                  //     );
                  //   },
                  //   child: SizedBox(
                  //     width: MediaQuery.of(context).size.width/4,
                  //     child: OptionMcqAnswer(
                  //        TextButton(onPressed: () {
                  //          // int count = 0;
                  //          // Navigator.of(context).popUntil((_) => count++ >= 11);
                  //          Navigator.pushAndRemoveUntil(
                  //              context,
                  //              MaterialPageRoute(builder: (BuildContext context) =>const VideoScreen()),
                  //                  (Route<dynamic> route) => false
                  //          );
                  //        }, child: const Text("Back to Home Screen",style: TextStyle(color: AppColors.textWhiteColor)),)
                  //     ),
                  //   ),
                  // )
            ],
          ),
        ),
      ),
    );
  }
}
