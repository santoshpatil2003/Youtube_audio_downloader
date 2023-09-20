import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Search extends StatefulWidget {
  final String title;
  final bool? play;
  const Search({required this.title, this.play, super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var yt = YoutubeExplode();
    return FutureBuilder(
        future: yt.videos.get(widget.title),
        builder: (context, snapshot) {
          var data = snapshot.data;
          return snapshot.data == null
              ? Center(
                  child: Container(
                  margin: EdgeInsets.all(8.0),
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
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                data!.thumbnails.highResUrl,
                              )),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width / 3,
                              child: FloatingActionButton(
                                onPressed: () {},
                                child: Text("Play"),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        });
  }
}
