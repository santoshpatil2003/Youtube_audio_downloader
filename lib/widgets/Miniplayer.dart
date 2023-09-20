import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:just_audio/just_audio.dart';
import 'package:youtube_audio_download/widgets/CustomSeekBar.dart';
import 'package:youtube_audio_download/widgets/Music.dart';
// import 'package:youtube_audio_download/widgets/Seekbar.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
// import 'package:rxdart/rxdart.dart';

class PositionData {
  final Duration position;
  final Duration bufferedPosition;

  PositionData(this.position, this.bufferedPosition);
}

class MiniPlayer extends StatefulWidget {
  final String? imgurl;
  final String? musictitle;
  final bool? stream;
  // final ja.AudioPlayer? player;
  const MiniPlayer(
      {this.imgurl,
      // this.player,
      required this.stream,
      this.musictitle,
      super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  bool _play = true;
  AudioPlayer player = AudioPlayer();
  ja.PlayerState? playerstate;
  dynamic h;
  bool show = false;

  void _pause() async {
    if (_play == true) {
      setState(() {
        _play = false;
      });
      await player.pause();
    } else if (_play == false) {
      setState(() {
        _play = true;
      });
      await player.play();
    }
    // videometadata();
  }

//   Future<void> onSetRepeatMode(AudioServiceRepeatMode repeatMode) async {
//     switch (repeatMode) {
//       case AudioServiceRepeatMode.none:
//         await _player.setLoopMode(LoopMode.off);
//         break;
//       case AudioServiceRepeatMode.one:
//         await _player.setLoopMode(LoopMode.one);
//         break;
//       case AudioServiceRepeatMode.all:
//       case AudioServiceRepeatMode.group:
//         await _player.setLoopMode(LoopMode.all);
//         break;
//     }
//   }
// }

  Future<void> video(ja.AudioPlayer player) async {
    var yt = YoutubeExplode();
    try {
      var vid = yt.videos.get(widget.musictitle.toString());
      vid.then((value) async {
        var streamInfo =
            await yt.videos.streamsClient.getManifest(value.id.toString());
        var v = streamInfo.audioOnly.withHighestBitrate();
        await player.setUrl(v.url.toString());
        // await ja.LoopingAudioSource(child: , count: count)
        print(v.url.data);
        await player.setLoopMode(ja.LoopMode.one);
        await player.play();
        // await player.loopMode;
        yt.close();
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> Song(ja.AudioPlayer player) async {
    try {
      await player.setFilePath(widget.musictitle!);
      await player.setLoopMode(ja.LoopMode.one);
      await player.play();
      // print(player.duration.toString() +
      //     "   " +
      //     "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
      // player.createPositionStream().forEach((element) {
      //   print(element.toString() +
      //       "  " +
      //       "hwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww");
      // });
    } catch (e) {
      throw Exception(e);
    }
  }

  // Define the playlist
  final playlist = ConcatenatingAudioSource(
    // Start loading next item just before reaching it
    useLazyPreparation: true,
    // Customise the shuffle algorithm
    shuffleOrder: DefaultShuffleOrder(),
    // Specify the playlist items
    children: [
      AudioSource.uri(Uri.parse('https://example.com/track1.mp3')),
      AudioSource.uri(Uri.parse('https://example.com/track2.mp3')),
      AudioSource.uri(Uri.parse('https://example.com/track3.mp3')),
    ],
  );

// Load and play the playlist
// await player.setAudioSource(playlist, initialIndex: 0, initialPosition: Duration.zero);
// await player.seekToNext();                     // Skip to the next item
// await player.seekToPrevious();                 // Skip to the previous item
// await player.seek(Duration.zero, index: 2);    // Skip to the start of track3.mp3
// await player.setLoopMode(LoopMode.all);        // Set playlist to loop (off|all|one)
// await player.setShuffleModeEnabled(true);      // Shuffle playlist order (true|false)

// // Update the playlist
// await playlist.add(newChild1);
// await playlist.insert(3, newChild2);
// await playlist.removeAt(3);

  // videometadata() {
  //   var yt = YoutubeExplode();
  //   var vid = yt.videos.get('https://youtu.be/zytdU8haHlQ');

  //   // print(vid);
  //   vid.then((value) {
  //     print(value.title);
  //     print("---------------------------------------------------------------");
  //     print(value.thumbnails.highResUrl);
  //   });
  // }

  @override
  void initState() {
    // playerstate = player.playerState;
    widget.stream! ? video(player) : Song(player);
    // WidgetsBinding.instance.addPostFrameCallback((_) => Song(player));
    show = false;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MiniPlayer oldWidget) {
    if (oldWidget.musictitle == widget.musictitle) {
      return;
    } else {
      _play = true;
      widget.stream! ? video(player) : Song(player);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    h = size.height / 10;
  }

  void showf(Size size) {
    if (show) {
      setState(() {
        h = size.height / 10;
        show = false;
      });
    } else {
      setState(() {
        h = size.height / 4.5;
        show = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    playerstate = player.playerState;
    var yt = YoutubeExplode();
    if (widget.stream!) {
      return StreamBuilder<ja.PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            // final playing = playerState?.playing;

            return snapshot.hasError
                ? const Center(
                    child: Text("retry"),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).primaryColorDark,
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black87,
                                    spreadRadius: 0,
                                    blurRadius: 15,
                                    offset: Offset(0, 10)),
                              ]),
                          width: size.width / 1.03,
                          height: h,
                          child: FutureBuilder(
                              future: yt.videos.get(widget.musictitle),
                              builder: (context, snapshot) {
                                var data = snapshot.data;
                                // print(data!.title);
                                return snapshot.data == null
                                    ? Center(
                                        child: Container(
                                        margin: const EdgeInsets.all(8.0),
                                        width: 20.0,
                                        height: 20.0,
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ))
                                    : Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Container(
                                                  // color: Colors.black,
                                                  height: size.height / 11,
                                                  child: Center(
                                                    child: Container(
                                                      width: size.width / 5,
                                                      height: size.height / 1,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    10)),
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                              data!.thumbnails
                                                                  .highResUrl,
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: SizedBox(
                                                  height: size.height / 12,
                                                  width: size.width / 1.7,
                                                  child: Center(
                                                      child: Text(
                                                    data.title,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  )),
                                                ),
                                              ),
                                              SizedBox(
                                                child: IconButton(
                                                  onPressed: _pause,
                                                  icon: playerState
                                                                  ?.processingState !=
                                                              ja.ProcessingState
                                                                  .ready ||
                                                          processingState ==
                                                              ja.ProcessingState
                                                                  .loading ||
                                                          processingState ==
                                                              ja.ProcessingState
                                                                  .buffering
                                                      ? Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          width: 15.0,
                                                          height: 15.0,
                                                          child:
                                                              const CircularProgressIndicator(
                                                                  color: Colors
                                                                      .white),
                                                        )
                                                      : _play &&
                                                              playerState
                                                                      ?.playing ==
                                                                  true
                                                          ? const Icon(
                                                              Icons
                                                                  .pause_circle_outline_rounded,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : const Icon(
                                                              Icons
                                                                  .play_arrow_rounded,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              StreamBuilder<Duration?>(
                                                  stream: player.durationStream,
                                                  builder: (context, snapshot) {
                                                    final duration =
                                                        snapshot.data ??
                                                            Duration.zero;
                                                    return StreamBuilder<
                                                            Duration>(
                                                        stream: player
                                                            .positionStream,
                                                        builder:
                                                            (context, snap) {
                                                          final position =
                                                              snap.data ??
                                                                  Duration.zero;
                                                          return CustomSeekBar(
                                                            position: position,
                                                            duration: duration,
                                                          );
                                                        });
                                                  })
                                            ],
                                          )
                                        ],
                                      );
                              }),
                        ),
                      ),
                    ],
                  );
          });
    } else {
      // Song(widget.player!);
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // setState(() {
              //   print("click");
              //   h = size.height / 5.1;
              // });
              showf(size);
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColorDark,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black87,
                          spreadRadius: 0,
                          blurRadius: 15,
                          offset: Offset(0, 10)),
                    ]),
                width: size.width / 1.03,
                height: h,
                child: SizedBox(
                  child: Column(
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Container(
                                // color: Colors.black,
                                height: size.height / 11,
                                child: Center(
                                  child: Container(
                                    width: size.width / 5,
                                    height: size.height / 1,
                                    child: const Icon(
                                      Icons.audiotrack,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: SizedBox(
                                height: size.height / 12,
                                width: size.width / 1.7,
                                child: Center(
                                    child: Text(
                                  widget.musictitle!.split("/").last,
                                  style: const TextStyle(color: Colors.white),
                                )),
                              ),
                            ),
                            show
                                ? Container()
                                : SizedBox(
                                    child: IconButton(
                                      onPressed: _pause,
                                      icon: _play
                                          ? const Icon(
                                              Icons
                                                  .pause_circle_outline_rounded,
                                              color: Colors.white,
                                            )
                                          : const Icon(
                                              Icons.play_arrow_rounded,
                                              color: Colors.white,
                                            ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      show
                          ? Container()
                          : SizedBox(
                              child: Row(
                                children: [
                                  StreamBuilder<Duration>(
                                      stream: player.createPositionStream(),
                                      builder: (context, snapshot) {
                                        // print(snapshot.data.toString());
                                        return snapshot.data != null ||
                                                player.duration != null
                                            ? Container(
                                                height: size.height / 150,
                                                width: size.width / 1.05,
                                                // color: Colors.white,
                                                child: ProgressBar(
                                                  progressBarColor:
                                                      Colors.white,
                                                  thumbColor: Colors.white,
                                                  baseBarColor:
                                                      const Color.fromARGB(
                                                          78, 255, 255, 255),
                                                  total: player.duration ??
                                                      Duration.zero,
                                                  progress: snapshot.data ??
                                                      Duration.zero,
                                                  timeLabelTextStyle:
                                                      const TextStyle(
                                                          color: Colors.white),
                                                  thumbRadius: 0.0,
                                                  onSeek: (value) {
                                                    player.seek(value);
                                                  },
                                                ),
                                              )
                                            : Container();
                                      })
                                ],
                              ),
                            ),
                      show
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          StreamBuilder<Duration>(
                                              stream:
                                                  player.createPositionStream(),
                                              builder: (context, snapshot) {
                                                // print(snapshot.data.toString());
                                                return snapshot.data != null ||
                                                        player.duration != null
                                                    ? Container(
                                                        height:
                                                            size.height / 150,
                                                        width:
                                                            size.width / 1.05,
                                                        // color: Colors.white,
                                                        child: ProgressBar(
                                                          progressBarColor:
                                                              Colors.white,
                                                          thumbColor:
                                                              Colors.white,
                                                          baseBarColor:
                                                              const Color
                                                                      .fromARGB(
                                                                  78,
                                                                  255,
                                                                  255,
                                                                  255),
                                                          total:
                                                              player.duration ??
                                                                  Duration.zero,
                                                          progress:
                                                              snapshot.data ??
                                                                  Duration.zero,
                                                          timeLabelTextStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                          thumbRadius: 5.0,
                                                          onSeek: (value) {
                                                            player.seek(value);
                                                          },
                                                        ),
                                                      )
                                                    : Container();
                                              })
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 22.5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: RotatedBox(
                                              quarterTurns: 2,
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.play_arrow_outlined,
                                                  size: 40,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {},
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: IconButton(
                                              icon: _play
                                                  ? const Icon(
                                                      Icons
                                                          .pause_circle_outline_rounded,
                                                      size: 40,
                                                      color: Colors.white,
                                                    )
                                                  : const Icon(
                                                      Icons.play_arrow_rounded,
                                                      size: 40,
                                                      color: Colors.white,
                                                    ),
                                              onPressed: _pause,
                                            ),
                                          ),
                                          Container(
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.play_arrow_outlined,
                                                size: 40,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {},
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                )),
          ),
        ],
      );
    }
  }
}
