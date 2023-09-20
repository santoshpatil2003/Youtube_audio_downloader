// import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
// import 'dart:js_interop';

// import 'package:dio/dio.dart';
// import 'dart:js_interop';

// import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:youtube_audio_download/data/data.dart';
import 'package:youtube_audio_download/pages/Downloades.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_audio_download/pages/Home.dart';
import 'package:youtube_audio_download/widgets/Miniplayer.dart';
// import 'package:youtube_audio_download/widgets/Miniplayer.dart';
// import 'package:youtube_audio_download/widgets/search.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';
// import 'package:http/http.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:http/http.dart' as http;
// import 'package:youtube_explode_dart/youtube_explode_dart.dart' as youtube;
// import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Plugin must be initialized before using
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Data(),
      child: MaterialApp(
        title: 'Flutter Demo',
        restorationScopeId: "app",
        theme: ThemeData(
          primaryColorDark: Colors.black,
          scaffoldBackgroundColor: Colors.black,
          cardColor: Colors.black,
          hintColor: Colors.white,
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Music Downloader'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _play = true;
  bool? stream;
  // bool show = false;
  bool repeate = false;
  String? search = "/Song";
  // var yt = YoutubeExplode();
  // double dp = 0;
  // List? screens;
  Function? f;
  int _currentIndex = 0;
  List playlist = [];

  // final player = AudioPlayer();
  // late TextEditingController _controller;
  // Theme.of(context).colorScheme.inversePrimary
  playlis(List playl) {
    setState(() {
      playlist = playl;
    });
  }

  playerstart(bool b, String sea, bool str) {
    setState(() {
      // playlist = playl;
      _play = b;
      search = sea;
      stream = str;
    });
  }

  // screens = [
  //   Home(),
  //   Downloades(
  //     player: f,
  //   )
  // ];

  // @override
  // void initState() {
  //   f = playerstart;
  //   screens = [
  //     Home(),
  //     Downloades(
  //       player: f,
  //     )
  //   ];
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var screens = [
      Home(
        restorationid: "home",
        player: playerstart,
      ),
      Downloades(
        player: playerstart,
      )
    ];
    // getdire();
    // final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  repeate = !repeate;
                });
              },
              icon: Icon(
                repeate ? Icons.repeat_on_rounded : Icons.repeat_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: Stack(children: [
        screens[_currentIndex],
        _play
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Container(
                  //   color: Colors.white,
                  //   height: size.height / 10,
                  //   width: size.width,
                  // ),
                  stream == null
                      ? Container()
                      : MiniPlayer(
                          // player: player,
                          musictitle: search,
                          stream: stream,
                        ),
                ],
              )
            : Container(),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: Theme.of(context).primaryColorDark,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.5),
        onTap: (value) {
          // Respond to item press.
          setState(() => _currentIndex = value);
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Downloads',
            icon: Icon(Icons.download_sharp),
          ),
        ],
      ),
    );
  }
}
