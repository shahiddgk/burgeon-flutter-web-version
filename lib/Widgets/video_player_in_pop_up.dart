import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'colors.dart';

Future videoPopupDialog(BuildContext context,String title, YoutubePlayerController playerController0,) {
  return showDialog(context: context,
      builder: (context) {
        return  AlertDialog(
          backgroundColor: AppColors.lightGreyColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          title: Align(alignment: Alignment.centerRight,
          child:  InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.cancel)),),
          content:  Container(
            height: MediaQuery.of(context).size.height/2,
            width: MediaQuery.of(context).size.width/2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.backgroundColor,
            ),
           // padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
            child:SizedBox(
              height: MediaQuery.of(context).size.height/2,
              width: MediaQuery.of(context).size.width/2,
              child: YoutubePlayerControllerProvider(
                controller: playerController0,
                child: YoutubePlayer(controller: playerController0),
              ),
            ),
          ),
        );
      });
}