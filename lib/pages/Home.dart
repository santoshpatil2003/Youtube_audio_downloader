import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:youtube_audio_download/data/data.dart';
// import 'package:youtube_audio_download/widgets/Seekbar.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class Home extends StatefulWidget {
  final Function? player;
  final String? restorationid;
  const Home({this.restorationid, this.player, super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // bool _play = false;
  bool show = false;
  bool error = false;
  bool? loading;
  bool Httperror = false;
  bool re = false;
  late TextEditingController _controller;
  var yt = YoutubeExplode();
  double dp = 0;

  ReceivePort receivePort = ReceivePort();

  getdire(videoUrl) async {
    Directory? f = Directory("/storage/emulated/0/Youtube_audio_downloads");

    f.create(recursive: true).then((value) {
      fetchAudioStreamUrl(videoUrl, value);
    }).onError((error, stackTrace) {
      print(error);
    });
  }

  Future<void> downloadAudio(String audiourl, Directory directory, name) async {
    await Permission.audio.request();
    await Permission.manageExternalStorage.request();
    PermissionStatus status = await Permission.audio.status;
    if (status.isGranted) {
      try {
        if (await directory.exists()) {
          // print("Directory does exist");
          try {
            await Dio().download(audiourl, '${directory.path}/$name.mp3',
                onReceiveProgress: (count, total) {
              // print(count.toString() + "/" + total.toString());
              setState(() {
                // dp = ((count / total) * 100) as RestorableDouble;
                dp = ((count / total) * 100);
              });
            }, deleteOnError: true, cancelToken: CancelToken()).then((_) {
              print(
                  'Audio download successful! Path: ${'${directory.path}/$name.mp3'}');
            }).onError((error, stackTrace) {
              setState(() {
                error = true;
                loading = false;
              });
            });
          } on DioException catch (e) {
            print(e);
          }
        } else {
          throw ("Directory does not exist");
        }
      } catch (e) {
        setState(() {
          error = true;
        });
        throw ('Error downloading audio: $e');
      }
    }
  }

  Future<void> downloadAudio2(
      String audiourl, Directory directory, name) async {
    await Permission.audio.request();
    // await Permission.requestInstallPackages.request();
    await Permission.manageExternalStorage.request();
    PermissionStatus status = await Permission.audio.status;
    // PermissionStatus status2 = await Permission.requestInstallPackages.status;
    if (status.isGranted) {
      try {
        // print('Audio');
        // print(directory.path);
        if (await directory.exists()) {
          try {
            await FlutterDownloader.enqueue(
              url: audiourl,
              // headers: {},optional: header send with url (auth token etc)
              savedDir: directory.path,
              fileName: "$name.mp3",
              showNotification: true,
              openFileFromNotification: true,
              saveInPublicStorage: true,
              allowCellular: true,
            ).then((value) {
              setState(() {
                loading = false;
              });
            }).onError((error, stackTrace) {
              setState(() {
                error = true;
                loading = false;
              });
              return null;
            });
          } on FlutterDownloaderException catch (e) {
            setState(() {
              error = true;
            });
            throw e;
          }
        } else {
          throw ("Directory does not exist");
        }
      } catch (e) {
        setState(() {
          error = true;
        });
        throw ('Error downloading audio: $e');
      }
    }
  }

  Future<String?> fetchAudioStreamUrl(String videoUrl, directory) async {
    var streamUrl;
    try {
      var yt = YoutubeExplode();
      var vid = yt.videos.get(videoUrl.toString());
      vid.then((value) async {
        loading = true;
        var streamInfo = await yt.videos.streamsClient
            .getManifest(value.id.toString())
            .onError((error, stackTrace) {
          setState(() {
            Httperror = true;
          });
          throw error!;
        });
        var v = streamInfo.audioOnly.withHighestBitrate();
        streamUrl = v.url.toString();
        yt.close();
        downloadAudio2(streamUrl, directory, value.title);
      });
    } catch (e) {
      throw ('Error fetching audio stream URL: $e');
      // return null;
    }
    return streamUrl;
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    // print("init " * 10);
  }

  @pragma('vm:entry-point')
  static downloadcallback(id, status, progress) {
    // print(" $id , $status , $progress");
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");
    sendPort!.send([id, status, progress]);
  }

  @override
  void didChangeDependencies() {
    final provider = Provider.of<Data>(context, listen: false);
    final search = provider.search;
    _controller = TextEditingController(text: search);
    super.didChangeDependencies();
    IsolateNameServer.registerPortWithName(receivePort.sendPort, "downloading");
    // print("start " * 10);
    receivePort.listen((message) {
      // print("cbbacbjnc        " * 10);
      if (message[2] == -1) {
      } else {
        setState(() {
          dp = message[2].toDouble();
        });
        if (message[2] == 100) {
          setState(() {
            loading = false;
          });
        }
        // print(message);
      }
    });
    FlutterDownloader.registerCallback(downloadcallback);
  }

  portcall() async {
    IsolateNameServer.registerPortWithName(receivePort.sendPort, "downloading");
    // print("run" * 10);
    receivePort.listen((message) {
      setState(() {
        dp = message[2].toDouble();
      });
    });
    FlutterDownloader.registerCallback(downloadcallback);
  }

  @override
  void dispose() {
    _controller.dispose();
    IsolateNameServer.removePortNameMapping('downloading');
    super.dispose();
  }

  refresh() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<Data>(context, listen: false);
    final search = provider.search;
    final sh = provider.show;
    // print(search);
    final searchf = provider.sea;
    return SingleChildScrollView(
      child: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: (() => refresh()),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width / 1.1,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: TextFormField(
                          onFieldSubmitted: (v) {
                            // search.isRegistered
                            //     ? search.value = v
                            //     : print("not registered");
                            // search = v;
                            searchf(v);
                            // print(search);
                            setState(() {
                              // _play = false;
                              show = true;
                            });
                          },
                          controller: _controller,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Add music link from youtube',
                              hintStyle:
                                  TextStyle(color: Colors.grey.shade600)),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                // show && search.isRegistered && search.value != null
                sh
                    ? FutureBuilder(
                        future: yt.videos.get(search.toString()),
                        builder: (context, snapshot) {
                          var data = snapshot.data;
                          return snapshot.data == null
                              ? Center(
                                  child: Container(
                                  margin: const EdgeInsets.all(8.0),
                                  width: 20.0,
                                  height: 20.0,
                                  child: const CircularProgressIndicator(),
                                ))
                              : Container(
                                  // color: Colors.amber,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: size.width / 1.09,
                                        height: size.height / 4.1,
                                        // color: Colors.black,
                                        // child: Image.network(widget.imgurl!),
                                        decoration: BoxDecoration(
                                          // color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                data!.thumbnails.highResUrl,
                                              )),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              width: size.width / 3,
                                              child: FloatingActionButton(
                                                backgroundColor:
                                                    Theme.of(context).cardColor,
                                                onPressed: () {
                                                  // setState(() {
                                                  //   _play = true;
                                                  // });
                                                  widget.player!(
                                                      true, search, true);
                                                },
                                                child: Text(
                                                  "Play",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .hintColor),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width / 3,
                                              child: FloatingActionButton(
                                                backgroundColor:
                                                    Theme.of(context).cardColor,
                                                onPressed: () {
                                                  // var u =
                                                  getdire(search);
                                                  // print(u.toString() +
                                                  //     "     " +
                                                  //     "outside");
                                                  // u.then((value) {
                                                  //   print(value.toString() +
                                                  //       "     " +
                                                  //       "outside");
                                                  // });
                                                  setState(() {
                                                    error = false;
                                                    Httperror = false;
                                                  });
                                                },
                                                child: Text(
                                                  "Download",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .hintColor),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: size.width / 1.2,
                                              child: FloatingActionButton(
                                                backgroundColor:
                                                    Theme.of(context).cardColor,
                                                onPressed: () {
                                                  // setState(() {
                                                  //   _play = true;
                                                  // });
                                                },
                                                child: Text(
                                                  "Listen While Downloading",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .hintColor),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                        })
                    : Container(),
                // CustomSeekBar(duration: 50, position: 100),
                error
                    ? SizedBox(
                        width: size.width,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 30),
                                width: size.width / 1.5,
                                child: const Text(
                                    "Sorry for the inconvinence, this might be a Network issue, please Download it again"),
                              )
                            ]),
                      )
                    : Httperror == true
                        ? SizedBox(
                            width: size.width,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 30),
                                    width: size.width / 1.5,
                                    child: const Text(
                                      "There is some Server issue, try it again",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ]),
                          )
                        : (loading != null)
                            ? Downloader(
                                size: size,
                                dp: dp,
                                receivePort: receivePort,
                              )
                            : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Downloader extends StatelessWidget {
  const Downloader({
    super.key,
    this.receivePort,
    required this.size,
    required this.dp,
  });
  final ReceivePort? receivePort;
  final Size size;
  final double dp;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size.width,
        height: size.height / 10,
        // color: Colors.red,
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // : SizedBox(
            //     width: size.width,
            //     child: LinearProgressIndicator(
            //       backgroundColor: Colors.white,
            //       valueColor: AlwaysStoppedAnimation(
            //           Colors.grey),
            //       value: dp.round().toDouble(),
            //       minHeight: 60,
            //     ),
            //   )
            Column(
              children: [
                // SeekBar(
                //   duration: dp.round().toDouble(),
                // ),
                Text(
                  "${dp.round()}%",
                  style: const TextStyle(color: Colors.cyan),
                ),
              ],
            ),
          ],
        ));
  }
}
