// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:flutter_quiz_app/model/request_model/logout_user_request.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../../model/reponse_model/garden_response_model.dart';
import '../Payment/payment_screen.dart';
import '../PireScreens/widgets/PopMenuButton.dart';
import '../UserActivity/user_activity.dart';
import '../dashboard_tiles.dart';
import '../utill/userConstants.dart';
import 'new_history_category_screen.dart';
import 'package:intl/intl.dart';

class NewHistoryScreen extends StatefulWidget {
  const NewHistoryScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NewHistoryScreenState createState() => _NewHistoryScreenState();
}

class _NewHistoryScreenState extends State<NewHistoryScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email = "";
  String timeZone = "";
  String userType = "";
  bool _isLoading = true;
  late bool isPhone;
  late LevelHistoryResponse levelHistoryResponse;
  String errorMessage = "";
  bool otherUserLoggedIn = false;

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

      // _getSkippedReminderList();
    }

    getNewResponseHistory();
    setState(() {
      _isUserDataLoading = false;
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

  getNewResponseHistory() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().getLevelHistoryData(LogoutRequestModel(userId: id)).then((value) {

      setState(() {
        levelHistoryResponse = value;
        errorMessage = "";
        _isLoading = false;
      });
      levelHistoryResponse.responseData!.sort((a,b) => b.date!.compareTo(a.date!));

      print("History List Model");
      print(levelHistoryResponse.responseData?[0].date);
    }).catchError((e) {
      //print(e);
      setState(() {
        _isLoading = false;
        errorMessage = e.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();
    /*24 is for notification bar on Android*/
    return Scaffold(
      appBar: AppBarWidget().appBarGeneralButtonsWithOtherUserLogged(
          context,
              () {
            Navigator.of(context).pop();
          }, true, true, true, id, true,true,0,false,0,otherUserLoggedIn,name),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          //  mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LogoScreen("Garden"),
            _isLoading ? const Center(
              child: CircularProgressIndicator(),
            ) : errorMessage != "" ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(errorMessage,style:const TextStyle(fontSize: 25),),
                  const SizedBox(height: 5,),
                  InkWell(
                    onTap: () {
                      getNewResponseHistory();
                    },
                    child: OptionMcqAnswer(
                        TextButton(onPressed: () {
                          getNewResponseHistory();
                        }, child: const Text("Reload",style: TextStyle(fontSize:25,color: AppColors.redColor)),)
                    ),
                  )
                ],
              ),
            ) : levelHistoryResponse.responseData!.isEmpty ? OptionMcqAnswer(
                const Text( "No data available",style: TextStyle(fontSize:25,color: AppColors.textWhiteColor),)
            )  : Container(
              margin: EdgeInsets.only(bottom: 40,left: !isPhone ? MediaQuery.of(context).size.width/3 :10,right: !isPhone ? MediaQuery.of(context).size.width/3 :10,),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: levelHistoryResponse.responseData!.length,
                  physics:const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NewHistoryCategoryScreen(levelHistoryResponse.responseData![index],DateFormat('MM-dd-yy').format(DateTime.parse(levelHistoryResponse.responseData![index].date.toString())))));
                                },
                                child: Container(
                                  alignment:Alignment.center,
                                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                  decoration:BoxDecoration(
                                    border: Border.all(color: AppColors.primaryColor,width: 3),
                                    color: AppColors.backgroundColor,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Text(levelHistoryResponse.responseData![index].date.toString()),
                                ),
                              )),
                          // Expanded(
                          //     child: InkWell(
                          //       child: Container(
                          //         alignment:Alignment.center,
                          //         padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                          //         decoration:BoxDecoration(
                          //             color: AppColors.primaryColor,
                          //             borderRadius: BorderRadius.circular(10)
                          //         ),
                          //         child: Text("P.I.R.E. (${newGardenResponseModel.responseData![index].pireCount!.length})"),
                          //       ),
                          //     )),
                          // Expanded(
                          //     child: InkWell(
                          //       child: Container(
                          //         alignment:Alignment.center,
                          //         padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                          //         decoration:BoxDecoration(
                          //             color: AppColors.primaryColor,
                          //             borderRadius: BorderRadius.circular(10)
                          //         ),
                          //         child: Text("Naq (${newGardenResponseModel.responseData![index].naqCount!.length})"),
                          //       ),
                          //     )),
                        ],
                      ),
                    );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
