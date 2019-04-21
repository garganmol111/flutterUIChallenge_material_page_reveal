import 'dart:async';

import 'package:flutter/material.dart';
import 'pages.dart';
import 'page_reveal.dart';
import 'pager_indicator.dart';
import 'page_dragger.dart';

class MaterialPageReveal extends StatefulWidget {
  MaterialPageReveal({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MaterialPageRevealState createState() => _MaterialPageRevealState();
}

class _MaterialPageRevealState extends State<MaterialPageReveal> with TickerProviderStateMixin{

  StreamController<SlideUpdate> slideUpdateStream;
  AnimatedPageDragger animatedPageDragger;

  int activeIndex = 0;
  int nextPageIndex = 0;
  SlideDirection slideDirection = SlideDirection.none;
  double slidePercent = 0.0;

  _MaterialPageRevealState() {
    slideUpdateStream = new StreamController<SlideUpdate>();

    slideUpdateStream.stream.listen((SlideUpdate event) {
      setState(() {
        if(event.updateType == UpdateType.dragging) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

          if(slideDirection == SlideDirection.leftToRight) {
            nextPageIndex = activeIndex - 1;
          } else if(slideDirection == SlideDirection.rightToLeft) {
            nextPageIndex = activeIndex + 1;
          } else {
            nextPageIndex = activeIndex;
          }

        } else if(event.updateType == UpdateType.doneDragging) {
          if(slidePercent > 0.5) {
            animatedPageDragger = new AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.open,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this ,
            );
          } else {
            animatedPageDragger = new AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.close,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this ,
            );

            nextPageIndex = activeIndex;
          }

          animatedPageDragger.run();
        } else if (event.updateType == UpdateType.animating) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;
        } else if(event.updateType == UpdateType.doneAnimating) {
          print('Done animating. Next page index: $nextPageIndex');
          activeIndex = nextPageIndex;

          slideDirection = SlideDirection.none;
          slidePercent = 0.0;

          animatedPageDragger.dispose();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        new Page(
          viewModel: pages[activeIndex],
          percentVisible: 1.0,
        ),
        PageReveal(
          revealPercent: slidePercent, 
          child: new Page(
            viewModel: pages[nextPageIndex],
            percentVisible: slidePercent,
          ),
        ),
        new PagerIndicator(
          viewModel: new PagerIndicatorViewModel(
            activeIndex, 
            pages,  
            slideDirection,
            slidePercent,
          ),
        ),
        new PageDragger(
          canDragLefttoRight: activeIndex > 0,
          canDragRightToLeft: activeIndex < pages.length - 1,
          slideUpdateStream: slideUpdateStream,
        )
      ],
    ));
  }
}

