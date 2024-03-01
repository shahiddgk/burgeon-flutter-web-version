import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_quiz_app/Screens/Ladder/Ladder_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/constants.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../../model/reponse_model/Sage/accepted_connections_list_response.dart';
import '../../model/reponse_model/pire_naq_list_response_model.dart';
import '../../model/request_model/logout_user_request.dart';
import '../../model/request_model/pire_naq_request_model.dart';
import '../../network/http_manager.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../Widgets/share_pop_up_dialogue.dart';
import '../utill/userConstants.dart';

class PireDetailsScreen extends StatefulWidget {
  const PireDetailsScreen({Key? key,required this.responseId,required this.type,required this.score}) : super(key: key);

  final String responseId;
  final String type;
  final String score;

  @override
  State<PireDetailsScreen> createState() => _PireNaqDeatilsScreenState();
}

class _PireNaqDeatilsScreenState extends State<PireDetailsScreen> with SingleTickerProviderStateMixin {

  String name = "";
  String id = "";

  bool otherUserLoggedIn = false;

  bool _isUserDataLoading = true;
  String email = "";
  String timeZone = "";
  String userType = "";
  bool _isLoading = true;
  bool _isLoading1 = true;
  late bool isPhone;

  bool isError = false;
  String errorText = "";

  List<PireNaqQuestionItem> pireNaqQuestionList = <PireNaqQuestionItem>[];

  late final AnimationController _animationController;
  List<AcceptedConnectionItem> acceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> searchAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> selectedUserAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];

  _getUserData() async {
    //showUpdatePopup(context);
    setState(() {
      _isUserDataLoading = true;
    });
    //  print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
    // badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;
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
    if(!otherUserLoggedIn) {
      setState(() {
        _isLoading = true;
      });
    }

    getConnectionList();

    if(widget.type == "naq") {
      _getNaqQuestionList();
    } else {
      _getPireQuestionList();
    }
    setState(() {
      _isUserDataLoading = false;
    });
  }

  getConnectionList() {
    setState(() {
      _isLoading1 = true;
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

        _isLoading1 = false;

      });
    }).catchError((e) {
      setState(() {
        _isLoading1 = false;
      });
    });
  }

  _getPireQuestionList() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().pireSingleItemResponse(PireNaqSingleItemRequestModel(responseId: widget.responseId)).then((value) {
      setState(() {
        pireNaqQuestionList = value.responses!;
        _isLoading = false;
        isError = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
        isError = true;
        errorText = e.toString();
      });
    });
  }

  _getNaqQuestionList() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().naqSingleItemResponse(PireNaqSingleItemRequestModel(responseId: widget.responseId)).then((value) {
      setState(() {
        pireNaqQuestionList = value.responses!;
        _isLoading = false;
        isError = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
        isError = true;
        errorText = e.toString();
      });
    });
  }

  getScreenDetails() {
    // setState(() {
    //   _isLoading = true;
    // });
    if(MediaQuery.of(context).size.width<= 500) {
      isPhone = true;
    } else {
      isPhone = false;
    }
    // setState(() {
    //   _isLoading = false;
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();
    return Scaffold(
      appBar: _isUserDataLoading ? AppBar() : AppBarWidget().appBarGeneralButtonsWithOtherUserLogged(
          context,
              () {
            Navigator.of(context).pop();
          }, true, true, true, id, true,false,0,false,0,otherUserLoggedIn,name),
      body: Column(
        children: [
          widget.type == "naq" ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LogoScreen("NAQ"),
              if(!otherUserLoggedIn)
              IconButton(onPressed: (){
                showThumbsUpDialogue(context, _animationController, id, 'naq', widget.responseId, selectedUserAcceptedConnectionsListResponse, searchAcceptedConnectionsListResponse, acceptedConnectionsListResponse);
              }, icon: const Icon(Icons.share,color: AppColors.primaryColor,))
            ],
          ) : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LogoScreen("PIRE"),
              if(!otherUserLoggedIn)
              IconButton(onPressed: (){
                showThumbsUpDialogue(context, _animationController, id, 'pire', widget.responseId, selectedUserAcceptedConnectionsListResponse, searchAcceptedConnectionsListResponse, acceptedConnectionsListResponse);
              }, icon: const Icon(Icons.share,color: AppColors.primaryColor,))
            ],
          ),

          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: !isPhone ? MediaQuery.of(context).size.width/5 : 5 ),
              child: _isLoading || _isLoading1 ? const Center(child: CircularProgressIndicator(),)
                  : isError ? Center(child: Column(
                children: [
                  Text(errorText,style: const TextStyle(color: AppColors.redColor),),
                  const SizedBox(height: 10,),
                  InkWell(
                      onTap: () {
                        _getPireQuestionList();
                      },
                      child: OptionMcqAnswer(const Text("Reload",style: TextStyle(color: AppColors.redColor),))),
                ],
              ),) : pireNaqQuestionList.isEmpty ? const Center(child: Text("Answers Not Found"),) :  OptionMcqAnswer(
                 Column(
                   children: [
                     if(widget.type == "naq")
                     Text("Your NAQ Score is ${widget.score}/100",style: const TextStyle(fontWeight: FontWeight.bold),),
                     if(widget.type == "naq")
                     const Divider(color: AppColors.primaryColor,),
                     Expanded(
                       child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: pireNaqQuestionList.length,
                          itemBuilder: (context,index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(" Question ${index + 1} : "),
                                    Expanded(
                                      child: Html(data: pireNaqQuestionList[index].title!.replaceAll("Q${index + 1}:", ""),style: {
                                        "#" : Style(
                                          color: AppColors.textWhiteColor,
                                          fontSize: FontSize(AppConstants.defaultFontSize),
                                          textAlign: TextAlign.start,

                                        ),
                                      },),
                                    ),
                                  ],
                                ),
                                if(pireNaqQuestionList[index].options!="")
                                  Row(
                                    children: [
                                      const Text(" Answer: ",style:  TextStyle(fontSize: AppConstants.defaultFontSize,fontWeight: FontWeight.bold),textAlign: TextAlign.start),
                                      Expanded(
                                        child: Html(data: pireNaqQuestionList[index].options!.capitalize().replaceAll("Never", "1 - Never").replaceAll("Rarely", "2 - Rarely").replaceAll("Often", "3 - Often").replaceAll("Always", "4 - Always"),style: {
                                          "#" : Style(
                                            color: AppColors.textWhiteColor,
                                            fontSize: FontSize(AppConstants.defaultFontSize),
                                            textAlign: TextAlign.start,

                                          ),
                                        },),
                                      ),
                                    ],),
                                if(pireNaqQuestionList[index].text!="")
                                  Row(
                                    children: [
                                      const Text(" Answer: ",style:  TextStyle(fontSize: AppConstants.defaultFontSize,fontWeight: FontWeight.bold),textAlign: TextAlign.start),
                                      // Text(sharedItemDetailsResponse.data![index]..type == "naq" && newGardenHistoryResponseDetailsModel.data![index].options! == "yes" ? "  Why Yes:" : "   Answer: ",style:  const TextStyle(fontSize: AppConstants.defaultFontSize,fontWeight: FontWeight.bold),textAlign: TextAlign.start),
                                      Expanded(
                                        child: Html(data: pireNaqQuestionList[index].text!,style: {
                                          "#" : Style(
                                            color: AppColors.textWhiteColor,
                                            fontSize: FontSize(AppConstants.defaultFontSize),
                                            textAlign: TextAlign.start,

                                          ),
                                        },),
                                      ),
                                    ],),
                                const Divider(color: AppColors.primaryColor,height: 2,)
                              ],
                            );
                          }),
                     ),
                   ],
                 ),
              ),
            ),
          )
        ],),
    );
  }
}