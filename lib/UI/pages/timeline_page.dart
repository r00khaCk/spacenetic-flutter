import 'package:flutter/material.dart';
import 'package:spacenetic_flutter/Classes/timeline/space_event.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
// import '../Classes/timeline/space_event.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final PageController pageController =
      PageController(initialPage: 1, keepPage: true);
  int pageIx = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Center(child: Text("Space Exploration Timeline")),
      ),
      // body: PageView(
      //   onPageChanged: (i) => setState(() => pageIx = i),
      //   controller: pageController,
      //   children: pages,
      // ),
      body: Container(
          child: timelineModel(TimelinePosition.Center),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/main-bg.png"),
              fit: BoxFit.cover,
            ),
          )),
    );
  }

  timelineModel(TimelinePosition position) => Timeline.builder(
        lineColor: Colors.blueAccent,
        itemBuilder: centerTimeBuilder,
        itemCount: spaceEvents.length,
        physics: position == TimelinePosition.Center
            ? ClampingScrollPhysics()
            : BouncingScrollPhysics(),
        position: position,
      );

  TimelineModel centerTimeBuilder(BuildContext context, int i) {
    final spaceEvent = spaceEvents[i];
    final textTheme = Theme.of(context).textTheme;
    return TimelineModel(
        Card(
          color: Color.fromARGB(1, 43, 45, 66),
          margin: EdgeInsets.symmetric(vertical: 50.0, horizontal: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  spaceEvent.eventImage,
                  height: 150,
                  width: 150,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(spaceEvent.year, style: textTheme.titleMedium),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  spaceEvent.eventDescription,
                  style: textTheme.bodySmall,
                ),
                const SizedBox(
                  height: 8.0,
                )
              ],
            ),
          ),
        ),
        position:
            i % 2 == 0 ? TimelineItemPosition.right : TimelineItemPosition.left,
        isFirst: i == 0,
        isLast: i == spaceEvents.length,
        iconBackground: spaceEvent.iconbackground,
        icon: spaceEvent.icon);
  }
}
