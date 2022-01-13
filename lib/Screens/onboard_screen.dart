// ignore_for_file: unused_element, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:foodie_app/constants.dart';

class OnBoardScreen extends StatefulWidget {
  OnBoardScreen({Key? key}) : super(key: key);

  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

final _controller = PageController(initialPage: 0);
int _currentPage = 0;

List<Widget> _pages = [
  Column(
    children: [
      Expanded(child: Image.asset('images/enteraddress.png')),
      Text(
        'Set Your Delivery  Location',
        style: kPageViewTextStyle,
      )
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('images/orderfood.png')),
      Text(
        'Order online from your Favourite Store',
        style: kPageViewTextStyle,
      )
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('images/deliverfood.png')),
      Text(
        'Quick Deliver to your Doorstep',
        style: kPageViewTextStyle,
      )
    ],
  ),
];

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _controller,
            children: _pages,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        DotsIndicator(
          dotsCount: _pages.length,
          position: _currentPage.toDouble(),
          decorator: DotsDecorator(
            size: Size.square(9.0),
            activeSize: Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            activeColor: Colors.deepOrange,
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
