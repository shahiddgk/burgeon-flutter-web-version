// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

// ignore: must_be_immutable
class VideoPlayer extends StatefulWidget {
   VideoPlayer(this.name,this.userId,this.videoId,{Key? key}) : super(key: key);

   String name;
   String userId;
   String videoId;

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}



class _VideoPlayerState extends State<VideoPlayer> {

    late final YoutubePlayerController _playerController;
    late bool isPhone;

  @override
  void initState() {
    // TODO: implement initState
    _playerController = YoutubePlayerController(
      params: const YoutubePlayerParams(
      showControls: true,
      mute: false,
      showFullscreenButton: true,
      loop: false,
        strictRelatedVideos: true,
        enableJavaScript: true,
    ))..onInit = () {
      _playerController.loadVideo( widget.videoId);
      _playerController.stopVideo();
    };
    // _playerController = YoutubePlayerController(
    //     initialVideoId: widget.videoId,
    //   flags: const YoutubePlayerFlags(
    //     autoPlay: false,
    //     controlsVisibleAtStart: false,
    //   )
    //
    // );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _playerController.close();
    super.dispose();
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
    return Scaffold(
      appBar: AppBarWidget().appBarGeneralButtons(
          context,
              () {
            Navigator.of(context).pop();
          }, true, true, true, widget.userId, true,true,0,false,0),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: YoutubePlayerControllerProvider(
            controller: _playerController,
            child: YoutubePlayer(controller: _playerController),
        ),
      ),
    );
  }
}
