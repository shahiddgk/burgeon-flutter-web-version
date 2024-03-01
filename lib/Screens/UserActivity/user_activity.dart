
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/dashboard_tiles.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/model/request_model/logout_user_request.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/reponse_model/user_activity_response_model.dart';
import '../Payment/payment_screen.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../PireScreens/widgets/PopMenuButton.dart';
import '../utill/userConstants.dart';

class UserActivity extends StatefulWidget {
  const UserActivity({Key? key}) : super(key: key);

  @override
  State<UserActivity> createState() => _UserActivityState();
}

class _UserActivityState extends State<UserActivity> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  bool _isDataLoading = true;
  String email = "";
  String timeZone = "";
  String userType = "";

  late bool isPhone;
  late bool isTable;
  late bool isDesktop;

  late UserActivityResponse userActivityResponse;

  @override
  void initState() {
    // TODO: implement initState

    _getUserData();

    super.initState();
  }

  _getUserData() async {
    //showUpdatePopup(context);
    setState(() {
      _isUserDataLoading = true;
    });
    //  print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;
    _getUserActivityDetails(id);
    setState(() {
      _isUserDataLoading = false;
    });
  }

  _getUserActivityDetails(String userId) {
    setState(() {
      _isDataLoading = true;
    });
    HTTPManager().getUserActivityData(LogoutRequestModel(userId: userId)).then((value) {

      setState(() {
        userActivityResponse = value;
        _isDataLoading = false;
      });

    }).catchError((e) {
      setState(() {
        _isDataLoading = false;
      });
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
    getScreenDetails();
    return  Scaffold(
      appBar: AppBarWidget().appBarGeneralButtons(
          context,
              () {
            Navigator.of(context).pop();
          }, false, true, true, id, true,true,0,false,0),
      body: Container(
        margin: const EdgeInsets.only(top: 1,),
        alignment: Alignment.center,
        decoration:const BoxDecoration(
          color: AppColors.userActivityBgColor
        ),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.asset("assets/user_activity_bg.png",fit: BoxFit.cover,),
              ),
              _isDataLoading ? const Center(child: CircularProgressIndicator(
                color: AppColors.backgroundColor,
              ),) : userActivityResponse.name ==  "" || userActivityResponse.name ==  "" ?  Container() :  Padding(
                padding: EdgeInsets.symmetric(horizontal:isPhone ? 10 : isTable ? MediaQuery.of(context).size.width/6  : MediaQuery.of(context).size.width/4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                    height: MediaQuery.of(context).size.height/14,
                  ),
                    Card(
                      color: AppColors.userActivityCardColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.userActivityCardRadius)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              child: const Text("NAQ",style: TextStyle(fontWeight: FontWeight.w400, fontSize: AppConstants.logoFontSizeForIpad),
                              ),),
                          const Divider(color: AppColors.backgroundColor,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: const Text("INITIAL NAQ/DATE",style: TextStyle(fontWeight: FontWeight.w500, fontSize: AppConstants.defaultFontSize),)),

                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child:  Text(userActivityResponse.minNaqResponse!,style:const TextStyle(fontWeight: FontWeight.w500,color:
                                AppColors.userActivityGreyColor, fontSize: AppConstants.defaultFontSize),),
                              ),
                            ],
                          ),
                          const Divider(color: AppColors.backgroundColor,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: const Text("LAST NAQ/DATE",style: TextStyle(fontWeight: FontWeight.w500, fontSize: AppConstants.defaultFontSize),)),

                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child:  Text(userActivityResponse.maxNaqResponse!,style: const TextStyle(fontWeight: FontWeight.w500,color:
                                AppColors.userActivityGreyColor, fontSize: AppConstants.defaultFontSize),),
                              ),
                            ],
                          ),
                          const Divider(color: AppColors.backgroundColor,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: const Text("DELTA",style: TextStyle(fontWeight: FontWeight.w500, fontSize: AppConstants.defaultFontSize),)),

                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child:  Text(userActivityResponse.delta!,style: const TextStyle(fontWeight: FontWeight.w500,color:
                                AppColors.userActivityGreyColor, fontSize: AppConstants.defaultFontSize),),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/16,
                    ),
                    Card(
                      color: AppColors.userActivityCardColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.userActivityCardRadius)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("90",style: TextStyle(fontWeight: FontWeight.w400, fontSize: AppConstants.logoFontSizeForIpad),),
                          const Divider(color: AppColors.backgroundColor,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: const Text("Date",style: TextStyle(fontWeight: FontWeight.w500, fontSize: AppConstants.defaultFontSize),)),

                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child:  Text(userActivityResponse.date!,style:const TextStyle(fontWeight: FontWeight.w500,color:
                                AppColors.userActivityGreyColor, fontSize: AppConstants.defaultFontSize),),
                              ),
                            ],
                          ),
                          const Divider(color: AppColors.backgroundColor,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: const Text("TRAILING 90 TOTAL",style: TextStyle(fontWeight: FontWeight.w500, fontSize: AppConstants.defaultFontSize),)),

                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child:  Text(userActivityResponse.totalCount!,style:const TextStyle(fontWeight: FontWeight.w500,color:
                                AppColors.userActivityGreyColor, fontSize: AppConstants.defaultFontSize),),
                              ),
                            ],
                          ),
                          const Divider(color: AppColors.backgroundColor,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: const Text("P.I.R.E. T-90",style: TextStyle(fontWeight: FontWeight.w500, fontSize: AppConstants.defaultFontSize),)),

                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child:  Text(userActivityResponse.countPire!,style:const TextStyle(fontWeight: FontWeight.w500,color:
                                AppColors.userActivityGreyColor, fontSize: AppConstants.defaultFontSize),),
                              ),
                            ],
                          ),
                          const Divider(color: AppColors.backgroundColor,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: const Text("TRELLIS T-90",style: TextStyle(fontWeight: FontWeight.w500, fontSize: AppConstants.defaultFontSize),)),

                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child:  Text(userActivityResponse.countTrellis!,style:const TextStyle(fontWeight: FontWeight.w500,color:
                                AppColors.userActivityGreyColor, fontSize: AppConstants.defaultFontSize),),
                              ),
                            ],
                          ),
                          const Divider(color: AppColors.backgroundColor,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: const Text("COLUMN T-90",style: TextStyle(fontWeight: FontWeight.w500, fontSize: AppConstants.defaultFontSize),)),

                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child:  Text(userActivityResponse.countColumn!,style:const TextStyle(fontWeight: FontWeight.w500,color:
                                AppColors.userActivityGreyColor, fontSize: AppConstants.defaultFontSize),),
                              ),
                            ],
                          ),
                          const Divider(color: AppColors.backgroundColor,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: const Text("LADDER T-90",style: TextStyle(fontWeight: FontWeight.w500, fontSize: AppConstants.defaultFontSize),)),

                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child:  Text(userActivityResponse.countLadder!,style:const TextStyle(fontWeight: FontWeight.w500,color:
                                AppColors.userActivityGreyColor, fontSize: AppConstants.defaultFontSize),),
                              ),
                            ],
                          ),
                          // const Divider(color: AppColors.backgroundColor,),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Container(
                          //         margin: const EdgeInsets.only(left: 20),
                          //         child: const Text("POST T-90",style: TextStyle(fontWeight: FontWeight.w500, fontSize: AppConstants.defaultFontSize),)),
                          //
                          //     Container(
                          //       margin: const EdgeInsets.only(right: 20),
                          //       child: Text(userActivityResponse.sumReminders!,style:const TextStyle(fontWeight: FontWeight.w500,color:
                          //       AppColors.userActivityGreyColor, fontSize: AppConstants.defaultFontSize),),
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
