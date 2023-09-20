import 'package:flutter/material.dart';

class CustomSeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  const CustomSeekBar(
      {required this.duration, required this.position, super.key});

  @override
  State<CustomSeekBar> createState() => _CustomSeekBarState();
}

class _CustomSeekBarState extends State<CustomSeekBar> {
  tosec(p) {
    // var p = widget.position;
    // var d = widget.duration;
    double m1 = double.parse(p.toString().split(":")[1]);
    double s1 = m1 * 60;
    double m2 = double.parse(p.toString().split(":")[2]);
    double s2 = m2;
    double total = s1 + s2;
    // print(total);
    return total;
  }

  double wi(size) {
    var p = widget.position;
    var d = widget.duration;
    double tpercent = (p.inSeconds / d.inSeconds) * 100;
    double fw = size.width / 1.05;
    double w = ((tpercent / 100) * fw).isNaN ? 0 : (tpercent / 100) * fw;
    return w;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 3, right: 0),
      child: Container(
        height: 3,
        width: size.width / 1.04,
        color: Theme.of(context).primaryColorDark,
        child: Row(
          children: [
            Container(
              height: 3,
              width:
                  wi(size) > size.width / 1.02 ? size.width / 1.02 : wi(size),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

// class Bar extends StatefulWidget {
//   const Bar({super.key});

//   @override
//   State<Bar> createState() => _BarState();
// }

// class _BarState extends State<Bar> {
//   double wi(size) {
//     return size.width / 1.02;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Row(
//       children: [
//         Container(
//           height: 3,
//           width: wi(size),
//           color: Colors.white,
//         ),
//       ],
//     );
//   }
// }
