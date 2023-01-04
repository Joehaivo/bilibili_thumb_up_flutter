import 'dart:math' as math;

import 'package:flutter/material.dart';

class TripleHitButton extends StatefulWidget {
  const TripleHitButton({Key? key}) : super(key: key);

  @override
  State<TripleHitButton> createState() => _TripleHitButtonState();
}

class _TripleHitButtonState extends State<TripleHitButton>
    with SingleTickerProviderStateMixin {
  // 点赞、硬币、收藏的状态
  bool _thumbed = false;
  bool _coined = false;
  bool _stared = false;

  // 点赞、硬币、收藏数
  int _thumbCounter = 66;
  int _coinCounter = 77;
  int _starCounter = 88;

  // 播放一键三连动画的控制器
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    // 动画插值器的起止范围，从0-2π
    _animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_controller)
      // 添加监听器，每次数值改变时，刷新界面
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        // 当动画播放完毕时，改变三个按钮的状态, 并重置动画控制器
        if (status == AnimationStatus.completed) {
          setState(() {
            _thumbed = true;
            _coined = true;
            _stared = true;
            _thumbCounter += 1;
            _coinCounter += 1;
            _starCounter += 1;
            _controller.reset();
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      // 点赞组件
      GestureDetector(
        onTap: () => {
          setState(() {
            _thumbed = true;
            _thumbCounter += 1;
          })
        },
        onLongPressStart: (LongPressStartDetails detail) =>
            {_controller.forward()},
        onLongPressUp: () => {
          if (!_animation.isCompleted) {_controller.reverse()},
        },
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Icon(
              Icons.thumb_up,
              size: 50,
              color: _thumbed
                  ? const Color(0xfffe669b)
                  : const Color(0xff60676a),
            ),
          ),
          Text(_thumbCounter.toString())
        ]),
      ),
      // 投币组件
      GestureDetector(
          onTap: () => {
                setState(() {
                  _coined = true;
                  _coinCounter += 1;
                })
              },
          child: AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget? child) {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Column(
                  children: [
                    CustomPaint(
                      painter: _ArcPainter(-_animation.value),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(
                          Icons.account_circle,
                          size: 50,
                          color: _coined
                              ? const Color(0xfffe669b)
                              : const Color(0xff60676a),
                        ),
                      ),
                    ),
                    Text(_coinCounter.toString())
                  ],
                ),
              );
            },
          )),
      // 收藏组件
      GestureDetector(
          onTap: () => {
                setState(() {
                  _stared = true;
                  _starCounter += 1;
                })
              },
          child: AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget? child) {
              return Column(
                children: [
                  CustomPaint(
                    painter: _ArcPainter(-_animation.value),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.star,
                        size: 50,
                        color: _stared
                            ? const Color(0xfffe669b)
                            : const Color(0xff60676a),
                      ),
                    ),
                  ),
                  Text(_starCounter.toString())
                ],
              );
            },
          )),
    ]);
  }
}

// 绘制一键三连圆弧
class _ArcPainter extends CustomPainter {
  double sweepAngle;

  _ArcPainter(this.sweepAngle);

  @override
  void paint(Canvas canvas, Size size) {
    // 从-π/2开始到sweepAngle范围
    canvas.drawArc(
        Rect.fromLTRB(0, 0, size.width, size.height),
        -math.pi / 2,
        sweepAngle,
        false,
        Paint()
          ..color = const Color(0xfffe669b)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
