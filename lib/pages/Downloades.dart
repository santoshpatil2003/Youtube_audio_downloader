import 'dart:io';

// import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:youtube_audio_download/data/data.dart';
import 'package:youtube_audio_download/widgets/Music.dart';

// import '../widgets/Miniplayer.dart';

class Downloades extends StatefulWidget {
  final Function? playlists;
  final Function? player;
  const Downloades({this.playlists, this.player, super.key});

  @override
  State<Downloades> createState() => _DownloadesState();
}

class _DownloadesState extends State<Downloades> {
  final List<FileSystemEntity> _songs = [];
  // final List<FileSystemEntity> _songsPlay = [];
  final bool animation = false;
  int? chosenone;
  AudioPlayer player = AudioPlayer();
  getMusic() async {
    List<FileSystemEntity> _files;
    Directory? f = Directory("/storage/emulated/0/Download");
    if (await f.exists()) {
      print("directory exists");
      _files = f.listSync(recursive: true, followLinks: false);
      print(_files.length);
      _files.where((e) => e.path.endsWith(".mp3")).forEach((element) {
        _songs.add(element);
        print(element.path);
      });
      setState(() {});
    } else {
      print("file does not exist");
    }
  }

  @override
  void initState() {
    getMusic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Downloades");
    final provider = Provider.of<Data>(context);
    final ch = provider.chose;
    final chf = provider.change;
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: SizedBox(
        child: Column(
          children: [
            SizedBox(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _songs.length,
                  itemBuilder: (BuildContext context, index) {
                    List s = _songs[index].absolute.path.split("/");
                    return GestureDetector(
                      onTap: () {
                        print(index);
                        player.stop();
                        widget.player!(true, _songs[index].path, false);
                        chf(index);
                        // setState(() {
                        //   chosenone = index;
                        // });
                      },
                      child: InkWell(
                        child: IgnorePointer(
                          child: Music(
                            choosen: ch,
                            index: index,
                            fname: s.last.toString(),
                            player: widget.player,
                            p: player,
                            songs: _songs,
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Container(
              color: Theme.of(context).primaryColorDark,
              height: size.height / 11,
              width: size.width,
            ),
            // _play
            //     ? SizedBox(
            //         height: size.height / 1.24,
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.end,
            //           children: [
            //             MiniPlayer(
            //               // player: player,
            //               musictitle: _songsPlay[0].path,
            //               stream: false,
            //             ),
            //           ],
            //         ),
            //       )
            //     : Container(),
          ],
        ),
      ),
    );
  }
}
