import "package:flutter/material.dart";

class MusicVisualizer2 extends StatelessWidget {
  final List<Color> colors;
  final List<int> duration;
  final int barCount;
  final Curve curve;

  const MusicVisualizer2({
    Key? key,
    required this.colors,
    required this.duration,
    required this.barCount,
    this.curve = Curves.easeInQuad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        barCount,
        (index) => VisualComponent2(
          curve: curve,
          duration: duration[index % 5],
          color: colors[index % 4],
        ),
      ),
    );
  }
}

class VisualComponent2 extends StatefulWidget {
  final int duration;
  final Color color;
  final Curve curve;

  const VisualComponent2({
    Key? key,
    required this.duration,
    required this.color,
    required this.curve,
  }) : super(key: key);

  @override
  _VisualComponent2State createState() => _VisualComponent2State();
}

class _VisualComponent2State extends State<VisualComponent2>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(milliseconds: widget.duration),
      vsync: this,
    );
    final curvedAnimation =
        CurvedAnimation(parent: animationController, curve: widget.curve);
    animation = Tween<double>(begin: 0, end: 50).animate(curvedAnimation)
      ..addListener(() {
        if (mounted) setState(() {});
      });
    animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: animation.value,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
