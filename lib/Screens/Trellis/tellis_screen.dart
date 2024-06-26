// ignore_for_file: avoid_print, duplicate_ignore, unused_element, use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Trellis/widgets/add_widgets_button.dart';
import 'package:flutter_quiz_app/Screens/Trellis/widgets/bottom_sheet.dart';
import 'package:flutter_quiz_app/Screens/Trellis/widgets/expansion_tile_widget.dart';
import 'package:flutter_quiz_app/Screens/Trellis/widgets/name_field.dart';
import 'package:flutter_quiz_app/Screens/Trellis/widgets/save_button_widgets.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/model/request_model/logout_user_request.dart';
import 'package:flutter_quiz_app/model/request_model/read_trellis_model.dart';
import 'package:flutter_quiz_app/model/request_model/trellis_data_saving_request.dart';
import 'package:flutter_quiz_app/model/request_model/trellis_delete_request_model.dart';
import 'package:flutter_quiz_app/model/request_model/trellis_identity_request_model.dart';
import 'package:flutter_quiz_app/model/request_model/tribe_data_saving_request.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/video_player_in_pop_up.dart';
import '../../model/reponse_model/Sage/accepted_connections_list_response.dart';
import '../../model/reponse_model/trellis_ladder_data_response.dart';
import '../../model/reponse_model/trellis_new_tribe_insertion.dart';
import '../../model/reponse_model/trellis_principle_data_response.dart';
import '../../model/reponse_model/tribe_new_read_data_response.dart';
import '../../model/request_model/trellis_ladder_request_model.dart';
import '../../model/request_model/trellis_principles_request_model.dart';
import '../Payment/payment_screen.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../utill/userConstants.dart';

class TrellisScreen extends StatefulWidget {
  const TrellisScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TrellisScreenState createState() => _TrellisScreenState();
}

class _TrellisScreenState extends State<TrellisScreen> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email = "";
  String timeZone = "";
  String userType = "";

  bool otherUserLoggedIn = false;

  String selectedValueFromBottomSheet = "Mentor";

  String userPremium = "";
  String userPremiumType = "";
  String userCustomerId = "";
  String userSubscriptionId = "";

  bool _isLoading = true;
  bool _isDataLoading = false;
  late bool isPhone;
  late List <dynamic> trellisData;
  List <TrellisLadderDataModel> trellisLadderDataForGoalsAchievements = [];
  List <TrellisLadderDataModel> trellisLadderDataForGoals = [];
  List <TrellisLadderDataModel> trellisLadderDataForGoalsChallenges = [];
  List <TrellisLadderDataModel> trellisLadderDataForAchievements = [];

  List <TrellisLadderDataModel> trellisLadderDataForGoalsFavourites = [];
  List <TrellisLadderDataModel> trellisLadderDataForChallengesFavourites = [];
  List <TrellisLadderDataModel> trellisLadderDataForMemoriesFavourites = [];
  List <TrellisLadderDataModel> trellisLadderDataForAchievementsFavourites = [];

  late List <dynamic> trellisIdentityNeedsData;
  List <dynamic> trellisNeedsData = [];
  List <dynamic> trellisIdentityData = [];
  List <Trellis_principle_data_model_class> trellisPrinciplesRhythmsData = [];
  List <Trellis_principle_data_model_class> trellisPrinciplesData = [];
  List <Trellis_principle_data_model_class> trellisRhythmsData = [];
  List <dynamic> trellisTribeData = [];

  List <TribeDataResponse> trellisAllTribeData = [];
  List <TribeDataResponse> trellisMenteeTribeData = [];
  List <TribeDataResponse> trellisMentorTribeData = [];
  List <TribeDataResponse> trellisPeerTribeData = [];
  
  // ignore: non_constant_identifier_names
  late Trellis_principle_data_model_class trellis_principle_data_model_class;
  late TrellisLadderDataModel trellisLadderDataModel;

  String initialValueForType = "Physical";
  List itemsForType = ["Physical","Emotional","Relational","Work","Financial","Spiritual"];

  String initialValueForLadderType = "Goals";
  List itemsForLadderType = <String>["Goals", "Challenges", "Memories", "Achievements"];

  String initialValueForMType = "Memories";
  List itemsForMType = ["Memories","Achievements"];

  String initialValueForGType = "Goals";
  List itemsForGType = <String>["Goals","Challenges"];

  bool isNameExpanded = false;
  bool isPurposeExpanded = false;
  bool isLadderExpanded = false;
  bool isOPExpanded = false;
  bool isRhythmsExpanded = false;
  bool isNeedsExpanded = false;
  bool isIdentityExpanded = false;
  bool isTribeExpanded = false;

  int isLadderGoals = 2;
  int isLadderChallenges = 2;
  int isLadderMemories = 2;
  int isLadderAchievements = 2;
  int isOPLength = 2;
  int isRhythmsLength = 2;
  int isNeedsLength = 2;
  int isIdentityLength = 2;
  int isTribeLength = 1;

  bool isMentorVisible = true;
  bool isPeerVisible = false;
  bool isMenteeVisible = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TextEditingController purposeController = TextEditingController();

  TextEditingController dateForGController = TextEditingController();
  TextEditingController titleForGController = TextEditingController();
  TextEditingController descriptionForGController = TextEditingController();
  TextEditingController dateForMController = TextEditingController();
  TextEditingController titleForMController = TextEditingController();
  TextEditingController descriptionForMController = TextEditingController();

  TextEditingController empoweredTruthOPController = TextEditingController();
  TextEditingController powerlessOpController = TextEditingController();
  TextEditingController empoweredTruthRhController = TextEditingController();
  TextEditingController powerlessRhController = TextEditingController();

  TextEditingController needsController = TextEditingController();
  TextEditingController identityController = TextEditingController();

  TextEditingController mentorNameController = TextEditingController();
 // TextEditingController mentorDescriptionController = TextEditingController();
  TextEditingController peerNameController = TextEditingController();
 // TextEditingController peerDescriptionController = TextEditingController();
  TextEditingController menteeNameController = TextEditingController();
  //TextEditingController menteeDescriptionController = TextEditingController();


  String titleTrellis = "https://www.youtube.com/watch?v=GFqe2n4vnNU";
  String nameUrl = "https://www.youtube.com/watch?v=Z_9dsRt2cvQ";
  String purposeUrl = "https://www.youtube.com/watch?v=SMc9h2t-W4U";
  String ladderUrl = "https://www.youtube.com/watch?v=6g8EcajHQPY";
  String oPUrl = "https://www.youtube.com/watch?v=8yhH70QFBQ4";
  String identityUrl = "https://www.youtube.com/watch?v=iqUEdMLACs8";
  String rhythmsUrl = "https://www.youtube.com/watch?v=4_9pRALrO1k&t=3s";
  String tribeUrl = "https://www.youtube.com/watch?v=2PqaSGRZgI0";
  String needsUrl = "https://www.youtube.com/watch?v=v6wVjS_w_6Q";

  // String urlFirst = "https://www.youtube.com/watch?v=GFqe2n4vnNU";
  // String urlSecond = "https://www.youtube.com/watch?v=v6wVjS_w_6Q";
  // String urlThird = "https://www.youtube.com/watch?v=iqUEdMLACs8";
  // String urlFourth = "https://www.youtube.com/watch?v=4_9pRALrO1k";
  // String urlFifth = "https://www.youtube.com/watch?v=2PqaSGRZgI0";

  bool empoweredTruthOR = true;
  bool powerLessBelievedOR = true;

  bool empoweredTruthRhythms = true;
  bool powerLessBelievedRhythms = true;

  List<AcceptedConnectionItem> acceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> searchAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  List<AcceptedConnectionItem> selectedUserAcceptedConnectionsListResponse = <AcceptedConnectionItem>[];
  late final AnimationController _animationController;

  // bool isNameExpanded = false;
  // bool isPurposeExpanded = false;
  // bool isLadderExpanded = false;
  // bool isOPExpanded = false;
  // bool isRhythmsExpanded = false;
  // bool isNeedsExpanded = false;
  // bool isIdentityExpanded = false;
  // bool isTribeExpanded = false;



  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    // ignore: avoid_print
    print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    otherUserLoggedIn = sharedPreferences.getBool(UserConstants().otherUserLoggedIn)!;

    if(otherUserLoggedIn) {
      name = sharedPreferences.getString(UserConstants().otherUserName)!;
      id = sharedPreferences.getString(UserConstants().otherUserId)!;
    } else {
      name = sharedPreferences.getString(UserConstants().userName)!;
      id = sharedPreferences.getString(UserConstants().userId)!;
      email = sharedPreferences.getString(UserConstants().userEmail)!;
      timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
      userType = sharedPreferences.getString(UserConstants().userType)!;

      userPremium = sharedPreferences.getString(UserConstants().userPremium)!;
      userPremiumType =
      sharedPreferences.getString(UserConstants().userPremiumType)!;
      userCustomerId =
      sharedPreferences.getString(UserConstants().userCustomerId)!;
      userSubscriptionId =
      sharedPreferences.getString(UserConstants().userSubscriptionId)!;
    }

    setState(() {
      _isUserDataLoading = false;
    });
    getConnectionList();
    _getTrellisNewDataRead();
    _getTrellisReadData();
    _getPrinciplesData();
    _getIdentityData();
    _getNeedsData();
    _getTribeData();
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

      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  _getTrellisNewDataRead() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().trellisNewDataRead(LogoutRequestModel(userId: id)).then((value) {
      setState(() {
        trellisAllTribeData = value.values;
        _isLoading = false;
      });
      print("Trellis New Data Read");
      print(trellisAllTribeData);
      for(int i = 0; i<trellisAllTribeData.length; i++ ) {
        if(trellisAllTribeData[i].type == "peer") {
          trellisPeerTribeData.add(trellisAllTribeData[i]);
        } else if(trellisAllTribeData[i].type == "mentor") {
          trellisMentorTribeData.add(trellisAllTribeData[i]);
        } else {
          trellisMenteeTribeData.add(trellisAllTribeData[i]);
        }
      }

    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
      print(e.toString());
    });
  }

  _getScreenStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isNameExpanded = sharedPreferences.getBool(TrellisScreenStatus().nameExpended)!;
     }

  _getScreenStatus2() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isPurposeExpanded = sharedPreferences.getBool(TrellisScreenStatus().purposeExpended)!;
    }

  _getScreenStatus3() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isLadderExpanded = sharedPreferences.getBool(TrellisScreenStatus().ladderExpended)!;
     }

  _getScreenStatus4() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isOPExpanded = sharedPreferences.getBool(TrellisScreenStatus().oPExpended)!;
    }

  _getScreenStatus5() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isRhythmsExpanded = sharedPreferences.getBool(TrellisScreenStatus().rhythmsExpended)!;
     }

  _getScreenStatus6() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     isNeedsExpanded = sharedPreferences.getBool(TrellisScreenStatus().needsExpended)!;
     }

  _getScreenStatus7() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     isIdentityExpanded = sharedPreferences.getBool(TrellisScreenStatus().identityExpended)!;
     }

  _getScreenStatus8() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isTribeExpanded = sharedPreferences.getBool(TrellisScreenStatus().tribeExpended)!;
  }

  setScreenStatus(String key,bool value) async {
    // ignore: avoid_print
    print("Screen Status called");
// ignore: avoid_print
    print(key);
    // ignore: avoid_print
    print(value);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(key == "Name") {
      sharedPreferences.setBool(TrellisScreenStatus().nameExpended, value);
    } else if(key == "Purpose") {
      sharedPreferences.setBool(TrellisScreenStatus().purposeExpended, value);
    } else if(key == "Ladder") {
      sharedPreferences.setBool(TrellisScreenStatus().ladderExpended, value);
    } else if(key == "OP") {
      sharedPreferences.setBool(TrellisScreenStatus().oPExpended, value);
    } else if(key == "Rh") {
      sharedPreferences.setBool(TrellisScreenStatus().rhythmsExpended, value);
    } else if(key == "Needs") {
      sharedPreferences.setBool(TrellisScreenStatus().needsExpended, value);
    } else if(key == "Identity") {
      sharedPreferences.setBool(TrellisScreenStatus().identityExpended, value);
    } else if(key == "Tribe") {
      sharedPreferences.setBool(TrellisScreenStatus().tribeExpended, value);
    }

  }

  @override
  void initState() {
    _getTrellisDetails();
    _getUserData();
    _getScreenStatus();
    _getScreenStatus2();
    _getScreenStatus3();
    _getScreenStatus4();
    _getScreenStatus5();
    _getScreenStatus6();
    _getScreenStatus7();
    _getScreenStatus8();
    // TODO: implement initState
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _getTrellisDetails() {
    setState(() {
      _isLoading = true;
    });

    HTTPManager().getAppVersion().then((value)  async {
      setState(() {
         isLadderGoals = int.parse(value['goal'].toString());
         isLadderChallenges =  int.parse(value['challenges'].toString());
         isLadderMemories =  int.parse(value['memories'].toString());
         isLadderAchievements = int.parse(value['achievements'].toString());
         isOPLength = int.parse(value['principle'].toString());
         isRhythmsLength = int.parse(value['rhythms'].toString());
         isNeedsLength = int.parse(value['needs'].toString());
         isIdentityLength = int.parse(value['identity'].toString());
         isTribeLength = int.parse(value['tribe'].toString());

        _isLoading = false;
      });


    }).catchError((e) {
      // print(e);
      setState(() {
        _isLoading = false;
      });
    });
  }

  _getNeedsData() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().trellisRead(TrellisRequestModel(userId: id,table: 'ladder')).then((value) {

      TrellisLadderDataListModel trellisLadderDataListModel  = TrellisLadderDataListModel.fromJson(value['data']);
      trellisLadderDataForGoalsAchievements = trellisLadderDataListModel.values;
      print('Total Trellis Ladder Data =============> ${trellisLadderDataForGoalsAchievements.length}');
      for(int i=0; i<trellisLadderDataForGoalsAchievements.length;i++){
        print('Type ===============> $i : ${trellisLadderDataForGoalsAchievements[i].type}');
        print('Type ===============> $i : ${trellisLadderDataForGoalsAchievements[i].text}');
        print('Type ===============> $i : ${trellisLadderDataForGoalsAchievements[i].description}');
        print('Type ===============> $i : ${trellisLadderDataForGoalsAchievements[i].option1}');
        print('Type ===============> $i : ${trellisLadderDataForGoalsAchievements[i].option2}');
        if(trellisLadderDataForGoalsAchievements[i].favourite == "yes"){
          if (trellisLadderDataForGoalsAchievements[i].type.toString() == "goal") {
            trellisLadderDataForGoalsFavourites.add(trellisLadderDataForGoalsAchievements[i]);
          }else if(trellisLadderDataForGoalsAchievements[i].type.toString() == "challenges"){
            trellisLadderDataForChallengesFavourites.add(trellisLadderDataForGoalsAchievements[i]);
          }else if(trellisLadderDataForGoalsAchievements[i].type.toString() == "memories"){
            trellisLadderDataForMemoriesFavourites.add(trellisLadderDataForGoalsAchievements[i]);
          }else if(trellisLadderDataForGoalsAchievements[i].type.toString() == "achievements"){
            trellisLadderDataForAchievementsFavourites.add(trellisLadderDataForGoalsAchievements[i]);
          }

        }
      }

      print('Total Favorite Goals Data =============> ${trellisLadderDataForGoalsFavourites.length}');
      print('Total Favorite Challenges Data =============> ${trellisLadderDataForChallengesFavourites.length}');
      print('Total Favorite Memories Data =============> ${trellisLadderDataForMemoriesFavourites.length}');
      print('Total Favorite Achievements Data =============> ${trellisLadderDataForAchievementsFavourites.length}');



      // for(int i=0; i<trellisLadderDataForGoalsAchievements.length;i++) {
      //   if(trellisLadderDataForGoalsAchievements[i].favourite == "yes") {
      //     if (trellisLadderDataForGoalsAchievements[i].type.toString() ==
      //         "goal") {
      //       if(trellisLadderDataForGoalsAchievements[i].favourite!="no" ) {
      //         trellisLadderDataForGoalsFavourites.add(
      //             trellisLadderDataForGoalsAchievements[i]);
      //       }
      //       if (trellisLadderDataForGoalsAchievements[i].option2 ==
      //           "Challenges") {
      //         trellisLadderDataForGoalsChallenges.add(
      //             trellisLadderDataForGoalsAchievements[i]);
      //       } else {
      //         trellisLadderDataForGoals.add(
      //             trellisLadderDataForGoalsAchievements[i]);
      //       }
      //     } else {
      //       if(trellisLadderDataForGoalsAchievements[i].favourite!="no" ) {
      //         trellisLadderDataForAchievementsFavourites.add(
      //             trellisLadderDataForGoalsAchievements[i]);
      //       }
      //       trellisLadderDataForAchievements.add(
      //           trellisLadderDataForGoalsAchievements[i]);
      //     }
      //   }
      //
      // }
      trellisLadderDataForGoalsFavourites.sort((a,b)=>b.date!.compareTo(a.date!));
      trellisLadderDataForChallengesFavourites.sort((a,b)=>b.date!.compareTo(a.date!));
      trellisLadderDataForMemoriesFavourites.sort((a,b)=>b.date!.compareTo(a.date!));
      trellisLadderDataForAchievementsFavourites.sort((a,b)=>b.date!.compareTo(a.date!));
      trellisLadderDataForGoalsChallenges.sort((a,b)=>b.date!.compareTo(a.date!));
      trellisLadderDataForGoals.sort((a,b)=>b.date!.compareTo(a.date!));
      trellisLadderDataForAchievements.sort((a,b)=>b.date!.compareTo(a.date!));
      setState(() {
        _isLoading = false;
      });
      // ignore: avoid_print
      print("Ladder Data Load");
      // setState(() {
      //   _isLoading = false;
      // });
    }).catchError((e) {

      showToastMessage(context, e.toString(), false);
      setState(() {
        _isLoading = false;
      });
    });
  }

  _getIdentityData() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().trellisRead(TrellisRequestModel(userId: id,table: 'identity')).then((value) {

      trellisIdentityNeedsData = value['data'];
      for(int i=0; i<trellisIdentityNeedsData.length;i++) {
        if (trellisIdentityNeedsData[i]['text'] != "") {
          if (trellisIdentityNeedsData[i]['type'].toString() == "identity") {
            trellisIdentityData.add(trellisIdentityNeedsData[i]);
          } else {
            trellisNeedsData.add(trellisIdentityNeedsData[i]);
          }
        }
      }
      // ignore: avoid_print
      print("Identity Data");
      // ignore: avoid_print
      print(trellisIdentityData);
      // ignore: avoid_print
      print(trellisNeedsData);

      setState(() {
        _isLoading = false;
      });
    }).catchError((e) {
      // ignore: avoid_print
      print(e.toString());
      showToastMessage(context, e.toString(), false);
      setState(() {
        _isLoading = false;
      });
    });
  }

  _getPrinciplesData() {
    setState(() {
      _isLoading = true;
    });

    HTTPManager().trellisRead(TrellisRequestModel(userId: id,table: 'principles')).then((value) {

      TrellisResponseListModel trellisResponseListModel  = TrellisResponseListModel.fromJson(value['data']);
      trellisPrinciplesRhythmsData = trellisResponseListModel.values;
      for(int i=0; i<trellisPrinciplesRhythmsData.length;i++) {
          if (trellisPrinciplesRhythmsData[i].type.toString() == "principles") {
            trellisPrinciplesData.add(trellisPrinciplesRhythmsData[i]);
          } else {
            trellisRhythmsData.add(trellisPrinciplesRhythmsData[i]);
          }
      }

      setState(() {
        _isLoading = false;
      });

      setState(() {
        _isLoading = false;
      });
    }).catchError((e) {

      showToastMessage(context, e.toString(), false);
      setState(() {
        _isLoading = false;
      });
    });
  }

  _getTribeData() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().trellisRead(TrellisRequestModel(userId: id,table: 'tribe')).then((value) {
      trellisTribeData = value['data'];

      setState(() {
        _isLoading = false;
      });
      // ignore: avoid_print
      print(trellisTribeData);
      // ignore: avoid_print
      print(value);
      // ignore: avoid_print
      print("Trellis Tribe Data");
    }).catchError((e) {

      showToastMessage(context, e.toString(), false);
      setState(() {
        _isLoading = false;
      });
    });
  }

  _getTrellisReadData() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().trellisRead(TrellisRequestModel(userId: id,table: 'trellis')).then((value) {
      trellisData = value['data'];
      if(trellisData.isNotEmpty) {
        setState(() {
          nameController.text = trellisData[0]['name'];
          descriptionController.text = trellisData[0]['name_desc'];

          purposeController.text = trellisData[0]['purpose'];

          // mentorNameController.text = trellisData[0]['mentor'];
          // mentorDescriptionController.text = trellisData[0]['mentor_desc'];
          // peerNameController.text = trellisData[0]['peer'];
          // peerDescriptionController.text = trellisData[0]['peer_desc'];
          // menteeNameController.text = trellisData[0]['mentee'];
         // menteeDescriptionController.text = trellisData[0]['mentee_desc'];
          _isLoading = false;
        });
      }
      setState(() {
        _isLoading = false;
      });
      // ignore: avoid_print
      print(trellisData);
      // ignore: avoid_print
      print("Trellis Data");
    }).catchError((e) {

      showToastMessage(context, e.toString(), false);
      setState(() {
        _isLoading = false;
      });
    });
  }

  showDeletePopupForTribe(String type,String tribeDataId,int indexItem) {

    showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            title:const Text('Confirm delete?'),
            content:const SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text("Are you sure you want to delete!"),
            ),
            actions: [
              // ignore: deprecated_member_use
              TextButton(
                child:const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              // ignore: deprecated_member_use
              TextButton(
                child:const Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteNewTribe(type,tribeDataId,indexItem);
                  // Invoke the update now callback
                  // onUpdateNowPressed(deviceType);
                },
              ),
            ],
          );
        });
  }

  showDeletePopup(String type,String recordId,int index1,String goalsOrChallenges) {

    showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            title:const Text('Confirm delete?'),
            content:const SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text("Are you sure you want to delete!"),
            ),
            actions: [
              // ignore: deprecated_member_use
              TextButton(
                child:const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              // ignore: deprecated_member_use
              TextButton(
                child:const Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteRecord(type, recordId, index1,goalsOrChallenges);
                  // Invoke the update now callback
                  // onUpdateNowPressed(deviceType);
                },
              ),
            ],
          );
        });
  }

  Future<bool> _onWillPop() async {
    // if(nameController.text.isNotEmpty || descriptionController.text.isNotEmpty || purposeController.text.isNotEmpty || mentorNameController.text.isNotEmpty || mentorDescriptionController.text.isNotEmpty || peerNameController.text.isNotEmpty || peerDescriptionController.text.isNotEmpty || menteeNameController.text.isNotEmpty || menteeDescriptionController.text.isNotEmpty) {
    //   _setTrellisData();
    // }

    Navigator.of(context).pop();

    return true;
  }

  getScreenDetails() {
    // setState(() {
    //   _isLoading = true;
    // });
    if(MediaQuery.of(context).size.width<= 600) {
      isPhone = true;
    } else {
      isPhone = false;
    }
    // setState(() {
    //   _isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _isLoading ? const Center(child: CircularProgressIndicator(),)  : Stack(
            alignment: Alignment.center,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: !isPhone ? MediaQuery.of(context).size.width/4 : 10 ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LogoScreen("Trellis"),
                          const SizedBox(width: 20,),
                          IconButton(onPressed: (){
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
                              playerController.loadVideo(titleTrellis);
                              playerController.stopVideo();
                            };
                            // String? videoId = YoutubePlayer.convertUrlToId(titleTrellis);
                            // YoutubePlayerController playerController = YoutubePlayerController(
                            //     initialVideoId: videoId!,
                            //     flags: const YoutubePlayerFlags(
                            //       autoPlay: false,
                            //       controlsVisibleAtStart: false,
                            //     )

                            // );
                            videoPopupDialog(context,"Introduction to Trellis",playerController);
                            //bottomSheet(context,"Trellis","Welcome to Trellis, the part of the Brugeon app designed to help you flourish and live life intentionally. Trellis is a light structure that provides structure and focus, and helps propel you towards your desired outcomes. Invest at least five minutes a day in reviewing and meditating on your Trellis. If you don't have any answers yet, spend your time meditating, praying, or journaling on the questions/sections. If you have partial answers, keep taking your time daily to consider the questions and your answers. By consistently returning to your Trellis, you will become more clear and focused on creating the outcomes you desire. Enjoy your Trellis!","");
                          }, icon: const Icon(Icons.ondemand_video,size:30,color: AppColors.infoIconColor,))
                        ],
                      ),

                      const SizedBox(height: 5,),

                      ExpansionTileWidgetScreen(isNameExpanded,"Name",isNameExpanded,descriptionController.text,nameController.text,true,(bool value) {
                        // ignore: avoid_print
                        print(value);
                        setScreenStatus("Name",value);
                        setState(() {
                          isNameExpanded = value;
                        });
                          },() {
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
                          playerController0.loadVideo(nameUrl);
                          playerController0.stopVideo();
                        };
                        // String? videoId = YoutubePlayer.convertUrlToId(nameUrl);
                        // YoutubePlayerController playerController1 = YoutubePlayerController(
                        //     initialVideoId: videoId!,
                        //     flags: const YoutubePlayerFlags(
                        //       autoPlay: false,
                        //       controlsVisibleAtStart: false,
                        //     )
                        //
                        // );
                        videoPopupDialog(context,"Introduction to name",playerController0);
                       // bottomSheet(context,"Name","Names have meaning and power. Try searching the meanings of the names of the five closest people to you. You'll likely find that they live up to their meaning. Fill in your first and middle name in the name section, and write the meaning in the description. Your name can give clues about who you are and who you're meant to be.","");
                      },
                          <Widget>[
                            Container(
                              decoration:const BoxDecoration(
                                color: AppColors.lightGreyColor,
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                              ),
                              padding:const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  Container(
                                      margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                      child: Focus(
                                        // onFocusChange: (hasFocus) {
                                        //   print('Name Field:  $hasFocus');
                                        //   if(!hasFocus && nameController.text.isNotEmpty) {
                                        //     _setTrellisData ();
                                        //   }
                                        //   },
                                          child: NameField(nameController,"Name",1,70,false,otherUserLoggedIn))),
                                  Container(
                                      margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                      child: Focus(
                                        // onFocusChange: (hasFocus) {
                                        //   print('Description Field:  $hasFocus');
                                        //   if(!hasFocus && descriptionController.text.isNotEmpty) {
                                        //     _setTrellisData ();
                                        //   }
                                        // },
                                          child: NameField(descriptionController,"Description",1,70,false,otherUserLoggedIn))),
                                  if(!otherUserLoggedIn)
                                  SaveButtonWidgets( (){
                                    _setTrellisData(true);
                                  }),
                                ],
                              ),
                            )
                          ]
                      ),

                      ExpansionTileWidgetScreen(isPurposeExpanded,"Purpose",isPurposeExpanded,purposeController.text,"",true,(bool value) {
                        // ignore: avoid_print
                        print(value);
                        setScreenStatus("Purpose",value);
                        setState(() {
                          isPurposeExpanded = value;
                        });
                      },() {

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
                          playerController0.loadVideo(purposeUrl);
                          playerController0.stopVideo();
                        };

                        // String? videoId = YoutubePlayer.convertUrlToId(purposeUrl);
                        // YoutubePlayerController playerController2 = YoutubePlayerController(
                        //     initialVideoId: videoId!,
                        //     flags: const YoutubePlayerFlags(
                        //       autoPlay: false,
                        //       controlsVisibleAtStart: false,
                        //     )
                        //
                        // );
                        videoPopupDialog(context,"Introduction to purpose",playerController0);
                       // bottomSheet(context,"Purpose","Define your purpose and keep it in focus daily for success. In the Purpose section, write a sentence about your life purpose. Review and tweak it daily until it feels right. Use exercises to help uncover your purpose. If unsure, write the first thing that comes to mind. Imagine your headstone for inspiration. Enjoy living out your purpose!","");
                      },
                          <Widget>[
                            Container(
                              decoration:const BoxDecoration(
                                color: AppColors.lightGreyColor,
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                              ),
                              padding:const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  Container(
                                      margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                      child: Focus(
                                        // onFocusChange: (hasFocus) {
                                        //   print('Purpose Field:  $hasFocus');
                                        //   if(!hasFocus && purposeController.text.isNotEmpty) {
                                        //     _setTrellisData ();
                                        //   }
                                        // },
                                          child: NameField(purposeController,"Purpose",4,100,false,otherUserLoggedIn))),
                                  if(!otherUserLoggedIn)
                                  SaveButtonWidgets( (){
                                    _setTrellisData(false);
                                  }),
                                ],
                              ),
                            )

                          ]
                      ),

                      ExpansionTileWidgetScreen(isLadderExpanded,"Ladder Highlights",isLadderExpanded,"Goals/challenges,Memories/Achievements","",false,(bool value) {
                        // ignore: avoid_print
                        print(value);
                        setScreenStatus("Ladder",value);

                        setState(() {
                          isLadderExpanded = value;
                        });
                      },() {

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
                          playerController0.loadVideo(ladderUrl);
                          playerController0.stopVideo();
                        };

                        // String? videoId = YoutubePlayer.convertUrlToId(ladderUrl);
                        // YoutubePlayerController playerController3 = YoutubePlayerController(
                        //     initialVideoId: videoId!,
                        //     flags: const YoutubePlayerFlags(
                        //       autoPlay: false,
                        //       controlsVisibleAtStart: false,
                        //     )
                        //
                        // );
                        videoPopupDialog(context,"Introduction to Ladder",playerController0);
                       // bottomSheet(context,"Ladder","Use the Ladder exercise to take a historical view of your life. Divide events into past (Memories & Achievements) and future (Goals & Challenges). See patterns and direction in one linear path.","");
                      },
                          <Widget>[

                            Container(
                              decoration:const BoxDecoration(
                                color: AppColors.lightGreyColor,
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                              ),
                              padding:const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  if(!otherUserLoggedIn)
                                  Align(alignment: Alignment.topRight,
                                    child: AddButton(userPremium == "no" ? trellisLadderDataForAchievements.length>=isLadderAchievements : false,
                                            () async {
                                          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                          sharedPreferences.setBool("IsGoals", true);
                                          print(userPremium);

                                          setState(() {
                                            initialValueForLadderType = "Goals";
                                            initialValueForType = "Physical";
                                            initialValueForMType = "Memories";
                                            initialValueForGType = "Goals";
                                            titleForGController.clear();
                                            descriptionForGController.clear();
                                            dateForGController.clear();
                                            dateForGController.text = "";
                                            descriptionForGController.text = "";
                                            titleForGController.text = "";
                                          });
                                          ladderBottomSheet(false,context,true,true,"Ladder",
                                              initialValueForType,itemsForType,
                                              initialValueForLadderType, itemsForLadderType,
                                              initialValueForMType, itemsForMType,
                                              initialValueForGType, itemsForGType,
                                                  () async {
                                                print('Ladder Type ===========> $initialValueForLadderType' );
                                                print('Type ===========> $initialValueForType' );
                                                if(userPremium == "no" && trellisLadderDataForGoalsFavourites.length >= isLadderGoals && trellisLadderDataForChallengesFavourites.length >= isLadderChallenges && trellisLadderDataForMemoriesFavourites.length >= isLadderMemories  && trellisLadderDataForAchievementsFavourites.length >= isLadderAchievements){
                                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                                                }else{
                                                  if(initialValueForLadderType != "Challenges"){
                                                    if(dateForGController.text.isEmpty) {
                                                      showToastMessage(context, "Please select a date", false);
                                                      return;
                                                    }
                                                  }

                                                  if(initialValueForLadderType == "Goals" || initialValueForLadderType == "Challenges"){
                                                    print('Initial Value For Ladder Type is Goals or Challenges ========> ');
                                                    print(initialValueForLadderType);
                                                    print(initialValueForType);
                                                    _setLadderGoalsData();

                                                  }else if(initialValueForLadderType == "Memories" || initialValueForLadderType == "Achievements"){
                                                    print('Initial Value For Ladder Type is Memories or Achievements ========> ');
                                                    initialValueForType = "";
                                                    print(initialValueForLadderType);
                                                    print(initialValueForType);
                                                    _setLadderMemoriesData();
                                                  }



                                                }




                                                // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                                // bool isGoalsValue = sharedPreferences.getBool("IsGoals")!;
                                                // if(isGoalsValue) {
                                                //   String ladderType = sharedPreferences.getString('ladderType') ?? 'goal';
                                                //   if(userPremium == "no" && trellisLadderDataForGoals.length>=isLadderGoals) {
                                                //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                                                //   } else {
                                                //     print("Goals Saving");
                                                //     if(initialValueForType == "Memories" || initialValueForType == "Achievements")
                                                //     {
                                                //       setState(() {
                                                //         initialValueForType = "physical";
                                                //       });
                                                //     }
                                                //     if(initialValueForGoals == "Challenges") {
                                                //
                                                //       _setLadderGoalsData(ladderType);
                                                //     } else {
                                                //         if(dateForGController.text.isNotEmpty) {
                                                //           _setLadderGoalsData(ladderType);
                                                //         } else {
                                                //           showToastMessage(context, "Please select a date", false);
                                                //         }
                                                //     }
                                                //
                                                //   }
                                                // } else {
                                                //   String ladderType = sharedPreferences.getString('ladderType') ?? 'achievements';
                                                //   if(userPremium == "no" && trellisLadderDataForAchievements.length>=isLadderAchievements) {
                                                //         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                                                //       } else {
                                                //     print("Memories saving");
                                                //     if(initialValueForType == "physical" || initialValueForType == "Emotional" || initialValueForType =="Relational" || initialValueForType =="Work" || initialValueForType =="Financial" || initialValueForType =="Spiritual")
                                                //       {
                                                //         setState(() {
                                                //           initialValueForType = "Memories";
                                                //         });
                                                //       }
                                                //     _setLadderMemoriesData(ladderType);
                                                //   }
                                                // }
                                              },
                                                  (value) {
                                                print(value);
                                                setState(() {
                                                  initialValueForLadderType = value;
                                                });
                                              },
                                                  (value) {
                                                print(value);
                                                setState(() {
                                                  initialValueForType = value;
                                                });
                                              },
                                              dateForGController,
                                              titleForGController,
                                              descriptionForGController
                                          );
                                        }
                                    ),
                                  ),
                                  Container(
                                    margin:const EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Row(
                                          children: [
                                            const Text("Goals",style: TextStyle(
                                                fontSize: AppConstants.defaultFontSize,
                                                color: AppColors.primaryColor
                                            ),),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            IconButton(
                                                onPressed: (){
                                                  bottomSheet(context,"Goals","Healthy goals lead to greater flourishing. Use S.M.A.R.T goals (Specific, Measurable, Attainable, Relevant, Timely) to ensure clarity and confirm accomplishment. Benchmarks are smaller goals. Remember the six major life areas when setting goals.","");
                                                },
                                                icon:const Icon(Icons.info_outline,size:20,color: AppColors.infoIconColor,)),
                                          ],
                                        ),

                                        // AddButton( userPremium == "no" ? trellisLadderDataForGoals.length>= isLadderGoals :false,(){
                                        //
                                        //   ladderBottomSheet(context,true,"Ladder","Goals/Challenges",
                                        //       initialValueForType,itemsForType,
                                        //       initialValueForGoals,itemsForGoals,
                                        //           (){_setLadderGoalsData();},
                                        //           (value) {
                                        //               setState(() {
                                        //                 initialValueForGoals = value;
                                        //               });
                                        //           },
                                        //           (value) {
                                        //             setState(() {
                                        //               initialValueForType = value;
                                        //             });
                                        //           },
                                        //       dateForGController,
                                        //       titleForGController,
                                        //       descriptionForGController
                                        //   //     <Widget>[
                                        //   //   DropDownField(initialValueForType, itemsForType.map((item) {
                                        //   //     return  DropdownMenuItem(
                                        //   //       value: item.toString(),
                                        //   //       child: Text(item.toString()),
                                        //   //     );
                                        //   //   }).toList(), (value) {
                                        //   //     setState(() {
                                        //   //       initialValueForType = value;
                                        //   //     });
                                        //   //   }),
                                        //   //
                                        //   //   DropDownField(initialValueForGoals, itemsForGoals.map((item) {
                                        //   //     return  DropdownMenuItem(
                                        //   //       value: item.toString(),
                                        //   //       child: Text(item.toString()),
                                        //   //     );
                                        //   //   }).toList(), (value) {
                                        //   //     setState(() {
                                        //   //       initialValueForGoals = value;
                                        //   //     });
                                        //   //   }),
                                        //   //
                                        //   //   Visibility(
                                        //   //       visible: initialValueForGoals != "Challenges",
                                        //   //       child: DatePickerField(dateForGController,"Select date",true)),
                                        //   //
                                        //   //   Container(
                                        //   //       margin:const EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                                        //   //       child: NameField(titleForGController,"title",1,70,true)),
                                        //   //   Container(
                                        //   //       margin:const EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                                        //   //       child: NameField(descriptionForGController,"description",4,70,true)),
                                        //   //   SaveButtonWidgets( (){
                                        //   //     _setLadderGoalsData();
                                        //   //   }),
                                        //   // ]
                                        //   );
                                        //
                                        // } ),

                                      ],
                                    ),
                                  ),

                                  trellisLadderDataForGoalsFavourites.isEmpty ? const Text("") : Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: trellisLadderDataForGoalsFavourites.length >= 3 ? 3 : trellisLadderDataForGoalsFavourites.length ,
                                        itemBuilder:(context,index) {
                                          return GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) => _buildPopupDialog(context,"Goals",trellisLadderDataForGoalsFavourites[index],false),
                                              );
                                            },
                                            child: Container(
                                                margin:const EdgeInsets.symmetric(vertical: 5),
                                                decoration: BoxDecoration(
                                                    color: AppColors.backgroundColor,
                                                    borderRadius: BorderRadius.circular(10)
                                                ),
                                                padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text("${trellisLadderDataForGoalsFavourites[index].option1} | ${trellisLadderDataForGoalsFavourites[index].option2}",style:const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
                                                        if(!otherUserLoggedIn)
                                                        Row(
                                                          children: [
                                                            trellisLadderDataForGoalsFavourites[index].favourite != 'no' ? Image.asset( "assets/like_full.png") : Image.asset( "assets/like_empty.png"),
                                                            IconButton(onPressed: () {
                                                              showDeletePopup( "goal",trellisLadderDataForGoalsFavourites[index].id.toString(),index,trellisLadderDataForGoalsFavourites[index].option2.toString());
                                                            }, icon: const Icon(Icons.delete,color: AppColors.redColor,),),
                                                          ],
                                                        )

                                                      ],
                                                    ),
                                                    // Align(alignment: Alignment.topRight,
                                                    //   child: IconButton(
                                                    //     onPressed: () {},
                                                    //     icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                                    //   ),),
                                                    Align(
                                                        alignment: Alignment.topLeft,
                                                        child:  Text("${trellisLadderDataForGoalsFavourites[index].option2 == "Challenges" ? "" :DateFormat('MM-dd-yy').format(DateTime.parse(trellisLadderDataForGoalsFavourites[index].date.toString()))} ${trellisLadderDataForGoalsFavourites[index].option2 == "Challenges" ? "" :"|"} ${trellisLadderDataForGoalsFavourites[index].text} | ${trellisLadderDataForGoalsFavourites[index].description}"))
                                                  ],
                                                )),
                                          );
                                        }
                                    ),
                                  ),
                                  //  const Divider(),
                                  //   trellisLadderDataForGoalsFavourites.isEmpty ? const Text("") : Container(
                                  //     margin: const EdgeInsets.symmetric(horizontal: 10),
                                  //     child: ListView.builder(
                                  //         shrinkWrap: true,
                                  //         physics: const NeverScrollableScrollPhysics(),
                                  //         itemCount: trellisLadderDataForGoalsFavourites.length >= 3 ? 3 : trellisLadderDataForGoalsFavourites.length ,
                                  //         itemBuilder:(context,index) {
                                  //           return GestureDetector(
                                  //             onTap: () {
                                  //               showDialog(
                                  //                 context: context,
                                  //                 builder: (BuildContext context) => _buildPopupDialog(context,"Goals/Challenges",trellisLadderDataForGoalsChallenges[index],false),
                                  //               );
                                  //             },
                                  //             child: Container(
                                  //                 margin:const EdgeInsets.symmetric(vertical: 5),
                                  //                 decoration: BoxDecoration(
                                  //                     color: AppColors.backgroundColor,
                                  //                     borderRadius: BorderRadius.circular(10)
                                  //                 ),
                                  //                 padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                  //                 child: Column(
                                  //                   children: [
                                  //                     Row(
                                  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //                       children: [
                                  //                         Text("${trellisLadderDataForGoalsChallenges[index].option1} | ${trellisLadderDataForGoalsChallenges[index].option2}",style:const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
                                  //
                                  //                         Row(
                                  //                           children: [
                                  //                             trellisLadderDataForGoalsChallenges[index].favourite != 'no' ? Image.asset( "assets/like_full.png") : Image.asset( "assets/like_empty.png"),
                                  //                             IconButton(onPressed: () {
                                  //                               // _deleteRecord("goal", trellisLadderDataForGoalsChallenges[index].id.toString(),index,trellisLadderDataForGoalsChallenges[index].option2.toString());
                                  //                               showDeletePopup("goal", trellisLadderDataForGoalsChallenges[index].id.toString(),index,trellisLadderDataForGoalsChallenges[index].option2.toString());
                                  //                             }, icon: const Icon(Icons.delete,color: AppColors.redColor,),),
                                  //                           ],
                                  //                         )
                                  //
                                  //
                                  //                       ],
                                  //                     ),
                                  //                     // Align(alignment: Alignment.topRight,
                                  //                     //   child: IconButton(
                                  //                     //     onPressed: () {},
                                  //                     //     icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                  //                     //   ),),
                                  //                     Align(
                                  //                         alignment: Alignment.topLeft,
                                  //                         child:  Text(" ${trellisLadderDataForGoalsChallenges[index].text} "))
                                  //                   ],
                                  //                 )),
                                  //           );
                                  //         }
                                  //     ),
                                  //   ),

                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10,),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Text("Challenges",style: TextStyle(
                                                fontSize: AppConstants.defaultFontSize,
                                                color: AppColors.primaryColor
                                            ),),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            IconButton(
                                                onPressed: (){
                                                  bottomSheet(context,"Challenges","Challenges are obstacles or difficulties that arise while striving to achieve goals. They test one's resilience, problem-solving abilities, and determination. ","");
                                                },
                                                icon:const Icon(Icons.info_outline,size:20,color: AppColors.infoIconColor,)),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),

                                  trellisLadderDataForChallengesFavourites.isEmpty ?const Text("") : Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: trellisLadderDataForChallengesFavourites.length >= 3 ? 3 : trellisLadderDataForChallengesFavourites.length,
                                        itemBuilder:(context,index) {
                                          return GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) => _buildPopupDialog(context,"Challenges",trellisLadderDataForChallengesFavourites[index],true),
                                              );
                                            },
                                            child: Container(
                                                margin:const EdgeInsets.symmetric(vertical: 5),
                                                decoration: BoxDecoration(
                                                    color: AppColors.backgroundColor,
                                                    borderRadius: BorderRadius.circular(10)
                                                ),
                                                padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text("${trellisLadderDataForChallengesFavourites[index].option1} | ${trellisLadderDataForChallengesFavourites[index].option2}",style:const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),

                                                        if(!otherUserLoggedIn)
                                                          Row(
                                                            children: [
                                                              trellisLadderDataForChallengesFavourites[index].favourite != 'no' ? Image.asset( "assets/like_full.png") : Image.asset( "assets/like_empty.png"),
                                                              IconButton(onPressed: () {
                                                                showDeletePopup( "challenges",trellisLadderDataForChallengesFavourites[index].id.toString(),index,"");
                                                              }, icon: const Icon(Icons.delete,color: AppColors.redColor,),),
                                                            ],
                                                          )
                                                      ],
                                                    ),
                                                    Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Text("${trellisLadderDataForChallengesFavourites[index].text}"))
                                                  ],
                                                )),
                                          );
                                        }
                                    ),
                                  ),

                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10,),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Text("Memories",style: TextStyle(
                                                fontSize: AppConstants.defaultFontSize,
                                                color: AppColors.primaryColor
                                            ),),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            IconButton(
                                                onPressed: (){
                                                  bottomSheet(context,"Memories","Memories are recollections of past experiences, whether joyful, sorrowful, or mundane. They shape our identity and influence our future actions and decisions.","");
                                                },
                                                icon:const Icon(Icons.info_outline,size:20,color: AppColors.infoIconColor,)),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),

                                  trellisLadderDataForMemoriesFavourites.isEmpty ?const Text("") : Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: trellisLadderDataForMemoriesFavourites.length >= 3 ? 3 : trellisLadderDataForMemoriesFavourites.length,
                                        itemBuilder:(context,index) {
                                          return GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) => _buildPopupDialog(context,"Memories",trellisLadderDataForMemoriesFavourites[index],true),
                                              );
                                            },
                                            child: Container(
                                                margin:const EdgeInsets.symmetric(vertical: 5),
                                                decoration: BoxDecoration(
                                                    color: AppColors.backgroundColor,
                                                    borderRadius: BorderRadius.circular(10)
                                                ),
                                                padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text("${trellisLadderDataForMemoriesFavourites[index].option2}",style:const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),

                                                        if(!otherUserLoggedIn)
                                                          Row(
                                                            children: [
                                                              trellisLadderDataForMemoriesFavourites[index].favourite != 'no' ? Image.asset( "assets/like_full.png") : Image.asset( "assets/like_empty.png"),
                                                              IconButton(onPressed: () {
                                                                showDeletePopup( "memories",trellisLadderDataForMemoriesFavourites[index].id.toString(),index,"");
                                                              }, icon: const Icon(Icons.delete,color: AppColors.redColor,),),
                                                            ],
                                                          )
                                                      ],
                                                    ),
                                                    Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Text("${DateFormat('MM-dd-yy').format(DateTime.parse(trellisLadderDataForMemoriesFavourites[index].date.toString()))} | ${trellisLadderDataForMemoriesFavourites[index].text}"))
                                                  ],
                                                )),
                                          );
                                        }
                                    ),
                                  ),


                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10,),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Text("Achievements",style: TextStyle(
                                                fontSize: AppConstants.defaultFontSize,
                                                color: AppColors.primaryColor
                                            ),),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            IconButton(
                                                onPressed: (){
                                                  bottomSheet(context,"Achievements","Achievements are milestones or successes reached as a result of effort, skill, and perseverance. They represent the fulfillment of goals and are often celebrated as significant accomplishments.","");
                                                },
                                                icon:const Icon(Icons.info_outline,size:20,color: AppColors.infoIconColor,)),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),

                                  trellisLadderDataForAchievementsFavourites.isEmpty ?const Text("") : Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: trellisLadderDataForAchievementsFavourites.length >= 3 ? 3 : trellisLadderDataForAchievementsFavourites.length,
                                        itemBuilder:(context,index) {
                                          return GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) => _buildPopupDialog(context,"Achievements",trellisLadderDataForAchievementsFavourites[index],true),
                                              );
                                            },
                                            child: Container(
                                                margin:const EdgeInsets.symmetric(vertical: 5),
                                                decoration: BoxDecoration(
                                                    color: AppColors.backgroundColor,
                                                    borderRadius: BorderRadius.circular(10)
                                                ),
                                                padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text("${trellisLadderDataForAchievementsFavourites[index].option2}",style:const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),

                                                        if(!otherUserLoggedIn)
                                                          Row(
                                                            children: [
                                                              trellisLadderDataForAchievementsFavourites[index].favourite != 'no' ? Image.asset( "assets/like_full.png") : Image.asset( "assets/like_empty.png"),
                                                              IconButton(onPressed: () {
                                                                showDeletePopup( "achievements",trellisLadderDataForAchievementsFavourites[index].id.toString(),index,"");
                                                              }, icon: const Icon(Icons.delete,color: AppColors.redColor,),),
                                                            ],
                                                          )
                                                      ],
                                                    ),
                                                    Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Text("${DateFormat('MM-dd-yy').format(DateTime.parse(trellisLadderDataForAchievementsFavourites[index].date.toString()))} | ${trellisLadderDataForAchievementsFavourites[index].text}"))
                                                  ],
                                                )),
                                          );
                                        }
                                    ),
                                  ),
                                ],
                              ),
                            )

                          ]
                      ),

                      ExpansionTileWidgetScreen(isOPExpanded,"Organizing Principles",isOPExpanded,"Empowered truths,Powerless beliefs","",false,(bool value) {
                        // ignore: avoid_print
                        print(value);
                        setScreenStatus("OP",value);

                        setState(() {
                          isOPExpanded = value;
                        });
                      },() {

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
                          playerController0.loadVideo(oPUrl);
                          playerController0.stopVideo();
                        };

                        // String? videoId = YoutubePlayer.convertUrlToId(oPUrl);
                        // YoutubePlayerController playerController4 = YoutubePlayerController(
                        //     initialVideoId: videoId!,
                        //     flags: const YoutubePlayerFlags(
                        //       autoPlay: false,
                        //       controlsVisibleAtStart: false,
                        //     )
                        //
                        // );
                        videoPopupDialog(context,"Introduction to Organizing Principle",playerController0);
                       // bottomSheet(context,"Organizing Principles","Two organizing principles shape us: Powerless Beliefs and Empowered Truths. Powerless Beliefs are negative, unconsciously formed around fear or shame in our formative years, such as I don't have what it takes. Empowered Truths are core, empowering principles to organize our lives around, such as There is goodness in me, for me, and through me. Shade out powerless beliefs.","");
                      },
                          <Widget>[
                            if(!otherUserLoggedIn)
                            AddButton(userPremium == "no" ? trellisPrinciplesData.length>=isOPLength : false,() {
                              needsBottomSheet(context, "Organizing Principles", <Widget>[
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            margin:const EdgeInsets.only(left: 10,right: 10),
                                            child: Row(
                                              children: [
                                                Image.asset("assets/arm.png"),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                const  Text("Empowered truths",style: TextStyle(color: AppColors.primaryColor),)
                                              ],
                                            )),
                                        // InkWell(
                                        //   onTap: () {
                                        //     setState(() {
                                        //       empoweredTruthOR = !empoweredTruthOR;
                                        //     });
                                        //   },
                                        //   child: Container(
                                        //       margin:const EdgeInsets.only(left: 10,right: 10),
                                        //       child: Row(
                                        //         children: [
                                        //           Image.asset(empoweredTruthOR ? "assets/close_eye.png" : "assets/open_eye.png"),
                                        //           const SizedBox(
                                        //             width: 5,
                                        //           ),
                                        //         //  Text(empoweredTruthOR ? "Hide" : "Show",style: const TextStyle(color: AppColors.primaryColor),)
                                        //         ],
                                        //       )
                                        //   ),
                                        // )

                                      ],
                                    ),

                                    Container(
                                        margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                        child: Visibility(
                                            visible: empoweredTruthOR,
                                            child: Focus(
                                              // onFocusChange: (hasFocus) {
                                              //   print('empowered truths OP:  $hasFocus');
                                              //   if(!hasFocus && empoweredTruthOPController.text.isNotEmpty) {
                                              //     _setTrellisData ();
                                              //    }
                                              //   },
                                                child: NameField(empoweredTruthOPController,"empowered truth",1,70,true,otherUserLoggedIn)))),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Container(
                                            margin:const EdgeInsets.only(left: 10,right: 10),
                                            child: Row(

                                              children: [
                                                Image.asset("assets/emoji.png"),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                const  Text("Powerless Belief",style: TextStyle(color: AppColors.primaryColor),)
                                              ],
                                            )),
                                        // InkWell(
                                        //   onTap: () {
                                        //     setState(() {
                                        //       powerLessBelievedOR = !powerLessBelievedOR;
                                        //     });
                                        //   },
                                        //   child: Container(
                                        //       margin:const EdgeInsets.only(left: 10,right: 10),
                                        //       child: Row(
                                        //         children: [
                                        //           Image.asset(powerLessBelievedOR ? "assets/close_eye.png" : "assets/open_eye.png"),
                                        //           const SizedBox(
                                        //             width: 5,
                                        //           ),
                                        //           Text(powerLessBelievedOR ? "Hide" : "Show",style: const TextStyle(color: AppColors.primaryColor),)
                                        //         ],
                                        //       )
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    Container(
                                        margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                        child: Visibility(
                                            visible: powerLessBelievedOR,
                                            child: Focus(
                                              // onFocusChange: (hasFocus) {
                                              //   print('PowerLess believes OP Field:  $hasFocus');
                                              //   if(!hasFocus && powerlessOpController.text.isNotEmpty) {
                                              //     _setTrellisData ();
                                              //   }
                                              // },
                                                child: NameField(powerlessOpController,"powerless Belief",1,70,true,otherUserLoggedIn)))),
                                    if(!otherUserLoggedIn)
                                    SaveButtonWidgets( (){
                                      _setTrellisOPData();
                                    }),
                                  ],
                                ),
                              ]);
                            }),

                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              child: trellisPrinciplesData.isEmpty ? const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("")) : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: trellisPrinciplesData.length,
                                  itemBuilder:(context,index) {
                                    return InkWell(
                                      // onTap: () {
                                      //   showDialog(
                                      //     context: context,
                                      //     builder: (BuildContext context) => _buildPopupDialog(context,"Memories/Achievements"),
                                      //   );
                                      // },
                                      child: Container(
                                          margin:const EdgeInsets.symmetric(vertical: 5),
                                          decoration: BoxDecoration(
                                              color: AppColors.backgroundColor,
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          margin:const EdgeInsets.only(left: 10,right: 10),
                                                          alignment: Alignment.centerLeft,
                                                          child: Row(
                                                            children: [
                                                              Image.asset("assets/arm.png"),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              const  Text("Empowered truths",style: TextStyle(color: AppColors.primaryColor),)
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                  if(!otherUserLoggedIn)
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              powerlessOpController.text = trellisPrinciplesData[index].powerlessBelieves! ;
                                                              empoweredTruthOPController.text = trellisPrinciplesData[index].empTruths!;
                                                            });
                                                            needsBottomSheet(context, "Organizing Principles", <Widget>[
                                                              Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Container(
                                                                          margin:const EdgeInsets.only(left: 10,right: 10),
                                                                          child: Row(
                                                                            children: [
                                                                              Image.asset("assets/arm.png"),
                                                                              const SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              const  Text("Empowered truths",style: TextStyle(color: AppColors.primaryColor),)
                                                                            ],
                                                                          )),
                                                                      // GestureDetector(
                                                                      //   onTap: () {
                                                                      //     setState(() {
                                                                      //       empoweredTruthOR = !empoweredTruthOR;
                                                                      //     });
                                                                      //   },
                                                                      //   child: Container(
                                                                      //       margin:const EdgeInsets.only(left: 10,right: 10),
                                                                      //       child: Row(
                                                                      //         children: [
                                                                      //           Image.asset(empoweredTruthOR ? "assets/close_eye.png" : "assets/open_eye.png"),
                                                                      //           const SizedBox(
                                                                      //             width: 5,
                                                                      //           ),
                                                                      //         //  Text(empoweredTruthOR ? "Hide" : "Show",style: const TextStyle(color: AppColors.primaryColor),)
                                                                      //         ],
                                                                      //       )
                                                                      //   ),
                                                                      // )

                                                                    ],
                                                                  ),

                                                                  Container(
                                                                      margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                                                      child: Visibility(
                                                                          visible: empoweredTruthOR,
                                                                          child: Focus(
                                                                            // onFocusChange: (hasFocus) {
                                                                            //   print('empowered truths OP:  $hasFocus');
                                                                            //   if(!hasFocus && empoweredTruthOPController.text.isNotEmpty) {
                                                                            //     _setTrellisData ();
                                                                            //    }
                                                                            //   },
                                                                              child: NameField(empoweredTruthOPController,"empowered truth",1,70,true,otherUserLoggedIn)))),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [

                                                                      Container(
                                                                          margin:const EdgeInsets.only(left: 10,right: 10),
                                                                          child: Row(

                                                                            children: [
                                                                              Image.asset("assets/emoji.png"),
                                                                              const SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              const  Text("Powerless Belief",style: TextStyle(color: AppColors.primaryColor),)
                                                                            ],
                                                                          )),
                                                                      // GestureDetector(
                                                                      //   onTap: () {
                                                                      //     setState(() {
                                                                      //       powerLessBelievedOR = !powerLessBelievedOR;
                                                                      //     });
                                                                      //   },
                                                                      //   child: Container(
                                                                      //       margin:const EdgeInsets.only(left: 10,right: 10),
                                                                      //       child: Row(
                                                                      //         children: [
                                                                      //           Image.asset(powerLessBelievedOR ? "assets/close_eye.png" : "assets/open_eye.png"),
                                                                      //           const SizedBox(
                                                                      //             width: 5,
                                                                      //           ),
                                                                      //           Text(powerLessBelievedOR ? "Hide" : "Show",style: const TextStyle(color: AppColors.primaryColor),)
                                                                      //         ],
                                                                      //       )
                                                                      //   ),
                                                                      // ),
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                      margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                                                      child: Visibility(
                                                                          visible: powerLessBelievedOR,
                                                                          child: Focus(
                                                                            // onFocusChange: (hasFocus) {
                                                                            //   print('PowerLess believes OP Field:  $hasFocus');
                                                                            //   if(!hasFocus && powerlessOpController.text.isNotEmpty) {
                                                                            //     _setTrellisData ();
                                                                            //   }
                                                                            // },
                                                                              child: NameField(powerlessOpController,"powerless Belief",1,70,true,otherUserLoggedIn)))),
                                                                  SaveButtonWidgets( (){
                                                                    _updateTrellisOPData(index,trellisPrinciplesData[index].id!);
                                                                  }),
                                                                ],
                                                              ),
                                                            ]);
                                                          }, icon: const Icon(Icons.edit,color: AppColors.primaryColor,)),
                                                      IconButton(
                                                        onPressed: () {
                                                          _deleteRecord("principles", trellisPrinciplesData[index].id.toString(),index,"");
                                                        },
                                                        icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              // Align(alignment: Alignment.topRight,
                                              //   child: ,),
                                              Container(
                                                margin: const EdgeInsets.only(bottom: 10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [

                                                    Padding(
                                                      padding:const EdgeInsets.only(left:10,right:10,bottom: 10),
                                                        child: Text(trellisPrinciplesData[index].empTruths.toString()),
                                                    ),
                                                    const SizedBox(height: 5,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                            margin:const EdgeInsets.only(left: 10,right: 10),
                                                            child: Row(

                                                              children: [
                                                                Image.asset("assets/emoji.png"),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                const  Text("Powerless Belief",style: TextStyle(color: AppColors.primaryColor),)
                                                              ],
                                                            )),
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              trellisPrinciplesData[index].visibility = !trellisPrinciplesData[index].visibility!;
                                                            });
                                                          },
                                                          child: Container(
                                                              margin:const EdgeInsets.only(left: 10,right: 10),
                                                              child: Row(
                                                                children: [
                                                                  Image.asset(trellisPrinciplesData[index].visibility! ? "assets/close_eye.png" : "assets/open_eye.png"),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(trellisPrinciplesData[index].visibility! ? "Hide" : "Show",style: const TextStyle(color: AppColors.primaryColor),)
                                                                ],
                                                              )
                                                          ),
                                                        ),
                                                      ],
                                                    )   ,
                                                    Visibility(
                                                        visible: trellisPrinciplesData[index].visibility!,
                                                        child: Padding(
                                                            padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                            child: Text(trellisPrinciplesData[index].powerlessBelieves.toString()))),
                                                  ],
                                                ),
                                              )
                                                ],
                                          )),
                                    );
                                  }
                              ),
                            ),

                            // Container(
                            //   decoration:const BoxDecoration(
                            //       color: AppColors.lightGreyColor,
                            //       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                            //   ),
                            //   padding:const EdgeInsets.symmetric(vertical: 10),
                            //   child: Column(
                            //     children: [
                            //       Row(
                            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           Container(
                            //               margin:const EdgeInsets.only(left: 10,right: 10),
                            //               child: Row(
                            //                 children: [
                            //                   Image.asset("assets/arm.png"),
                            //                   const SizedBox(
                            //                     width: 5,
                            //                   ),
                            //                   const  Text("Empowered truths",style: TextStyle(color: AppColors.primaryColor),)
                            //                 ],
                            //               )),
                            //           InkWell(
                            //             onTap: () {
                            //               setState(() {
                            //                 empoweredTruthOR = !empoweredTruthOR;
                            //               });
                            //             },
                            //             child: Container(
                            //                 margin:const EdgeInsets.only(left: 10,right: 10),
                            //                 child: Row(
                            //                   children: [
                            //                     Image.asset(empoweredTruthOR ? "assets/close_eye.png" : "assets/open_eye.png"),
                            //                     const SizedBox(
                            //                       width: 5,
                            //                     ),
                            //                     Text(empoweredTruthOR ? "Hide" : "Show",style: const TextStyle(color: AppColors.primaryColor),)
                            //                   ],
                            //                 )
                            //             ),
                            //           )
                            //
                            //         ],
                            //       ),
                            //
                            //       Container(
                            //           margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                            //           child: Visibility(
                            //               visible: empoweredTruthOR,
                            //               child: Focus(
                            //                 // onFocusChange: (hasFocus) {
                            //                 //   print('empowered truths OP:  $hasFocus');
                            //                 //   if(!hasFocus && empoweredTruthOPController.text.isNotEmpty) {
                            //                 //     _setTrellisData ();
                            //                 //    }
                            //                 //   },
                            //                   child: NameField(empoweredTruthOPController,"empowered truth",1,70,false)))),
                            //       Row(
                            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //         children: [
                            //
                            //           Container(
                            //               margin:const EdgeInsets.only(left: 10,right: 10),
                            //               child: Row(
                            //
                            //                 children: [
                            //                   Image.asset("assets/emoji.png"),
                            //                   const SizedBox(
                            //                     width: 5,
                            //                   ),
                            //                   const  Text("Powerless believes",style: TextStyle(color: AppColors.primaryColor),)
                            //                 ],
                            //               )),
                            //           InkWell(
                            //             onTap: () {
                            //               setState(() {
                            //                 powerLessBelievedOR = !powerLessBelievedOR;
                            //               });
                            //             },
                            //             child: Container(
                            //                 margin:const EdgeInsets.only(left: 10,right: 10),
                            //                 child: Row(
                            //                   children: [
                            //                     Image.asset(powerLessBelievedOR ? "assets/close_eye.png" : "assets/open_eye.png"),
                            //                     const SizedBox(
                            //                       width: 5,
                            //                     ),
                            //                     Text(powerLessBelievedOR ? "Hide" : "Show",style: const TextStyle(color: AppColors.primaryColor),)
                            //                   ],
                            //                 )
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //       Container(
                            //           margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                            //           child: Visibility(
                            //               visible: powerLessBelievedOR,
                            //               child: Focus(
                            //                 // onFocusChange: (hasFocus) {
                            //                 //   print('PowerLess believes OP Field:  $hasFocus');
                            //                 //   if(!hasFocus && powerlessOpController.text.isNotEmpty) {
                            //                 //     _setTrellisData ();
                            //                 //   }
                            //                 // },
                            //                   child: NameField(powerlessOpController,"powerless believes",1,70,false)))),
                            //       SaveButtonWidgets( (){
                            //         _setTrellisOPData();
                            //       }),
                            //
                            //       Container(
                            //         margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            //         child: trellisPrinciplesData.isEmpty ? const Align(
                            //             alignment: Alignment.topLeft,
                            //             child: Text("")) : ListView.builder(
                            //             shrinkWrap: true,
                            //             itemCount: trellisPrinciplesData.length,
                            //             itemBuilder:(context,index) {
                            //               return InkWell(
                            //                 // onTap: () {
                            //                 //   showDialog(
                            //                 //     context: context,
                            //                 //     builder: (BuildContext context) => _buildPopupDialog(context,"Memories/Achievements"),
                            //                 //   );
                            //                 // },
                            //                 child: Container(
                            //                     margin:const EdgeInsets.symmetric(vertical: 5),
                            //                     decoration: BoxDecoration(
                            //                         color: AppColors.backgroundColor,
                            //                         borderRadius: BorderRadius.circular(10)
                            //                     ),
                            //                     padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                            //                     child: Column(
                            //                       children: [
                            //                         Align(alignment: Alignment.topRight,
                            //                           child: IconButton(
                            //                             onPressed: () {
                            //                               _deleteRecord("principles", trellisPrinciplesData[index]['id'],index);
                            //                             },
                            //                             icon:const Icon(Icons.delete,color: AppColors.redColor,),
                            //                           ),),
                            //                         Align(
                            //                             alignment: Alignment.topLeft,
                            //                             child: Text("${trellisPrinciplesData[index]['emp_truths'].toString()} | ${trellisPrinciplesData[index]['powerless_believes'].toString()} "))
                            //                       ],
                            //                     )),
                            //               );
                            //             }
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // )
                          ]
                      ),

                      ExpansionTileWidgetScreen(isRhythmsExpanded,"Rhythms",isRhythmsExpanded,"Empowered rhythms,Powerless habits","",false,(bool value) {
                        // ignore: avoid_print
                        print(value);
                        setScreenStatus("Rh",value);

                        setState(() {
                          isRhythmsExpanded = value;
                        });
                      },() {

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
                          playerController0.loadVideo(rhythmsUrl);
                          playerController0.stopVideo();
                        };

                        // String? videoId = YoutubePlayer.convertUrlToId(rhythmsUrl);
                        // YoutubePlayerController playerController5 = YoutubePlayerController(
                        //     initialVideoId: videoId!,
                        //     flags: const YoutubePlayerFlags(
                        //       autoPlay: false,
                        //       controlsVisibleAtStart: false,
                        //     )
                        //
                        // );
                        videoPopupDialog(context,"Introduction to Rhythms",playerController0);
                      //  bottomSheet(context,"Rhythms","Rhythms are either principles or habitual behaviors that either increase or decrease our well-being. Empowered Rhythms bring life-giving results while Powerless Rhythms decrease overall flourishing. Example: Empowering Rhythm is waking up early to avoid rushing, while a Powerless Rhythm is talking over people.","");
                      },
                          <Widget>[
                            if(!otherUserLoggedIn)
                            AddButton(userPremium == "no" ? trellisRhythmsData.length>= isRhythmsLength: false ,() {
                              needsBottomSheet(context, "Rhythms", <Widget>[
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            margin:const EdgeInsets.only(left: 10,right: 10),
                                            child: Row(
                                              children: [
                                                Image.asset("assets/arm.png"),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                const  Text("Empowered Rhythms",style: TextStyle(color: AppColors.primaryColor),)
                                              ],
                                            )),
                                        // InkWell(
                                        //   onTap: () {
                                        //     setState(() {
                                        //       empoweredTruthRhythms = !empoweredTruthRhythms;
                                        //     });
                                        //   },
                                        //   child: Container(
                                        //       margin:const EdgeInsets.only(left: 10,right: 10),
                                        //       child: Row(
                                        //         children: [
                                        //           Image.asset(empoweredTruthRhythms ? "assets/close_eye.png" : "assets/open_eye.png"),
                                        //           const SizedBox(
                                        //             width: 5,
                                        //           ),
                                        //           Text(empoweredTruthRhythms ? "Hide" : "Show",style:const TextStyle(color: AppColors.primaryColor),)
                                        //         ],
                                        //       )
                                        //   ),
                                        // )

                                      ],
                                    ),

                                    Container(
                                        margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                        child: Visibility(
                                            visible: empoweredTruthRhythms,
                                            child: Focus(
                                              // onFocusChange: (hasFocus) {
                                              //   print('Empowered Truth Rh Field:  $hasFocus');
                                              //   if(!hasFocus && empoweredTruthRhController.text.isNotEmpty) {
                                              //     _setTrellisData ();
                                              //   }
                                              // },
                                                child: NameField(empoweredTruthRhController,"empowered rhythms",1,70,true,otherUserLoggedIn)))),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Container(
                                            margin:const EdgeInsets.only(left: 10,right: 10),
                                            child: Row(

                                              children: [
                                                Image.asset("assets/emoji.png"),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                const  Text("Powerless habits",style: TextStyle(color: AppColors.primaryColor),)
                                              ],
                                            )),
                                        // InkWell(
                                        //   onTap: () {
                                        //     setState(() {
                                        //       powerLessBelievedRhythms = !powerLessBelievedRhythms;
                                        //     });
                                        //   },
                                        //   child: Container(
                                        //       margin:const EdgeInsets.only(left: 10,right: 10),
                                        //       child: Row(
                                        //         children: [
                                        //           Image.asset(powerLessBelievedRhythms ? "assets/close_eye.png" : "assets/open_eye.png"),
                                        //           const SizedBox(
                                        //             width: 5,
                                        //           ),
                                        //           Text(powerLessBelievedRhythms ? "Hide" : "Show",style:const TextStyle(color: AppColors.primaryColor),)
                                        //         ],
                                        //       )
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    Container(
                                        margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                        child: Visibility(
                                            visible: powerLessBelievedRhythms,
                                            child: Focus(
                                              // onFocusChange: (hasFocus) {
                                              //   print('PowerLess believe Rh Field:  $hasFocus');
                                              //   if(!hasFocus && powerlessRhController.text.isNotEmpty) {
                                              //     _setTrellisData ();
                                              //   }
                                              // },
                                                child: NameField(powerlessRhController,"powerless habits",1,70,true,otherUserLoggedIn)))),
                                    if(!otherUserLoggedIn)
                                    SaveButtonWidgets( (){
                                      _setTrellisRhythmsData();
                                    }),

                                  ],
                                ),
                              ]);
                            }),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              child: trellisRhythmsData.isEmpty ? const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("")) : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: trellisRhythmsData.length,
                                  itemBuilder:(context,index) {
                                    return InkWell(
                                      // onTap: () {
                                      //   showDialog(
                                      //     context: context,
                                      //     builder: (BuildContext context) => _buildPopupDialog(context,"Memories/Achievements"),
                                      //   );
                                      // },
                                      child: Container(
                                          margin:const EdgeInsets.symmetric(vertical: 5),
                                          decoration: BoxDecoration(
                                              color: AppColors.backgroundColor,
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          margin:const EdgeInsets.only(left: 10,right: 10),
                                                          alignment: Alignment.centerLeft,
                                                          child: Row(
                                                            children: [
                                                              Image.asset("assets/arm.png"),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              const  Text("Empowered rhythms",style: TextStyle(color: AppColors.primaryColor),)
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                  if(!otherUserLoggedIn)
                                                  Row(
                                                    children: [
                                                      IconButton(onPressed: () {
                                                        setState(() {
                                                          powerlessRhController.text = trellisRhythmsData[index].powerlessBelieves! ;
                                                          empoweredTruthRhController.text = trellisRhythmsData[index].empTruths!;
                                                        });

                                                        needsBottomSheet(context, "Rhythms", <Widget>[
                                                          Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Container(
                                                                      margin:const EdgeInsets.only(left: 10,right: 10),
                                                                      child: Row(
                                                                        children: [
                                                                          Image.asset("assets/arm.png"),
                                                                          const SizedBox(
                                                                            width: 5,
                                                                          ),
                                                                          const  Text("Empowered Rhythms",style: TextStyle(color: AppColors.primaryColor),)
                                                                        ],
                                                                      )),
                                                                  // GestureDetector(
                                                                  //   onTap: () {
                                                                  //     setState(() {
                                                                  //       empoweredTruthRhythms = !empoweredTruthRhythms;
                                                                  //     });
                                                                  //   },
                                                                  //   child: Container(
                                                                  //       margin:const EdgeInsets.only(left: 10,right: 10),
                                                                  //       child: Row(
                                                                  //         children: [
                                                                  //           Image.asset(empoweredTruthRhythms ? "assets/close_eye.png" : "assets/open_eye.png"),
                                                                  //           const SizedBox(
                                                                  //             width: 5,
                                                                  //           ),
                                                                  //           Text(empoweredTruthRhythms ? "Hide" : "Show",style:const TextStyle(color: AppColors.primaryColor),)
                                                                  //         ],
                                                                  //       )
                                                                  //   ),
                                                                  // )

                                                                ],
                                                              ),

                                                              Container(
                                                                  margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                                                  child: Visibility(
                                                                      visible: empoweredTruthRhythms,
                                                                      child: Focus(
                                                                        // onFocusChange: (hasFocus) {
                                                                        //   print('Empowered Truth Rh Field:  $hasFocus');
                                                                        //   if(!hasFocus && empoweredTruthRhController.text.isNotEmpty) {
                                                                        //     _setTrellisData ();
                                                                        //   }
                                                                        // },
                                                                          child: NameField(empoweredTruthRhController,"empowered rhythms",1,70,true,otherUserLoggedIn)))),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [

                                                                  Container(
                                                                      margin:const EdgeInsets.only(left: 10,right: 10),
                                                                      child: Row(

                                                                        children: [
                                                                          Image.asset("assets/emoji.png"),
                                                                          const SizedBox(
                                                                            width: 5,
                                                                          ),
                                                                          const  Text("Powerless habits",style: TextStyle(color: AppColors.primaryColor),)
                                                                        ],
                                                                      )),
                                                                  // GestureDetector(
                                                                  //   onTap: () {
                                                                  //     setState(() {
                                                                  //       powerLessBelievedRhythms = !powerLessBelievedRhythms;
                                                                  //     });
                                                                  //   },
                                                                  //   child: Container(
                                                                  //       margin:const EdgeInsets.only(left: 10,right: 10),
                                                                  //       child: Row(
                                                                  //         children: [
                                                                  //           Image.asset(powerLessBelievedRhythms ? "assets/close_eye.png" : "assets/open_eye.png"),
                                                                  //           const SizedBox(
                                                                  //             width: 5,
                                                                  //           ),
                                                                  //           Text(powerLessBelievedRhythms ? "Hide" : "Show",style:const TextStyle(color: AppColors.primaryColor),)
                                                                  //         ],
                                                                  //       )
                                                                  //   ),
                                                                  // ),
                                                                ],
                                                              ),
                                                              Container(
                                                                  margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                                                  child: Visibility(
                                                                      visible: powerLessBelievedRhythms,
                                                                      child: Focus(
                                                                        // onFocusChange: (hasFocus) {
                                                                        //   print('PowerLess believe Rh Field:  $hasFocus');
                                                                        //   if(!hasFocus && powerlessRhController.text.isNotEmpty) {
                                                                        //     _setTrellisData ();
                                                                        //   }
                                                                        // },
                                                                          child: NameField(powerlessRhController,"powerless habits",1,70,true,otherUserLoggedIn)))),
                                                              if(!otherUserLoggedIn)
                                                              SaveButtonWidgets( (){
                                                                _updateTrellisRhythmsData(index,trellisRhythmsData[index].id!);
                                                              }),

                                                            ],
                                                          ),
                                                        ]);

                                                      }, icon: const Icon(Icons.edit,color: AppColors.primaryColor,)),
                                                      IconButton(
                                                        onPressed: () {
                                                          _deleteRecord("rhythms", trellisRhythmsData[index].id.toString(),index,"");
                                                        },
                                                        icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              // Align(alignment: Alignment.topRight,
                                              //   child: IconButton(
                                              //     onPressed: () {
                                              //       _deleteRecord("rhythms", trellisRhythmsData[index].id.toString(),index);
                                              //     },
                                              //     icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                              //   ),),
                                              Container(
                                                margin: const EdgeInsets.only(bottom: 10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [

                                                    Padding(
                                                      padding:const EdgeInsets.only(left:10,right:10,bottom: 10),
                                                      child: Text(trellisRhythmsData[index].empTruths.toString()),
                                                    ),
                                                    const SizedBox(height: 5,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                            margin:const EdgeInsets.only(left: 10,right: 10),
                                                            child: Row(

                                                              children: [
                                                                Image.asset("assets/emoji.png"),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                const  Text("Powerless habits",style: TextStyle(color: AppColors.primaryColor),)
                                                              ],
                                                            )),
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              trellisRhythmsData[index].visibility = !trellisRhythmsData[index].visibility!;
                                                            });
                                                          },
                                                          child: Container(
                                                              margin:const EdgeInsets.only(left: 10,right: 10),
                                                              child: Row(
                                                                children: [
                                                                  Image.asset(trellisRhythmsData[index].visibility! ? "assets/close_eye.png" : "assets/open_eye.png"),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(trellisRhythmsData[index].visibility! ? "Hide" : "Show",style: const TextStyle(color: AppColors.primaryColor),)
                                                                ],
                                                              )
                                                          ),
                                                        ),
                                                      ],
                                                    )   ,
                                                    Visibility(
                                                        visible: trellisRhythmsData[index].visibility!,
                                                        child: Padding(
                                                            padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                            child: Text(trellisRhythmsData[index].powerlessBelieves.toString()))),
                                                  ],
                                                ),
                                              ),
                                              // Align(
                                              //     alignment: Alignment.topLeft,
                                              //     child: Text("${trellisRhythmsData[index].empTruths.toString()} | ${trellisRhythmsData[index].powerlessBelieves.toString()} "))
                                            ],
                                          )),
                                    );
                                  }
                              ),
                            ),
                            // Container(
                            //   decoration:const BoxDecoration(
                            //     color: AppColors.lightGreyColor,
                            //       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                            //   ),
                            //   padding:const EdgeInsets.symmetric(vertical: 10),
                            //   child: Column(
                            //     children: [
                            //       Row(
                            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           Container(
                            //               margin:const EdgeInsets.only(left: 10,right: 10),
                            //               child: Row(
                            //                 children: [
                            //                   Image.asset("assets/arm.png"),
                            //                   const SizedBox(
                            //                     width: 5,
                            //                   ),
                            //                   const  Text("Empowered truths",style: TextStyle(color: AppColors.primaryColor),)
                            //                 ],
                            //               )),
                            //           InkWell(
                            //             onTap: () {
                            //               setState(() {
                            //                 empoweredTruthRhythms = !empoweredTruthRhythms;
                            //               });
                            //             },
                            //             child: Container(
                            //                 margin:const EdgeInsets.only(left: 10,right: 10),
                            //                 child: Row(
                            //                   children: [
                            //                     Image.asset(empoweredTruthRhythms ? "assets/close_eye.png" : "assets/open_eye.png"),
                            //                     const SizedBox(
                            //                       width: 5,
                            //                     ),
                            //                     Text(empoweredTruthRhythms ? "Hide" : "Show",style:const TextStyle(color: AppColors.primaryColor),)
                            //                   ],
                            //                 )
                            //             ),
                            //           )
                            //
                            //         ],
                            //       ),
                            //
                            //       Container(
                            //           margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                            //           child: Visibility(
                            //               visible: empoweredTruthRhythms,
                            //               child: Focus(
                            //                 // onFocusChange: (hasFocus) {
                            //                 //   print('Empowered Truth Rh Field:  $hasFocus');
                            //                 //   if(!hasFocus && empoweredTruthRhController.text.isNotEmpty) {
                            //                 //     _setTrellisData ();
                            //                 //   }
                            //                 // },
                            //                   child: NameField(empoweredTruthRhController,"empowered truth",1,70,false)))),
                            //       Row(
                            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //         children: [
                            //
                            //           Container(
                            //               margin:const EdgeInsets.only(left: 10,right: 10),
                            //               child: Row(
                            //
                            //                 children: [
                            //                   Image.asset("assets/emoji.png"),
                            //                   const SizedBox(
                            //                     width: 5,
                            //                   ),
                            //                   const  Text("Powerless believes",style: TextStyle(color: AppColors.primaryColor),)
                            //                 ],
                            //               )),
                            //           InkWell(
                            //             onTap: () {
                            //               setState(() {
                            //                 powerLessBelievedRhythms = !powerLessBelievedRhythms;
                            //               });
                            //             },
                            //             child: Container(
                            //                 margin:const EdgeInsets.only(left: 10,right: 10),
                            //                 child: Row(
                            //                   children: [
                            //                     Image.asset(powerLessBelievedRhythms ? "assets/close_eye.png" : "assets/open_eye.png"),
                            //                     const SizedBox(
                            //                       width: 5,
                            //                     ),
                            //                     Text(powerLessBelievedRhythms ? "Hide" : "Show",style:const TextStyle(color: AppColors.primaryColor),)
                            //                   ],
                            //                 )
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //       Container(
                            //           margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                            //           child: Visibility(
                            //               visible: powerLessBelievedRhythms,
                            //               child: Focus(
                            //                 // onFocusChange: (hasFocus) {
                            //                 //   print('PowerLess believe Rh Field:  $hasFocus');
                            //                 //   if(!hasFocus && powerlessRhController.text.isNotEmpty) {
                            //                 //     _setTrellisData ();
                            //                 //   }
                            //                 // },
                            //                   child: NameField(powerlessRhController,"powerless believe",1,70,false)))),
                            //
                            //       SaveButtonWidgets( (){
                            //         _setTrellisRhythmsData();
                            //       }),
                            //       Container(
                            //         margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            //         child: trellisRhythmsData.isEmpty ? const Align(
                            //             alignment: Alignment.topLeft,
                            //             child: Text("")) : ListView.builder(
                            //             shrinkWrap: true,
                            //             itemCount: trellisRhythmsData.length,
                            //             itemBuilder:(context,index) {
                            //               return InkWell(
                            //                 // onTap: () {
                            //                 //   showDialog(
                            //                 //     context: context,
                            //                 //     builder: (BuildContext context) => _buildPopupDialog(context,"Memories/Achievements"),
                            //                 //   );
                            //                 // },
                            //                 child: Container(
                            //                     margin:const EdgeInsets.symmetric(vertical: 5),
                            //                     decoration: BoxDecoration(
                            //                         color: AppColors.backgroundColor,
                            //                         borderRadius: BorderRadius.circular(10)
                            //                     ),
                            //                     padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                            //                     child: Column(
                            //                       children: [
                            //                         Align(alignment: Alignment.topRight,
                            //                           child: IconButton(
                            //                             onPressed: () {
                            //                               _deleteRecord("rhythms", trellisRhythmsData[index]['id'],index);
                            //                             },
                            //                             icon:const Icon(Icons.delete,color: AppColors.redColor,),
                            //                           ),),
                            //                         Align(
                            //                             alignment: Alignment.topLeft,
                            //                             child: Text("${trellisRhythmsData[index]['emp_truths'].toString()} | ${trellisRhythmsData[index]['powerless_believes'].toString()} "))
                            //                       ],
                            //                     )),
                            //               );
                            //             }
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // )

                          ]
                      ),

                      ExpansionTileWidgetScreen(isNeedsExpanded,"Needs",true,"","",true,(bool value) {
                        // ignore: avoid_print
                        print(value);
                        setScreenStatus("Needs",value);

                      },() {

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
                          playerController0.loadVideo(needsUrl);
                          playerController0.stopVideo();
                        };

                        // String? videoId = YoutubePlayer.convertUrlToId(needsUrl);
                        // YoutubePlayerController playerController6 = YoutubePlayerController(
                        //     initialVideoId: videoId!,
                        //     flags: const YoutubePlayerFlags(
                        //       autoPlay: false,
                        //       controlsVisibleAtStart: false,
                        //     )
                        //
                        // );
                        videoPopupDialog(context,"Introduction to Needs",playerController0);
                       //bottomSheet(context,"Needs","The essential and engaging aspects of my life that increase my functioning (joy, peace, and confidence) when present, and lead to greater breakdown and dysfunction when absent. Example - “Regular emotional and relational intimacy with people I enjoy.”","");
                      },
                          <Widget>[
                            Container(
                              decoration:const BoxDecoration(
                                color: AppColors.lightGreyColor,
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                              ),
                              padding:const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  if(!otherUserLoggedIn)
                                  AddButton(userPremium == "no" ? trellisNeedsData.length>= isNeedsLength : false,() {
                                    needsBottomSheet(context, "Needs", <Widget>[
                                      NameField(needsController,"needs",5,140,true,otherUserLoggedIn),
                                      if(!otherUserLoggedIn)
                                      SaveButtonWidgets( (){
                                        _setTrellisNeedsData();
                                      }),
                                    ]);
                                  }),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                    child: trellisNeedsData.isEmpty ? const Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("")) : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: trellisNeedsData.length,
                                        itemBuilder:(context,index) {
                                          return InkWell(
                                            // onTap: () {
                                            //   showDialog(
                                            //     context: context,
                                            //     builder: (BuildContext context) => _buildPopupDialog(context,"Memories/Achievements"),
                                            //   );
                                            // },
                                            child: Container(
                                                margin:const EdgeInsets.symmetric(vertical: 5),
                                                decoration: BoxDecoration(
                                                    color: AppColors.backgroundColor,
                                                    borderRadius: BorderRadius.circular(10)
                                                ),
                                                padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                                child: Column(
                                                  children: [
                                                    if(!otherUserLoggedIn)
                                                    Align(
                                                      alignment: Alignment.topRight,
                                                      child: SizedBox(
                                                        height: 20,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Align(alignment: Alignment.topRight,
                                                              child: IconButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    needsController.text = trellisNeedsData[index]['text'].toString();
                                                                  });

                                                                  needsBottomSheet(context, "Needs", <Widget>[
                                                                    NameField(needsController,"needs",5,140,true,otherUserLoggedIn),
                                                                    if(!otherUserLoggedIn)
                                                                    SaveButtonWidgets( (){
                                                                      _updateTrellisNeedsData(index, trellisNeedsData[index]['id'].toString());
                                                                    }),
                                                                  ]);
                                                                },
                                                                icon:const Icon(Icons.edit,color: AppColors.primaryColor,size: 18,),
                                                              ),),
                                                            Align(alignment: Alignment.topRight,
                                                              child: IconButton(
                                                                onPressed: () {
                                                                  // _deleteRecord("needs", trellisNeedsData[index]['id'],index,"");
                                                                  showDeletePopup("needs", trellisNeedsData[index]['id'].toString(),index,"");
                                                                },
                                                                icon:const Icon(Icons.delete,color: AppColors.redColor,size: 18,),
                                                              ),),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Text(trellisNeedsData[index]['text'].toString()))
                                                  ],
                                                )),
                                          );
                                        }
                                    ),
                                  ),
                                ],
                              ),
                            )

                          ]
                      ),

                      ExpansionTileWidgetScreen(isIdentityExpanded,"Identity",true,"","",true,(bool value) {
                        // ignore: avoid_print
                        print(value);
                        setScreenStatus("Identity",value);

                      },() {

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
                          playerController0.loadVideo(identityUrl);
                          playerController0.stopVideo();
                        };

                        // String? videoId = YoutubePlayer.convertUrlToId(identityUrl);
                        // YoutubePlayerController playerController7 = YoutubePlayerController(
                        //     initialVideoId: videoId!,
                        //     flags: const YoutubePlayerFlags(
                        //       autoPlay: false,
                        //       controlsVisibleAtStart: false,
                        //     )
                        //
                        // );
                        videoPopupDialog(context,"Introduction to Identity",playerController0);
                       // bottomSheet(context,"Identity","My identity is the primary way I identify myself to me and the world around me. Example - “I am a beloved child of God.” Also you can use personality assessments like Enneagram, Strengths, or Meyers-Briggs results and others.","");
                      },
                          <Widget>[
                            Container(
                              decoration:const BoxDecoration(
                                color: AppColors.lightGreyColor,
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                              ),
                              padding:const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  if(!otherUserLoggedIn)
                                  AddButton(userPremium == "no" ? trellisIdentityData.length>= isIdentityLength : false,(){
                                    needsBottomSheet(context, "Identity", <Widget>[
                                      NameField(identityController,"identity",5,200,true,otherUserLoggedIn),
                                      SaveButtonWidgets( (){
                                        _setTrellisIdentityData ();
                                      }),
                                    ]);
                                  }),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                    child:trellisIdentityData.isEmpty ? const Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("")) : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: trellisIdentityData.length,
                                        itemBuilder:(context,index) {
                                          return InkWell(
                                            // onTap: () {
                                            //   showDialog(
                                            //     context: context,
                                            //     builder: (BuildContext context) => _buildPopupDialog(context,"Memories/Achievements"),
                                            //   );
                                            // },
                                            child: Container(
                                              margin:const EdgeInsets.symmetric(vertical: 5),
                                                decoration: BoxDecoration(
                                                    color: AppColors.backgroundColor,
                                                    borderRadius: BorderRadius.circular(10)
                                                ),
                                                padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                                child: Column(
                                                  children: [
                                                    if(!otherUserLoggedIn)
                                                    Align(
                                                      alignment: Alignment.topRight,
                                                      child: SizedBox(
                                                        height: 20,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Align(alignment: Alignment.topRight,
                                                              child: IconButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    identityController.text = trellisIdentityData[index]['text'].toString();
                                                                  });
                                                                  needsBottomSheet(context, "Identity", <Widget>[
                                                                    NameField(identityController,"identity",5,200,true,otherUserLoggedIn),
                                                                    SaveButtonWidgets( (){
                                                                      _updateTrellisIdentityData(index, trellisIdentityData[index]['id'].toString());
                                                                    }),
                                                                  ]);

                                                                },
                                                                icon:const Icon(Icons.edit,color: AppColors.primaryColor,size: 18,),
                                                              ),),
                                                            Align(alignment: Alignment.topRight,
                                                              child: IconButton(
                                                                onPressed: () {
                                                                  // _deleteRecord("identity", trellisIdentityData[index]['id'],index,"");
                                                                  showDeletePopup("identity",trellisIdentityData[index]['id'].toString(),index,"");
                                                                },
                                                                icon:const Icon(Icons.delete,color: AppColors.redColor,size: 18,),
                                                              ),),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Text(trellisIdentityData[index]['text'].toString()))
                                                  ],
                                                )),
                                          );
                                        }
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]
                      ),

                      ExpansionTileWidgetScreen(isTribeExpanded,"Tribe",isTribeExpanded,"Mentor, Peer, Mentee","",false,(bool value) {
                        // ignore: avoid_print
                        print(value);
                        setScreenStatus("Tribe",value);
                        setState(() {
                          isTribeExpanded = value;
                        });
                      },() {

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
                          playerController0.loadVideo(tribeUrl);
                          playerController0.stopVideo();
                        };

                        // String? videoId = YoutubePlayer.convertUrlToId(tribeUrl);
                        // YoutubePlayerController playerController0 = YoutubePlayerController(
                        //     initialVideoId: videoId!,
                        //     flags: const YoutubePlayerFlags(
                        //       autoPlay: false,
                        //       controlsVisibleAtStart: false,
                        //     )
                        //
                        // );
                        videoPopupDialog(context,"Introduction to Tribe",playerController0);
                       // bottomSheet(context,"Tribe","Your Tribe represents your inner circle and concentric circles of people who help you to live the life you desire and be the person you want to be. ","");
                      },
                          <Widget>[
                            Container(
                              decoration:const BoxDecoration(
                                color: AppColors.lightGreyColor,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                              ),
                              padding:const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  if(!otherUserLoggedIn)
                                  AddButton(false,() {
                                    setState(() {
                                      selectedValueFromBottomSheet = "Mentor";
                                      mentorNameController.text = '';
                                      peerNameController.text = '';
                                      menteeNameController.text = '';
                                    });
                                    tribeBottomSheet(context,"Mentor",false,"Tribe",isMentorVisible,isPeerVisible,isMenteeVisible,Column(
                                      children: [
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                                margin:const EdgeInsets.only(left: 10,right: 10),
                                                child:  const Row(
                                                  children: [
                                                    Icon(Icons.person,color: AppColors.primaryColor,),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text("Mentor",style: TextStyle(color: AppColors.primaryColor),)
                                                  ],
                                                ))),
                                        Container(
                                            margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                            child: Focus(
                                              // onFocusChange: (hasFocus) {
                                              //   print('Mentor Name Field:  $hasFocus');
                                              //   if(!hasFocus && mentorNameController.text.isNotEmpty) {
                                              //     _setTrellisData ();
                                              //   }
                                              // },
                                                child: NameField(mentorNameController," name of mentor-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                        // Container(
                                        //     margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                        //     child: Focus(
                                        //       // onFocusChange: (hasFocus) {
                                        //       //   print('Mentor Desc Field:  $hasFocus');
                                        //       //   if(!hasFocus && mentorDescriptionController.text.isNotEmpty) {
                                        //       //     _setTrellisData ();
                                        //       //   }
                                        //       // },
                                        //         child: NameField(mentorDescriptionController,"Description",1,70,false))),
                                      ],
                                    ),Column(
                                      children: [
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                                margin:const EdgeInsets.only(left: 10,right: 10),
                                                child:const Row(
                                                  children: [
                                                    Icon(Icons.person,color: AppColors.primaryColor,),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text("Peer",style: TextStyle(color: AppColors.primaryColor),)
                                                  ],
                                                ))),
                                        Container(
                                            margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                            child: Focus(
                                              // onFocusChange: (hasFocus) {
                                              //   print('Peer Name Field:  $hasFocus');
                                              //   if(!hasFocus && peerNameController.text.isNotEmpty) {
                                              //     _setTrellisData ();
                                              //   }
                                              // },
                                                child: NameField(peerNameController," name of peer-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                        // Container(
                                        //     margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                        //     child: Focus(
                                        //       // onFocusChange: (hasFocus) {
                                        //       //   print('Peer Desc Field:  $hasFocus');
                                        //       //   if(!hasFocus && peerDescriptionController.text.isNotEmpty) {
                                        //       //     _setTrellisData ();
                                        //       //   }
                                        //       // },
                                        //         child: NameField(peerDescriptionController,"Description",1,70,false))),
                                      ],
                                    ),Column(
                                      children: [
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                                margin:const EdgeInsets.only(left: 10,right: 10),
                                                child:const Row(
                                                  children: [
                                                    Icon(Icons.person,color: AppColors.primaryColor,),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text("Mentee",style: TextStyle(color: AppColors.primaryColor),)
                                                  ],
                                                ))),
                                        Container(
                                            margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                            child: Focus(
                                              // onFocusChange: (hasFocus) {
                                              //   print('Mentee Name Field:  $hasFocus');
                                              //   if(!hasFocus && menteeNameController.text.isNotEmpty) {
                                              //     _setTrellisData ();
                                              //   }
                                              // },
                                                child: NameField(menteeNameController," name of mentee-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                        // Container(
                                        //     margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                        //     child: Focus(
                                        //       // onFocusChange: (hasFocus) {
                                        //       //   print('Mentee Desc Field:  $hasFocus');
                                        //       //   if(!hasFocus && menteeDescriptionController.text.isNotEmpty ) {
                                        //       //     _setTrellisData ();
                                        //       //   }
                                        //       // },
                                        //         child: NameField(menteeDescriptionController,"Description",1,70,false))),
                                      ],
                                    ),(selectedValue) {
                                      print('Selected value From Bottom Sheet: $selectedValue');
                                      mentorNameController.clear();
                                      peerNameController.clear();
                                      menteeNameController.clear();
                                      setState(() {
                                        selectedValueFromBottomSheet = selectedValue;
                                      });
                                      // Do something with the selected value
                                    },(){
                                      if(userPremium == "no") {

                                        if(selectedValueFromBottomSheet == "Peer" && trellisPeerTribeData.isEmpty  ) {
                                          _addNewTribeData(id, peerNameController.text, "Peer");
                                        } else if(selectedValueFromBottomSheet == "Mentee" && trellisMenteeTribeData.isEmpty) {
                                          _addNewTribeData(id, menteeNameController.text, "Mentee");
                                        } else if(selectedValueFromBottomSheet == "Mentor" && trellisMentorTribeData.isEmpty) {
                                          _addNewTribeData(id, mentorNameController.text, "Mentor");
                                        }else {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                                        }

                                      } else {
                                            if (selectedValueFromBottomSheet == "Peer") {
                                              _addNewTribeData(id, peerNameController.text, "Peer");
                                            } else if (selectedValueFromBottomSheet == "Mentee") {
                                              _addNewTribeData(id, menteeNameController.text, "Mentee");
                                            } else {
                                              _addNewTribeData(id, mentorNameController.text, "Mentor");
                                            }
                                          }
                                        },);
                                    // needsBottomSheet(context, "Tribe", <Widget>[
                                    //   Row(
                                    //     mainAxisSize: MainAxisSize.min,
                                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    //     children: [
                                    //       InkWell(
                                    //         onTap:() {
                                    //          setState(() {
                                    //            isMentorVisible = true;
                                    //            isPeerVisible = false;
                                    //            isMenteeVisible = false;
                                    //          });
                                    //         },
                                    //         child: Container(
                                    //           padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                    //           decoration: BoxDecoration(
                                    //             color: isMentorVisible ? AppColors.primaryColor : AppColors.lightGreyColor,
                                    //             borderRadius: BorderRadius.circular(10),
                                    //           ),
                                    //           child: const Text("Mentor",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                    //         ),
                                    //       ),
                                    //       InkWell(
                                    //         onTap:() {
                                    //           setState(() {
                                    //             isMentorVisible = false;
                                    //             isPeerVisible = true;
                                    //             isMenteeVisible = false;
                                    //           });
                                    //         },
                                    //         child: Container(
                                    //           padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                    //           decoration: BoxDecoration(
                                    //             color: isPeerVisible ? AppColors.primaryColor : AppColors.lightGreyColor,
                                    //             borderRadius: BorderRadius.circular(10),
                                    //           ),
                                    //           child: const Text("Peer",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                    //         ),
                                    //       ),
                                    //       InkWell(
                                    //         onTap:() {
                                    //           print(isMenteeVisible);
                                    //           setState(() {
                                    //             isMentorVisible = false;
                                    //             isPeerVisible = false;
                                    //             isMenteeVisible = true;
                                    //           });
                                    //         },
                                    //         child: Container(
                                    //           padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                    //           decoration: BoxDecoration(
                                    //             color: isMenteeVisible ? AppColors.primaryColor : AppColors.lightGreyColor,
                                    //             borderRadius: BorderRadius.circular(10),
                                    //           ),
                                    //           child: const Text("Mentee",style: TextStyle(fontSize: AppConstants.defaultFontSize),),
                                    //         ),
                                    //       )
                                    //     ],
                                    //   ),
                                    //   Visibility(
                                    //       visible: isMentorVisible,
                                    //       child: Column(
                                    //     children: [
                                    //       Align(
                                    //           alignment: Alignment.topLeft,
                                    //           child: Container(
                                    //               margin:const EdgeInsets.only(left: 10,right: 10),
                                    //               child: Row(
                                    //                 children:const [
                                    //                   Icon(Icons.person,color: AppColors.primaryColor,),
                                    //                   SizedBox(
                                    //                     width: 5,
                                    //                   ),
                                    //                   Text("Mentor",style: TextStyle(color: AppColors.primaryColor),)
                                    //                 ],
                                    //               ))),
                                    //       Container(
                                    //           margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                    //           child: Focus(
                                    //             // onFocusChange: (hasFocus) {
                                    //             //   print('Mentor Name Field:  $hasFocus');
                                    //             //   if(!hasFocus && mentorNameController.text.isNotEmpty) {
                                    //             //     _setTrellisData ();
                                    //             //   }
                                    //             // },
                                    //               child: NameField(mentorNameController,"Name",1,70,false))),
                                    //       Container(
                                    //           margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                    //           child: Focus(
                                    //             // onFocusChange: (hasFocus) {
                                    //             //   print('Mentor Desc Field:  $hasFocus');
                                    //             //   if(!hasFocus && mentorDescriptionController.text.isNotEmpty) {
                                    //             //     _setTrellisData ();
                                    //             //   }
                                    //             // },
                                    //               child: NameField(mentorDescriptionController,"Description",1,70,false))),
                                    //     ],
                                    //   )),
                                    //
                                    //   Visibility(
                                    //       visible: isPeerVisible,
                                    //       child: Column(
                                    //     children: [
                                    //       Align(
                                    //           alignment: Alignment.topLeft,
                                    //           child: Container(
                                    //               margin:const EdgeInsets.only(left: 10,right: 10),
                                    //               child: Row(
                                    //                 children:const [
                                    //                   Icon(Icons.person,color: AppColors.primaryColor,),
                                    //                   SizedBox(
                                    //                     width: 5,
                                    //                   ),
                                    //                   Text("Peer",style: TextStyle(color: AppColors.primaryColor),)
                                    //                 ],
                                    //               ))),
                                    //       Container(
                                    //           margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                    //           child: Focus(
                                    //             // onFocusChange: (hasFocus) {
                                    //             //   print('Peer Name Field:  $hasFocus');
                                    //             //   if(!hasFocus && peerNameController.text.isNotEmpty) {
                                    //             //     _setTrellisData ();
                                    //             //   }
                                    //             // },
                                    //               child: NameField(peerNameController,"Name",1,70,false))),
                                    //       Container(
                                    //           margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                    //           child: Focus(
                                    //             // onFocusChange: (hasFocus) {
                                    //             //   print('Peer Desc Field:  $hasFocus');
                                    //             //   if(!hasFocus && peerDescriptionController.text.isNotEmpty) {
                                    //             //     _setTrellisData ();
                                    //             //   }
                                    //             // },
                                    //               child: NameField(peerDescriptionController,"Description",1,70,false))),
                                    //     ],
                                    //   )),
                                    //
                                    //   Visibility(
                                    //     visible: isMenteeVisible,
                                    //       child: Column(
                                    //         children: [
                                    //           Align(
                                    //               alignment: Alignment.topLeft,
                                    //               child: Container(
                                    //                   margin:const EdgeInsets.only(left: 10,right: 10),
                                    //                   child: Row(
                                    //                     children:const [
                                    //                       Icon(Icons.person,color: AppColors.primaryColor,),
                                    //                       SizedBox(
                                    //                         width: 5,
                                    //                       ),
                                    //                       Text("Mentee",style: TextStyle(color: AppColors.primaryColor),)
                                    //                     ],
                                    //                   ))),
                                    //           Container(
                                    //               margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                    //               child: Focus(
                                    //                 // onFocusChange: (hasFocus) {
                                    //                 //   print('Mentee Name Field:  $hasFocus');
                                    //                 //   if(!hasFocus && menteeNameController.text.isNotEmpty) {
                                    //                 //     _setTrellisData ();
                                    //                 //   }
                                    //                 // },
                                    //                   child: NameField(menteeNameController,"Name",1,70,false))),
                                    //           Container(
                                    //               margin:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                                    //               child: Focus(
                                    //                 // onFocusChange: (hasFocus) {
                                    //                 //   print('Mentee Desc Field:  $hasFocus');
                                    //                 //   if(!hasFocus && menteeDescriptionController.text.isNotEmpty ) {
                                    //                 //     _setTrellisData ();
                                    //                 //   }
                                    //                 // },
                                    //                   child: NameField(menteeDescriptionController,"Description",1,70,false))),
                                    //         ],
                                    //       )),
                                    //   SaveButtonWidgets( (){
                                    //     _setTribeData();
                                    //   }),
                                    // ]);
                                  }),
                                  Container(
                                      margin:const EdgeInsets.symmetric(vertical: 5),
                                      decoration: BoxDecoration(
                                          color: AppColors.backgroundColor,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      padding:const EdgeInsets.only(top:5,left: 10,right: 10,bottom: 5),
                                      child: Column(
                                        children: [
                                          const Row(
                                            children: [
                                              Icon(Icons.person,color: AppColors.primaryColor,),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text("Mentor",style: TextStyle(color: AppColors.primaryColor),)
                                            ],
                                          ),
                                         trellisMentorTribeData.isEmpty ?const Text("No mentor available") : ListView.builder(
                                              shrinkWrap: true,
                                              physics:const NeverScrollableScrollPhysics(),
                                              itemCount: trellisMentorTribeData.length,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        child: Text("• ${trellisMentorTribeData[index].text} ")),
                                                    if(!otherUserLoggedIn)
                                                    IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedValueFromBottomSheet = "Mentor";
                                                          isMenteeVisible = false;
                                                          isMentorVisible = true;
                                                          isPeerVisible = false;
                                                          mentorNameController.text = trellisMentorTribeData[index].text!;
                                                          peerNameController.text = '';
                                                          menteeNameController.text = '';
                                                        });

                                                        tribeBottomSheet(context,"Mentor",true,"Tribe",isMentorVisible,isPeerVisible,isMenteeVisible,Column(
                                                          children: [
                                                            Align(
                                                                alignment: Alignment.topLeft,
                                                                child: Container(
                                                                    margin:const EdgeInsets.only(left: 10,right: 10),
                                                                    child:  const Row(
                                                                      children: [
                                                                        Icon(Icons.person,color: AppColors.primaryColor,),
                                                                        SizedBox(
                                                                          width: 5,
                                                                        ),
                                                                        Text("Mentor",style: TextStyle(color: AppColors.primaryColor),)
                                                                      ],
                                                                    ))),
                                                            Container(
                                                                margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                                                child: Focus(
                                                                    child: NameField(mentorNameController," name of mentor-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                                          ],
                                                        ),Column(
                                                          children: [
                                                            Align(
                                                                alignment: Alignment.topLeft,
                                                                child: Container(
                                                                    margin:const EdgeInsets.only(left: 10,right: 10),
                                                                    child:const Row(
                                                                      children: [
                                                                        Icon(Icons.person,color: AppColors.primaryColor,),
                                                                        SizedBox(
                                                                          width: 5,
                                                                        ),
                                                                        Text("Peer",style: TextStyle(color: AppColors.primaryColor),)
                                                                      ],
                                                                    ))),
                                                            Container(
                                                                margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                                                child: Focus(
                                                                    child: NameField(peerNameController," name of peer-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                                          ],
                                                        ),Column(
                                                          children: [
                                                            Align(
                                                                alignment: Alignment.topLeft,
                                                                child: Container(
                                                                    margin:const EdgeInsets.only(left: 10,right: 10),
                                                                    child:const Row(
                                                                      children: [
                                                                        Icon(Icons.person,color: AppColors.primaryColor,),
                                                                        SizedBox(
                                                                          width: 5,
                                                                        ),
                                                                        Text("Mentee",style: TextStyle(color: AppColors.primaryColor),)
                                                                      ],
                                                                    ))),
                                                            Container(
                                                                margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                                                child: Focus(

                                                                    child: NameField(menteeNameController," name of mentee-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                                          ],
                                                        ),(selectedValue) {
                                                          print('Selected value From Bottom Sheet: $selectedValue');
                                                          mentorNameController.clear();
                                                          peerNameController.clear();
                                                          menteeNameController.clear();
                                                          setState(() {
                                                            selectedValueFromBottomSheet = selectedValue;
                                                          });
                                                          // Do something with the selected value
                                                        },(){
                                                          _updateTribeData(
                                                              index,
                                                              trellisMentorTribeData[index]
                                                                  .id!,
                                                              mentorNameController
                                                                  .text,
                                                              selectedValueFromBottomSheet);
                                                        },);
                                                      },
                                                      icon:const Icon(Icons.edit,color: AppColors.primaryColor,),
                                                    ),
                                                    if(!otherUserLoggedIn)
                                                    IconButton(
                                                      onPressed: () {
                                                        showDeletePopupForTribe("Mentor",trellisMentorTribeData[index].id.toString(),index);
                                                        // _deleteNewTribe("Mentor",trellisMentorTribeData[index].id.toString(),index);
                                                      },
                                                      icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                                    )
                                                  ],
                                                );
                                              }),
                                        ],
                                      )),
                                  Container(
                                      margin:const EdgeInsets.symmetric(vertical: 5),
                                      decoration: BoxDecoration(
                                          color: AppColors.backgroundColor,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      padding:const EdgeInsets.only(top:5,left: 10,right: 10,bottom: 5),
                                      child: Column(
                                        children: [
                                          const Row(
                                            children: [
                                              Icon(Icons.person,color: AppColors.primaryColor,),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text("Peer",style: TextStyle(color: AppColors.primaryColor),)
                                            ],
                                          ),
                                          trellisPeerTribeData.isEmpty ?const Text("No peer available") : ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: trellisPeerTribeData.length,
                                              physics:const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(child: Text("• ${trellisPeerTribeData[index].text}")),
                                                if(!otherUserLoggedIn)
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedValueFromBottomSheet = "Peer";
                                                      isMenteeVisible = false;
                                                      isMentorVisible = false;
                                                      isPeerVisible = true;
                                                      mentorNameController.text = '';
                                                      peerNameController.text = trellisPeerTribeData[index].text!;
                                                      menteeNameController.text = '';
                                                    });

                                                    tribeBottomSheet(context,"Peer",true,"Tribe",isMentorVisible,isPeerVisible,isMenteeVisible,Column(
                                                      children: [
                                                        Align(
                                                            alignment: Alignment.topLeft,
                                                            child: Container(
                                                                margin:const EdgeInsets.only(left: 10,right: 10),
                                                                child:  const Row(
                                                                  children: [
                                                                    Icon(Icons.person,color: AppColors.primaryColor,),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text("Mentor",style: TextStyle(color: AppColors.primaryColor),)
                                                                  ],
                                                                ))),
                                                        Container(
                                                            margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                                            child: Focus(
                                                                child: NameField(mentorNameController," name of mentor-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                                      ],
                                                    ),Column(
                                                      children: [
                                                        Align(
                                                            alignment: Alignment.topLeft,
                                                            child: Container(
                                                                margin:const EdgeInsets.only(left: 10,right: 10),
                                                                child:const Row(
                                                                  children: [
                                                                    Icon(Icons.person,color: AppColors.primaryColor,),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text("Peer",style: TextStyle(color: AppColors.primaryColor),)
                                                                  ],
                                                                ))),
                                                        Container(
                                                            margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                                            child: Focus(
                                                                child: NameField(peerNameController," name of peer-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                                      ],
                                                    ),Column(
                                                      children: [
                                                        Align(
                                                            alignment: Alignment.topLeft,
                                                            child: Container(
                                                                margin:const EdgeInsets.only(left: 10,right: 10),
                                                                child:const Row(
                                                                  children: [
                                                                    Icon(Icons.person,color: AppColors.primaryColor,),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text("Mentee",style: TextStyle(color: AppColors.primaryColor),)
                                                                  ],
                                                                ))),
                                                        Container(
                                                            margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                                            child: Focus(

                                                                child: NameField(menteeNameController," name of mentee-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                                      ],
                                                    ),(selectedValue) {
                                                      print('Selected value From Bottom Sheet: $selectedValue');
                                                      mentorNameController.clear();
                                                      peerNameController.clear();
                                                      menteeNameController.clear();
                                                      setState(() {
                                                        selectedValueFromBottomSheet = selectedValue;
                                                      });
                                                      // Do something with the selected value
                                                    },(){
                                                      _updateTribeData(index,
                                                          trellisPeerTribeData[index]
                                                              .id!,
                                                          peerNameController
                                                              .text,
                                                          selectedValueFromBottomSheet);

                                                    },);

                                                  },
                                                  icon:const Icon(Icons.edit,color: AppColors.primaryColor,),
                                                ),
                                                if(!otherUserLoggedIn)
                                                IconButton(
                                                  onPressed: () {
                                                    showDeletePopupForTribe("Peer",trellisPeerTribeData[index].id.toString(),index);
                                                    // _deleteNewTribe("Peer",trellisPeerTribeData[index].id.toString(),index);
                                                  },
                                                  icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                                )
                                              ],
                                            );
                                          }),

                                        ],
                                      )),
                                  Container(
                                      margin:const EdgeInsets.symmetric(vertical: 5),
                                      decoration: BoxDecoration(
                                          color: AppColors.backgroundColor,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      padding:const EdgeInsets.only(top:5,left: 10,right: 10,bottom: 5),
                                      child: Column(
                                        children: [
                                          const Row(
                                            children: [
                                              Icon(Icons.person,color: AppColors.primaryColor,),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text("Mentee",style: TextStyle(color: AppColors.primaryColor),)
                                            ],
                                          ),
                                          trellisMenteeTribeData.isEmpty ?const Text("No mentee available") :  ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: trellisMenteeTribeData.length,
                                              physics:const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(child: Text("• ${trellisMenteeTribeData[index].text}")),
                                                    if(!otherUserLoggedIn)
                                                    IconButton(
                                                      onPressed: () {

                                                        setState(() {
                                                          menteeNameController.text = trellisMenteeTribeData[index].text!;
                                                          selectedValueFromBottomSheet = "Mentee";
                                                          isMenteeVisible = true;
                                                          isMentorVisible = false;
                                                          isPeerVisible = false;
                                                          mentorNameController.text = '';
                                                          peerNameController.text = '';
                                                        });

                                                        print('EDIT MENTEE');
                                                        print(trellisMenteeTribeData[index].text!);
                                                        print(menteeNameController.text);


                                                        tribeBottomSheet(context,"Mentee",true,"Tribe",isMentorVisible,isPeerVisible,isMenteeVisible,Column(
                                                          children: [
                                                            Align(
                                                                alignment: Alignment.topLeft,
                                                                child: Container(
                                                                    margin:const EdgeInsets.only(left: 10,right: 10),
                                                                    child:  const Row(
                                                                      children: [
                                                                        Icon(Icons.person,color: AppColors.primaryColor,),
                                                                        SizedBox(
                                                                          width: 5,
                                                                        ),
                                                                        Text("Mentor",style: TextStyle(color: AppColors.primaryColor),)
                                                                      ],
                                                                    ))),
                                                            Container(
                                                                margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                                                child: Focus(
                                                                    child: NameField(mentorNameController," name of mentor-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                                          ],
                                                        ),Column(
                                                          children: [
                                                            Align(
                                                                alignment: Alignment.topLeft,
                                                                child: Container(
                                                                    margin:const EdgeInsets.only(left: 10,right: 10),
                                                                    child:const Row(
                                                                      children: [
                                                                        Icon(Icons.person,color: AppColors.primaryColor,),
                                                                        SizedBox(
                                                                          width: 5,
                                                                        ),
                                                                        Text("Peer",style: TextStyle(color: AppColors.primaryColor),)
                                                                      ],
                                                                    ))),
                                                            Container(
                                                                margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                                                child: Focus(
                                                                    child: NameField(peerNameController," name of peer-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                                          ],
                                                        ),Column(
                                                          children: [
                                                            Align(
                                                                alignment: Alignment.topLeft,
                                                                child: Container(
                                                                    margin:const EdgeInsets.only(left: 10,right: 10),
                                                                    child:const Row(
                                                                      children: [
                                                                        Icon(Icons.person,color: AppColors.primaryColor,),
                                                                        SizedBox(
                                                                          width: 5,
                                                                        ),
                                                                        Text("Mentee",style: TextStyle(color: AppColors.primaryColor),)
                                                                      ],
                                                                    ))),
                                                            Container(
                                                                margin:const EdgeInsets.only(top: 5,left: 10,right: 10),
                                                                child: Focus(

                                                                    child: NameField(menteeNameController," name of mentee-Type what they provide you",1,70,false,otherUserLoggedIn))),
                                                          ],
                                                        ),(selectedValue) {
                                                          print('Selected value From Bottom Sheet: $selectedValue');
                                                          mentorNameController.clear();
                                                          peerNameController.clear();
                                                          menteeNameController.clear();
                                                          setState(() {
                                                            selectedValueFromBottomSheet = selectedValue;
                                                          });
                                                          // Do something with the selected value
                                                        },(){
                                                          _updateTribeData(
                                                              index,
                                                              trellisMenteeTribeData[index]
                                                                  .id!,
                                                              menteeNameController
                                                                  .text,
                                                              selectedValueFromBottomSheet);

                                                        },);
                                                      },
                                                      icon:const Icon(Icons.edit,color: AppColors.primaryColor,),
                                                    ),
                                                    if(!otherUserLoggedIn)
                                                    IconButton(
                                                      onPressed: () {
                                                        showDeletePopupForTribe("Mentee",trellisMenteeTribeData[index].id.toString(),index);
                                                      },
                                                      icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                                    )
                                                  ],
                                                );
                                              }),
                                        ],
                                      )),
                                  // Container(
                                  //   margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  //   child: trellisTribeData.isEmpty ? const Align(
                                  //       alignment: Alignment.topLeft,
                                  //       child: Text("")) : ListView.builder(
                                  //       shrinkWrap: true,
                                  //       itemCount: trellisTribeData.length,
                                  //       itemBuilder:(context,index) {
                                  //         return InkWell(
                                  //           // onTap: () {
                                  //           //   showDialog(
                                  //           //     context: context,
                                  //           //     builder: (BuildContext context) => _buildPopupDialog(context,"Memories/Achievements"),
                                  //           //   );
                                  //           // },
                                  //           child: Container(
                                  //               margin:const EdgeInsets.symmetric(vertical: 5),
                                  //               decoration: BoxDecoration(
                                  //                   color: AppColors.backgroundColor,
                                  //                   borderRadius: BorderRadius.circular(10)
                                  //               ),
                                  //               padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                  //               child: Column(
                                  //                 children: [
                                  //                   Row(
                                  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //                     children: [
                                  //                       const Row(
                                  //                         children: [
                                  //                           Icon(Icons.person,color: AppColors.primaryColor,),
                                  //                           SizedBox(
                                  //                             width: 5,
                                  //                           ),
                                  //                           Text("Mentor",style: TextStyle(color: AppColors.primaryColor),)
                                  //                         ],
                                  //                       ),
                                  //                       IconButton(
                                  //                         onPressed: () {
                                  //                           _deleteRecord("tribe", trellisTribeData[index]['id'],index,"");
                                  //                         },
                                  //                         icon:const Icon(Icons.delete,color: AppColors.redColor,),
                                  //                       )
                                  //                     ],
                                  //                   ),
                                  //                   Container(
                                  //                     alignment: Alignment.centerLeft,
                                  //                     padding:const EdgeInsets.only(left: 5,right: 5,bottom: 10),
                                  //                     child: Column(
                                  //                       crossAxisAlignment: CrossAxisAlignment.start,
                                  //                       mainAxisAlignment: MainAxisAlignment.start,
                                  //                       children: [
                                  //                         Text(trellisTribeData[index]['mentor'].toString()),
                                  //                       ],
                                  //                     ),
                                  //                   ),
                                  //                   const Row(
                                  //                     children: [
                                  //                       Icon(Icons.person,color: AppColors.primaryColor,),
                                  //                       SizedBox(
                                  //                         width: 5,
                                  //                       ),
                                  //                       Text("Peer",style: TextStyle(color: AppColors.primaryColor),)
                                  //                     ],
                                  //                   ),
                                  //                   Container(
                                  //                     alignment: Alignment.centerLeft,
                                  //                     padding:const EdgeInsets.only(left: 5,right: 5,bottom: 10),
                                  //                     child: Column(
                                  //                       crossAxisAlignment: CrossAxisAlignment.start,
                                  //                       mainAxisAlignment: MainAxisAlignment.start,
                                  //                       children: [
                                  //                         Text(trellisTribeData[index]['peer'].toString()),
                                  //                       ],
                                  //                     ),
                                  //                   ),
                                  //                   const  Row(
                                  //                     children: [
                                  //                       Icon(Icons.person,color: AppColors.primaryColor,),
                                  //                       SizedBox(
                                  //                         width: 5,
                                  //                       ),
                                  //                       Text("Mentee",style: TextStyle(color: AppColors.primaryColor),)
                                  //                     ],
                                  //                   ),
                                  //                   Container(
                                  //                     alignment: Alignment.centerLeft,
                                  //                     padding:const EdgeInsets.only(left: 5,right: 5,bottom: 10),
                                  //                     child: Column(
                                  //                       crossAxisAlignment: CrossAxisAlignment.start,
                                  //                       mainAxisAlignment: MainAxisAlignment.start,
                                  //                       children: [
                                  //                         Text(trellisTribeData[index]['mentee'].toString()),
                                  //                       ],
                                  //                     ),
                                  //                   ),
                                  //                 ],
                                  //               )),
                                  //         );
                                  //       }
                                  //   ),
                                  // ),
                                ],
                              ),
                            )
                          ]
                      ),
                      const SizedBox(height: 10,),
                      if(!otherUserLoggedIn)
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: (){
                            _saveTrellisTriggerResponse();
                          },
                          style:ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            backgroundColor: AppColors.primaryColor,
                          ),
                          child: const Text("I Read My Trellis Today",style: TextStyle(color: AppColors.backgroundColor),),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height/16,)
                    ],
                  ),
                ),
              ),
              _isDataLoading ?
              const Center(child: CircularProgressIndicator())
                  : Container() ,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context,String heading,TrellisLadderDataModel trellisLadderDataModel1, bool oneCategory) {
    return  AlertDialog(
      backgroundColor: AppColors.lightGreyColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Ladder Highlights",style: TextStyle(fontSize: AppConstants.headingFontSize),),
              Text(heading,style: const TextStyle(fontSize: AppConstants.defaultFontSize,color: AppColors.primaryColor),),
            ],
          ),
          IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon:const Icon(Icons.cancel))
        ],),
      content:  Container(
        width:!isPhone? MediaQuery.of(context).size.width/4 : MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.backgroundColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin:const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const  Expanded(
                      flex:1,
                      child: Text("Type: ",style: TextStyle(fontWeight: FontWeight.bold),)),
                  Expanded(
                      flex: 2,
                      child: Text(trellisLadderDataModel1.type!)),
                ],
              ),
            ),
            Container(
              margin:const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                      flex:1,
                      child: Text("Category: ",style: TextStyle(fontWeight: FontWeight.bold),)),
                  Expanded(
                      flex: 2,
                      child: Text(trellisLadderDataModel1.option1!)),
                ],
              ),
            ),
            Container(
              margin:const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                      flex:1,
                      child: Text("Date: ",style: TextStyle(fontWeight: FontWeight.bold),)),
                  Expanded(
                      flex: 2,
                      child: Text(trellisLadderDataModel1.option2! == "Challenges" ? "" :DateFormat('MM-dd-yy').format(DateTime.parse(trellisLadderDataModel1.date.toString())))),
                ],
              ),
            ),
            Container(
              margin:const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                      flex:1,
                      child: Text("Title: ",style: TextStyle(fontWeight: FontWeight.bold),)),

                  Expanded(
                      flex: 2,
                      child: Text(trellisLadderDataModel1.text!)),
                ],
              ),
            ),
            Container(
              margin:const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                      flex:1,
                      child:  Text("Description: ",style: TextStyle(fontWeight: FontWeight.bold),)),
                  Expanded(
                      flex: 2,
                      child: Text(trellisLadderDataModel1.description!)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addNewTribeData(String userIdd,String fieldValue,String type) {

    if(fieldValue.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisNewTribeDataAdd(TrellisNewDataAddRequestModel(
          userId: userIdd, text: fieldValue, type: type)).then((value) {

        TribeDataResponse tribeDataResponse = TribeDataResponse(
          id: value['post_data']['id'].toString(),
        userId: value['post_data']['user_id'].toString(),
        type: value['post_data']['type'].toString(),
        text: value['post_data']['text'].toString(),
        createdAt: "",);

        if(type == "Peer") {
          trellisPeerTribeData.add(tribeDataResponse);
        } else if(type == "Mentee") {
          trellisMenteeTribeData.add(tribeDataResponse);
        } else {
          trellisMentorTribeData.add(tribeDataResponse);
        }
        setState(() {
          mentorNameController.text = '';
          peerNameController.text = '';
          menteeNameController.text = '';

          _isDataLoading = false;
        });

        Navigator.of(context).pop();
        showToastMessage(context, "Tribe added Successfully", true);
      }).catchError((e) {
        print(e.toString());
        setState(() {
          _isDataLoading = false;
        });
        showToastMessage(context, e.toString(), false);
      });
    } else {
      setState(() {
        _isDataLoading = false;
      });
      showToastMessage(context, "Please Enter data in the field", false);
    }

  }

  _updateTrellisNeedsData (int index,String responseID) {

    if(needsController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager()
          .trellisUpdateIdentity(TrellisUpdateIdentityRequestModel(
          id: responseID, type: "needs", text: needsController.text))
          .then((value) {
        // print("Needs Success");
        // print(value);
        trellisNeedsData[index] = value['updated_data'];
        showToastMessage(context, "Need updated successfully", true);
        setState(() {
          needsController.text = "";
          _isDataLoading = false;
        });
        Navigator.of(context).pop();
      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });
    } else {
      showToastMessage(context, "Add your needs in the field", false);
    }
  }

  _updateTrellisOPData (int index,String responseId) {

    if(empoweredTruthOPController.text.isNotEmpty || powerlessOpController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager()
          .trellisUpdatePrinciples(TrellisPrinciplesUpdateRequestModel(
          id: responseId, type: "principles", empTruths: empoweredTruthOPController.text,powerlessBelieve: powerlessOpController.text))
          .then((value) {
        // print("Organizing Principle Success");
        // print(value);
        setState(() {
          trellisPrinciplesData[index] = Trellis_principle_data_model_class(
            id : responseId,
            userId : id,
            type : value['updated_data']['type'].toString(),
            empTruths : value['updated_data']['emp_truths'].toString(),
            powerlessBelieves : value['updated_data']['powerless_believes'].toString(),
            visibility : false,
          );
        });
        Navigator.of(context).pop();
        showToastMessage(context, "Organizing Principle updated successfully", true);
        setState(() {
          empoweredTruthOPController.text = "";
          powerlessOpController.text = "";
          _isDataLoading = false;
        });
        // Navigator.of(context).pop();
      }).catchError((e) {
        // ignore: avoid_print
        print(e);
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });
    } else {
      showToastMessage(context, "Add some data please", false);
    }
  }

  _updateTrellisIdentityData (int index,String responseID) {

    if(identityController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager()
          .trellisUpdateIdentity(TrellisUpdateIdentityRequestModel(
          id: responseID, type: "identity", text: identityController.text))
          .then((value) {
        // print("Identity Success");
        // print(value);
        trellisIdentityData[index] = value['updated_data'];
        showToastMessage(context, "Identity updated successfully", true);
        setState(() {
          _isDataLoading = false;
          identityController.text = "";
        });
        Navigator.of(context).pop();
      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });
    } else {
      showToastMessage(context, "Add your identity in the field", false);
    }
  }

  _updateTrellisRhythmsData (int index,String responseId) {

    if(empoweredTruthRhController.text.isNotEmpty || powerlessRhController.text.isNotEmpty ) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager()
          .trellisUpdatePrinciples(TrellisPrinciplesUpdateRequestModel(
          id: responseId, type: "rhythms", empTruths: empoweredTruthRhController.text,powerlessBelieve: powerlessRhController.text))
          .then((value) {
        setState(() {
          _isDataLoading = false;
        });
        trellisRhythmsData[index] = Trellis_principle_data_model_class(
          id : responseId,
          userId : id,
          type : value['updated_data']['type'].toString(),
          empTruths : value['updated_data']['emp_truths'].toString(),
          powerlessBelieves : value['updated_data']['powerless_believes'].toString(),
          visibility : false,);
        Navigator.of(context).pop();
        showToastMessage(context, "Rhythms updated successfully", true);
        setState(() {
          empoweredTruthRhController.text = "";
          powerlessRhController.text = "";
        });
        //  Navigator.of(context).pop();
      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });
    } else {
      showToastMessage(context, "Add your data please", false);
    }
  }

  _updateTribeData(int index,String responseId,String fieldValue,String type) {

    print("Update This type date");
    print(type);

    if(fieldValue.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisUpdateTribeDataAdd(TrellisUpdateDataAddRequestModel(
          id: responseId, text: fieldValue, type: type)).then((value) {

        TribeDataResponse tribeDataResponse = TribeDataResponse(
          id: responseId,
          userId: id,
          type: value['updated_data']['type'].toString(),
          text: value['updated_data']['text'].toString(),
          createdAt: "",);

        if(type == "Peer") {
          trellisPeerTribeData[index] = tribeDataResponse;
        } else if(type == "Mentee") {
          trellisMenteeTribeData[index] = tribeDataResponse;
        } else {
          trellisMentorTribeData[index] = tribeDataResponse;
        }
        setState(() {
          mentorNameController.text = '';
          peerNameController.text = '';
          menteeNameController.text = '';

          _isDataLoading = false;
        });

        Navigator.of(context).pop();
        showToastMessage(context, "Tribe updated Successfully", true);
      }).catchError((e) {
        print(e.toString());
        setState(() {
          _isDataLoading = false;
        });
        showToastMessage(context, e.toString(), false);
      });
    } else {
      setState(() {
        _isDataLoading = false;
      });
      showToastMessage(context, "Please Enter data in the field", false);
    }

  }

  _saveTrellisTriggerResponse() {
    setState(() {
      _isDataLoading = true;
    });
    HTTPManager().trellisTriggerData(TrellisTriggerRequestModel(userId: id)).then((value) {
      // ignore: avoid_print
      print(value);
      setState(() {
        _isDataLoading = false;
      });
      showToastMessage(context, "Great job growing your Garden!", true);
    }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      print(e);
    });
  }

  _deleteNewTribe(String type,String tribeDataId,int indexItem) {
    setState(() {
      _isDataLoading = true;
    });

    HTTPManager().trellisNewTribeDelete(TribeNewDataTrellisDeleteRequestModel(recordId: tribeDataId)).then((value) {

      print(value);
      if(type == "Peer") {
        trellisPeerTribeData.removeAt(indexItem);
      } else if(type == "Mentee") {
        trellisMenteeTribeData.removeAt(indexItem);
      } else {
        trellisMentorTribeData.removeAt(indexItem);
      }
      setState(() {
        _isDataLoading = false;
      });

      showToastMessage(context, "Deleted successfully", true);

    }).catchError((e) {
      print(e.toString());
      setState(() {
        _isDataLoading = false;
      });
      showToastMessage(context, e.toString(), false);
    });

  }

  _deleteRecord(String type,String recordId,int index,String goalsOrChallenges) {
    // print(type);
    // print(index);
    setState(() {
      _isDataLoading = true;
    });
    HTTPManager().trellisDelete(TrellisDeleteRequestModel(userId: id,recordId: recordId,type:type,)).then((value) {

      if(type == "goal") {
          setState(() {
            trellisLadderDataForGoalsFavourites.removeAt(index);
          });
      } else if(type == "challenges") {
        setState(() {
          trellisLadderDataForChallengesFavourites.removeAt(index);
        });
      } else if(type == "memories") {
        setState(() {
          trellisLadderDataForMemoriesFavourites.removeAt(index);
        });
      } else if(type == "achievements") {
        setState(() {
          trellisLadderDataForAchievementsFavourites.removeAt(index);
        });
      } else if(type == "needs") {
        setState(() {
          trellisNeedsData.removeAt(index);
        });
      } else if(type == "identity") {
        setState(() {
          trellisIdentityData.removeAt(index);
        });
      } else if(type == "principles") {
        setState(() {
          trellisPrinciplesData.removeAt(index);
        });
      } else if(type == "rhythms") {
        setState(() {
          trellisRhythmsData.removeAt(index);
        });
      } else if(type == "tribe") {
        setState(() {
          trellisTribeData.removeAt(index);
        });
      }
      setState(() {
        _isDataLoading = false;
      });
     // print(value);
     // _getTrellisReadData(false);
      showToastMessage(context, "Deleted successfully", true);

    }).catchError((e) {
      showToastMessage(context, e.toString(), false);
      setState(() {
        _isDataLoading = false;
      });
    });
  }

  _setLadderGoalsData() {
    // ignore: avoid_print
    // print("Selected Date:${dateForGController.text}");
    print('Setting Ladder Goals Data  =================> Ladder Type = $initialValueForLadderType');

    if(initialValueForLadderType != "" && titleForGController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });


      HTTPManager().trellisLadderForGoals(TrellisLadderGoalsRequestModel(userId: id,type: initialValueForLadderType == "Goals" ? "goal" : initialValueForLadderType.toLowerCase(),option1: initialValueForType,option2: initialValueForLadderType,date: dateForGController.text,title: titleForGController.text,description: descriptionForGController.text,insertFrom: "trellis")).then((value) {

        Navigator.of(context).pop();
        setState(() {
          initialValueForLadderType = "Goals";
          initialValueForType = "Physical";
          initialValueForMType = "Memories";
          initialValueForGType = "Goals";
          dateForGController.text = "";
          titleForGController.text = "";
          descriptionForGController.text = "";
        });

        TrellisLadderDataModel trellisLadderDataModel = TrellisLadderDataModel(
          id: value['post_data']['id'].toString(),
          userId: value['post_data']['user_id'].toString(),
          type: value['post_data']['type'].toString(),
          favourite: value['post_data']['favourite'].toString(),
          option1: value['post_data']['option1'].toString(),
          option2: value['post_data']['option2'].toString(),
          date: value['post_data']['date'].toString(),
          text: value['post_data']['text'].toString(),
          description: value['post_data']['description'].toString(),
        );


        if(trellisLadderDataModel.type == 'goal'){
          if(trellisLadderDataForGoalsFavourites.length < 3 ) {
            showToastMessage(context, "Added successfully", true);
            trellisLadderDataForGoalsFavourites.add(trellisLadderDataModel);
          }else{
            showToastMessage(context, "Please remove some item from your favourites list in Goals in ladder section", true);
          }
        }else if(trellisLadderDataModel.type == 'challenges'){
          if(trellisLadderDataForChallengesFavourites.length < 3){
            showToastMessage(context, "Added successfully", true);
            trellisLadderDataForChallengesFavourites.add(trellisLadderDataModel);
          }else{
            showToastMessage(context, "Please remove some item from your favourites list in Challenges in ladder section", true);
          }
        }



        trellisLadderDataForGoals.sort((a,b)=>b.date!.compareTo(a.date!));
        trellisLadderDataForGoalsFavourites.sort((a,b) => b.date!.compareTo(a.date!));
        trellisLadderDataForChallengesFavourites.sort((a,b) => b.date!.compareTo(a.date!));
        trellisLadderDataForGoalsChallenges.sort((a,b)=>b.date!.compareTo(a.date!));

        setState(() {
          _isDataLoading = false;
        });
        // print(value);
        // print("Ladder Data For Goals");
      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });

    } else {
      showToastMessage(context, "Add some text to title field please", false);
    }
  }

  // _setLadderGoalsData() {
  //   // ignore: avoid_print
  //   print("Seleted Date:${dateForGController.text}");
  //
  //   if(initialValueForGoals != "" || dateForGController.text.isNotEmpty || initialValueForType == "" || titleForGController.text.isNotEmpty ) {
  //     setState(() {
  //       _isDataLoading = true;
  //     });
  //     HTTPManager().trellisLadderForGoals(TrellisLadderGoalsRequestModel(userId: id,type: "goal",option1: initialValueForType,option2: initialValueForGoals,date: dateForGController.text,title: titleForGController.text,description: descriptionForGController.text,insertFrom: "trellis")).then((value) {
  //
  //       Navigator.of(context).pop();
  //       setState(() {
  //         dateForGController.text = "";
  //         titleForGController.text = "";
  //         descriptionForGController.text = "";
  //       });
  //       if(value['post_data']['option2'] == "Challenges") {
  //         trellisLadderDataForGoalsChallenges.insert(0, value['post_data']);
  //       } else {
  //         trellisLadderDataForGoals.insert(0, value['post_data']);
  //       }
  //       setState(() {
  //         _isDataLoading = false;
  //       });
  //       // print(value);
  //       // print("Ladder Data For Goals");
  //       showToastMessage(context, "Record added successfully", true);
  //     }).catchError((e) {
  //       showToastMessage(context, e.toString(), false);
  //       setState(() {
  //         _isDataLoading = false;
  //       });
  //     });
  //
  //   } else {
  //     showToastMessage(context, "Add some data please", false);
  //   }
  // }

  // _setLadderMemoriesData() {
  //   if( dateForMController.text.isNotEmpty  || titleForMController.text.isNotEmpty ) {
  //     setState(() {
  //       _isDataLoading = true;
  //     });
  //     HTTPManager().trellisLadderForAchievements(TrellisLadderAchievementRequestModel(userId: id,type: "achievements",option1:initialValueForMType ,date: dateForMController.text,title: titleForMController.text,description: descriptionForMController.text,insertFrom: "trellis")).then((value) {
  //
  //       Navigator.of(context).pop();
  //       setState(() {
  //         dateForMController.text = "";
  //         titleForMController.text = "";
  //         descriptionForMController.text = "";
  //       });
  //       trellisLadderDataForAchievements.insert(0,value['post_data']);
  //       setState(() {
  //         _isDataLoading = false;
  //       });
  //       // print(value);
  //       // print("Ladder Data For Achievements");
  //       showToastMessage(context, "Record added successfully", true);
  //     }).catchError((e) {
  //       showToastMessage(context, e.toString(), false);
  //       setState(() {
  //         _isDataLoading = false;
  //       });
  //     });
  //
  //   } else {
  //     showToastMessage(context, "Add some data please", false);
  //   }
  // }

  _setLadderMemoriesData() {
    print('Set Ladder Memories Data =========>');
    print(initialValueForLadderType != "");
    print(titleForGController.text.isNotEmpty);

    if(initialValueForLadderType != "" && titleForGController.text.isNotEmpty && dateForGController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisLadderForAchievements(TrellisLadderAchievementRequestModel(userId: id,type: initialValueForLadderType.toLowerCase(),option1:initialValueForType,option2: initialValueForLadderType,date: dateForGController.text,title: titleForGController.text,description: descriptionForGController.text,insertFrom: "trellis")).then((value) {

        print('Achievement Added Successfully 1 =================> ${value['post_data']['type']}');
        Navigator.of(context).pop();
        setState(() {
          dateForGController.text = "";
          titleForGController.text = "";
          descriptionForGController.text = "";
        });

        TrellisLadderDataModel trellisLadderDataModel = TrellisLadderDataModel(
          id: value['post_data']['id'].toString(),
          userId: value['post_data']['user_id'].toString(),
          type: value['post_data']['type'].toString(),
          favourite: value['post_data']['favourite'].toString(),
          option1: value['post_data']['option1'].toString(),
          option2: value['post_data']['option2'].toString(),
          date: value['post_data']['date'].toString(),
          text: value['post_data']['text'].toString(),
          description: value['post_data']['description'].toString(),
        );


        print('Achievement Added Successfully 2 =================> ${trellisLadderDataModel.type}');
        if(trellisLadderDataModel.type == 'memories'){
          if(trellisLadderDataForMemoriesFavourites.length < 3 ) {
            showToastMessage(context, "Added successfully", true);
            trellisLadderDataForMemoriesFavourites.add(trellisLadderDataModel);
          }else{
            showToastMessage(context, "Please remove some item from your favourites list in Achievements/Memories in ladder section", true);
          }
        }else if(trellisLadderDataModel.type == 'achievements'){
          print('Achievement Added Successfully 3 =================> ');
          if(trellisLadderDataForAchievementsFavourites.length < 3){
            print('Achievement Added Successfully 4 =================> ');
            showToastMessage(context, "Added successfully", true);
            trellisLadderDataForAchievementsFavourites.add(trellisLadderDataModel);
          }else{
            showToastMessage(context, "Please remove some item from your favourites list in Achievements/Memories in ladder section", true);
          }
        }



        trellisLadderDataForAchievements.sort((a,b)=>b.date!.compareTo(a.date!));
        trellisLadderDataForAchievementsFavourites.sort((a,b)=>b.date!.compareTo(a.date!));
        trellisLadderDataForMemoriesFavourites.sort((a,b)=>b.date!.compareTo(a.date!));

        setState(() {
          _isDataLoading = false;
        });
        // print(value);
        // print("Ladder Data For Achievements");

      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });

    } else {
      showToastMessage(context, "Add some data please", false);
    }
  }

  _setTrellisOPData () {

    if(empoweredTruthOPController.text.isNotEmpty || powerlessOpController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager()
          .trellisPrinciples(TrellisPrinciplesRequestModel(
          userId: id, type: "principles", empTruths: empoweredTruthOPController.text,powerlessBelieve: powerlessOpController.text))
          .then((value) {
        // print("Organizing Principle Success");
        // print(value);
        trellisPrinciplesData.add(Trellis_principle_data_model_class(
            id : value['post_data']['id'].toString(),
            userId : value['post_data']['user_id'].toString(),
            type : value['post_data']['type'].toString(),
            empTruths : value['post_data']['emp_truths'].toString(),
            powerlessBelieves : value['post_data']['powerless_believes'].toString(),
            visibility : false,
            ));
        Navigator.of(context).pop();
        showToastMessage(context, "Organizing Principle added successfully", true);
        setState(() {
          empoweredTruthOPController.text = "";
          powerlessOpController.text = "";
          _isDataLoading = false;
        });
       // Navigator.of(context).pop();
      }).catchError((e) {
        // ignore: avoid_print
        print(e);
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });
    } else {
      showToastMessage(context, "Add some data please", false);
    }
  }

  _setTrellisRhythmsData () {

    if(empoweredTruthRhController.text.isNotEmpty || powerlessRhController.text.isNotEmpty ) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager()
          .trellisPrinciples(TrellisPrinciplesRequestModel(
          userId: id, type: "rhythms", empTruths: empoweredTruthRhController.text,powerlessBelieve: powerlessRhController.text))
          .then((value) {
        setState(() {
          _isDataLoading = false;
        });
        trellisRhythmsData.add(Trellis_principle_data_model_class(
          id : value['post_data']['id'].toString(),
          userId : value['post_data']['user_id'].toString(),
          type : value['post_data']['type'].toString(),
          empTruths : value['post_data']['emp_truths'].toString(),
          powerlessBelieves : value['post_data']['powerless_believes'].toString(),
          visibility : false,
        ));
        Navigator.of(context).pop();
        showToastMessage(context, "Rhythms added successfully", true);
        setState(() {
          empoweredTruthRhController.text = "";
          powerlessRhController.text = "";
        });
      //  Navigator.of(context).pop();
      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });
    } else {
      showToastMessage(context, "Add your data please", false);
    }
  }

  _setTrellisNeedsData () {

    if(needsController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager()
          .trellisIdentity(TrellisIdentityRequestModel(
              userId: id, type: "needs", text: needsController.text))
          .then((value) {
        // print("Needs Success");
        // print(value);
        trellisNeedsData.insert(0, value['post_data']);
        showToastMessage(context, "Needs added successfully", true);
        setState(() {
          needsController.text = "";
          _isDataLoading = false;
        });
        Navigator.of(context).pop();
      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });
    } else {
      showToastMessage(context, "Add your needs in the field", false);
    }
  }

  _setTrellisIdentityData () {

    if(identityController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager()
          .trellisIdentity(TrellisIdentityRequestModel(
              userId: id, type: "identity", text: identityController.text))
          .then((value) {
        // print("Identity Success");
        // print(value);
        trellisIdentityData.insert(0, value['post_data']);
        showToastMessage(context, "Identity added successfully", true);
        setState(() {
          _isDataLoading = false;
          identityController.text = "";
        });
        Navigator.of(context).pop();
      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });
    } else {
      showToastMessage(context, "Add your identity in the field", false);
    }
  }

  _setTribeData() {
    print(mentorNameController.text);
    print(peerNameController.text);
    print(menteeNameController.text);
    if(mentorNameController.text.isNotEmpty
        || peerNameController.text.isNotEmpty
        || menteeNameController.text.isNotEmpty)
    {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager()
          .trellisTribeScreen(TribeDataRequestModel(
          userId: id,
        mentor: mentorNameController.text,
        peer: peerNameController.text,
        mentee: menteeNameController.text,
      ))
          .then((value) {
            // print(value);
            Navigator.of(context).pop();
            setState(() {
              trellisTribeData.add(value['post_data']);
              mentorNameController.text = "";
            //  mentorDescriptionController.text = "";
              peerNameController.text = "";
             // peerDescriptionController.text = "";
              menteeNameController.text = "";
            //  menteeDescriptionController.text = "";
              _isDataLoading = false;
            });
        showToastMessage(context, "Tribe added successfully", true);

      })
          .catchError((e) {
        showToastMessage(context, e.toString(), false);
        // ignore: avoid_print
        print(e);
        setState(() {
          _isDataLoading = false;
        });
      });
    } else {
      showToastMessage(context, "Please fill your fields", false);
    }
  }

  _setTrellisData (bool isName) {
    // setState(() {
    //   _isDataLoading = true;
    // });

    if(nameController.text.isNotEmpty
    || descriptionController.text.isNotEmpty
    || purposeController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisScreen(TrellisDataRequestModel(
          userId: id,
          name: nameController.text,
          nameDescription: descriptionController.text,
          purpose: purposeController.text,
          mentor: mentorNameController.text,
        //  mentorDescription: mentorDescriptionController.text,
          peer: peerNameController.text,
         // peerDescription: peerDescriptionController.text,
          mentee: menteeNameController.text,
         // menteeDescription: menteeDescriptionController.text
      )).then((value) {
        // print(value);
        if(isName) {
          showToastMessage(
              context, "Name and Description added successfully", true);
        } else {
          showToastMessage(
              context, "Purpose added successfully", true);
        }
        setState(() {
          _isDataLoading = false;
        });

      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });
    } else {
      showToastMessage(context, "Please fill your fields", false);
    }
  }
}
