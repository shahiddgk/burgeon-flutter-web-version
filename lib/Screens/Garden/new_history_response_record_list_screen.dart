

// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../model/reponse_model/garden_response_model.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../utill/userConstants.dart';
import 'new_history_record_details_screen.dart';

class NewHistoryResponseRecordListScreen extends StatefulWidget {
  NewHistoryResponseRecordListScreen(this.pireRecordList,this.isTrellisColumnLadder,this.dateHistory,{Key? key}) : super(key: key);
  List<TrellisCount>? pireRecordList;
  String isTrellisColumnLadder;
  String dateHistory;

  @override
  // ignore: library_private_types_in_public_api
  _NewHistoryResponseRecordListScreenState createState() => _NewHistoryResponseRecordListScreenState();
}

class _NewHistoryResponseRecordListScreenState extends State<NewHistoryResponseRecordListScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email = "";
  String timeZone = "";
  String userType = "";
  late bool isPhone;
  // late NewGardenResponseModel newGardenResponseModel;
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

    // getNewResponseHistoryDetails();
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
  // getNewResponseHistoryDetails() {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   HTTPManager().getNewGardenData(LogoutRequestModel(userId: id)).then((value) {
  //
  //     setState(() {
  //       newGardenResponseModel = value;
  //       errorMessage = "";
  //       _isLoading = false;
  //     });
  //     newGardenResponseModel.responseData!.sort((a,b) => b.date!.compareTo(a.date!));
  //
  //     print("History List Model");
  //     print(newGardenResponseModel.responseData?[0].date);
  //   }).catchError((e) {
  //     //print(e);
  //     setState(() {
  //       _isLoading = false;
  //       errorMessage = e.toString();
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();

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
            Container(
              margin:  EdgeInsets.only(bottom:40,top: 10,left:isPhone ? 10 : MediaQuery.of(context).size.width/3 ,right: isPhone ? 10 : MediaQuery.of(context).size.width/3 ,),
              child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:!isPhone ? 6 : 4,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 2.0,
                    childAspectRatio: 2,
                  ),
                  itemCount:  widget.pireRecordList!.length,
                  physics:const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AnswerDetailsScreen(widget.pireRecordList![index].responseId!,widget.isTrellisColumnLadder,widget.dateHistory)));
                      },
                      child: Container(
                        alignment:Alignment.center,
                        decoration:BoxDecoration(
                            border: Border.all(color: AppColors.primaryColor,width: 3),
                            color: AppColors.backgroundColor,
                          borderRadius: const BorderRadius.all(Radius.elliptical(80, 50)),
                        ),
                        child: Text("${index + 1}",style: const TextStyle(color: AppColors.textWhiteColor),),
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
