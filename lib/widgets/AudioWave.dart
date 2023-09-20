import 'package:flutter/material.dart';
import 'package:music_visualizer/music_visualizer.dart';
import 'package:youtube_audio_download/widgets/MusicVisualiser2.dart';

class AudioWave extends StatefulWidget {
  AudioWave({super.key});

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  // late AnimationController _controller;
  final List<Color> colors = [
    Colors.white,
    Colors.white,
    Colors.white,
    // Colors.red[900]!,
    // Colors.green[900]!,
    // Colors.blue[900]!,
    // Colors.brown[900]!
  ];

  final List<int> duration = [900, 700, 600, 800, 500];

  // @override
  // void initState() {
  //   _controller =
  //       MusicVisualizer(colors: colors, duration: duration, barCount: 3)
  //           as AnimationController;
  //   super.initState();
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      // color: Colors.white,
      width: size.width / 12,
      height: size.height / 25,
      child: MusicVisualizer2(
        barCount: 3,
        colors: colors,
        duration: duration,
      ),
    );
  }
}
