import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:youtube_audio_download/data/data.dart';
import 'package:youtube_audio_download/widgets/AudioWave.dart';

class Music extends StatefulWidget {
  final int? choosen;
  final String? fname;
  final Function? player;
  final AudioPlayer? p;
  final List? songs;
  final int? index;
  const Music(
      {required this.choosen,
      this.index,
      this.songs,
      this.p,
      this.player,
      required this.fname,
      super.key});

  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
  bool wave = false;
  // late Data d;

  // @override
  // void didUpdateWidget(covariant Music oldWidget) {
  //   if(widget.ani != oldWidget.ani){

  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    // if(widget.choosen == widget.index){
    //   d = Data(true, widget.choosen!);
    // }
    // Data d = Data(false, widget.choosen!);
    return Card(
        color: Theme.of(context).cardColor,
        child: ListTile(
          title: Text(
            widget.fname!.split(".").first,
            style: const TextStyle(color: Colors.white),
          ),
          //  Text(files[index].path.split('/').last),
          leading: const Icon(
            Icons.audiotrack,
            color: Colors.white,
          ),
          trailing:
              widget.choosen == widget.index ? AudioWave() : const SizedBox(),
          // onTap: () {
          //   // widget.p!.stop();
          //   // widget.player!(true, widget.songs![widget.index!].path, false);
          //   // setState(() {
          //   //   wave = true;
          //   // });
          // },
        ));
  }
}
