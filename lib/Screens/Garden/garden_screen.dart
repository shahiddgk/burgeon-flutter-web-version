// ignore_for_file: library_private_types_in_public_api, unused_import, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../../Widgets/sub_categoy_border.dart';
import '../../model/reponse_model/growth_tree_response_count.dart';
import '../../model/request_model/logout_user_request.dart';
import '../../network/http_manager.dart';
import '../Payment/payment_screen.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../PireScreens/widgets/PopMenuButton.dart';
import '../UserActivity/user_activity.dart';
import '../Widgets/footer_widget.dart';
import '../dashboard_tiles.dart';
import '../utill/userConstants.dart';
import 'image_screen.dart';
import 'new_history_screen.dart';

class GardenScreen extends StatefulWidget {
  const GardenScreen({Key? key}) : super(key: key);

  @override
  _GardenScreenState createState() => _GardenScreenState();
}

class _GardenScreenState extends State<GardenScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email = "";
  String timeZone = "";
  String userType = "";

  late bool isPhone;
  late bool isTable;
  late bool isDesktop;

  late String score;
  late String treeType;
  late String mobileImageUrl;
  late String ipadImageUrl;

  late TreeGrowthResponse treeGrowthResponse;
  bool otherUserLoggedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    _getUserData();
    // TODO: implement initState
    super.initState();
  }

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    // print("Data getting called");
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
      score = sharedPreferences.getString("Score")!;
      mobileImageUrl = sharedPreferences.getString("MobileImageURL")!;
      ipadImageUrl = sharedPreferences.getString("IpadImageURL")!;

      // _getSkippedReminderList();
    }
    _getTreeGrowth();

    setState(() {
      _isUserDataLoading = false;
    });
  }

  _getTreeGrowth() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setString("Score", "");
      _isLoading = true;
    });

    HTTPManager().treeGrowth(LogoutRequestModel(userId: id.toString())).then((value)  {

      setState(() {
        treeGrowthResponse = value;
        mobileImageUrl = treeGrowthResponse.mobileImageUrl.toString();
        ipadImageUrl = treeGrowthResponse.ipadImageUrl.toString();
      });

      setState(() {
        _isLoading = false;
      });
      //  showToastMessage(context, value['message'].toString(),true);
    }).catchError((e) {
    });

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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    getScreenDetails();
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget().appBarGeneralButtonsWithOtherUserLogged(
          context,
              () {
            Navigator.of(context).pop();
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (BuildContext context) =>const Dashboard()),
            //         (Route<dynamic> route) => false
            // );
          }, true, true, true, id, true,true,0,false,0,otherUserLoggedIn,name),
      body: _isLoading? const Center(child: CircularProgressIndicator(),) : Container(
        alignment: Alignment.topCenter,
        color: AppColors.backgroundColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LogoScreen("Garden"),
                    // Align(
                    //   alignment: Alignment.topLeft,
                    //   child: Container(
                    //       padding: EdgeInsets.only(top: 1),
                    //       width: MediaQuery.of(context).size.width,
                    //       child: QuestionTextWidget(widget.questionListResponse[4].subTitle)),
                    // ),

                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        alignment: Alignment.topCenter,
                        margin: const EdgeInsets.only(top: 10),
                        height:!isPhone ? MediaQuery.of(context).size.height/1.28  : MediaQuery.of(context).size.height/1.45,
                        width: MediaQuery.of(context).size.width,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height/8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const NewHistoryScreen()));
                                  },
                                  child: OptionMcqAnswerSubCategory(
                                       Container(
                                         padding:const EdgeInsets.symmetric(horizontal: 30),
                                         child: const Center(
                                           child: Text("History",style: TextStyle(fontSize: 22),),
                                         ),
                                       )
                                  ),
                                ),
                               const SizedBox(width: 5,),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ImageScreen(!isPhone ? ipadImageUrl : mobileImageUrl)));
                                  },
                                  child: OptionMcqAnswerSubCategory(
                                      Container(
                                        padding:const EdgeInsets.symmetric(horizontal: 30),
                                        child:const Center(
                                          child: Text("Current",style: TextStyle(fontSize: 22),),
                                        ),
                                      )
                                  ),
                                ),
                              ]
                          ),
                        )
                        // GridView.count(
                        //     padding: const EdgeInsets.symmetric(vertical:10,horizontal: 10),
                        //     crossAxisCount:!isPhone ? 4 : 2,
                        //     crossAxisSpacing: 4.0,
                        //     mainAxisSpacing: 2.0,
                        //     childAspectRatio: 2,
                        //     shrinkWrap: true,
                        //     scrollDirection: Axis.vertical,
                        //     children: [
                        //       InkWell(
                        //         onTap: () {
                        //           Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const NewHistoryScreen()));
                        //         },
                        //         child: OptionMcqAnswer(
                        //             const Card(
                        //               color: AppColors.primaryColor,
                        //               child: Center(
                        //                 child: Text("History",style: TextStyle(fontSize: 22),),
                        //               ),
                        //             )
                        //         ),
                        //       ),
                        //       InkWell(
                        //         onTap: () {
                        //           Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ImageScreen(!isPhone ? ipadImageUrl : mobileImageUrl)));
                        //         },
                        //         child: OptionMcqAnswer(
                        //             const Card(
                        //               color: AppColors.primaryColor,
                        //               child: Center(
                        //                 child: Text("Current",style: TextStyle(fontSize: 22),),
                        //               ),
                        //             )
                        //         ),
                        //       ),
                        //     ]
                        // ),
                      ),
                    ),

                  ],
                ),
              ),
              // const FooterWidget(),
            ],
          )
        ),
      ),
    );
  }
}
