import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarouselWidget extends StatefulWidget {
  final List<String> imageUrls;

  const CarouselWidget({super.key, required this.imageUrls});

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  late final PageController _controller;
  late Timer _timer;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (widget.imageUrls.isEmpty) return;
      setState(() {
        currentIndex = (currentIndex + 1) % widget.imageUrls.length;
        _controller.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 328.w,
      height: 185.h,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            child: Image.network(widget.imageUrls[index], fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}
