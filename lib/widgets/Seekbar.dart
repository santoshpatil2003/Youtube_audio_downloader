import 'package:flutter/material.dart';

class SeekBar extends StatefulWidget {
  final double duration;
  final Duration? position;
  final Duration? bufferedPosition;
  final ValueChanged<Duration?>? onChanged;
  final ValueChanged<Duration?>? onChangeEnd;
  const SeekBar(
      {required this.duration,
      this.position,
      this.bufferedPosition,
      this.onChanged,
      this.onChangeEnd,
      super.key});

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double a = 0;
  double wi(size) {
    double tpercent = widget.duration;
    double fw = size.width / 1.2;
    double w = ((tpercent / 100) * fw).isNaN ? 0 : (tpercent / 100) * fw;
    return w;
  }

  @override
  void didUpdateWidget(covariant SeekBar oldWidget) {
    print(widget.duration);
    print(oldWidget.duration);
    if (widget.duration != oldWidget.duration) {
      setState(() {
        a = widget.duration;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // print(wi(size));
    final size = MediaQuery.of(context).size;
    print(wi(size));
    return Container(
      // color: Colors.white,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(50)),
      width: size.width / 1.1,
      height: size.height / 160,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.cyan, borderRadius: BorderRadius.circular(50)),
        width: wi(size),
        height: size.height / 25,
      ),
    );
  }
}
