import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FitStopwatch extends StatefulWidget {
  const FitStopwatch({Key? key}) : super(key: key);

  @override
  State<FitStopwatch> createState() => _FitStopwatchState();
}

class _FitStopwatchState extends State<FitStopwatch> {
  final stopwatch = StopWatchTimer();
  final isHours = true;
  final scrollController = ScrollController();

  int time = 0;
  int buttonsState = 0;

  // SharedPreferences package for storing stopwatch state/time when killed
  @override
  void initState() async {
    super.initState();
    loadIdle();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stopwatch.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Stopwatch'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // **********************************************************
            // STOPWATCH DISPLAY
            // **********************************************************
            StreamBuilder<int>(
                stream: stopwatch.rawTime,
                //initialData: stopwatch.rawTime.value,
                initialData: loadTime(),
                builder: (context, snapshot) {
                  final value = snapshot.data;
                  final displayTime =
                      StopWatchTimer.getDisplayTime(value!, hours: isHours);
                  return Text(
                    displayTime,
                    style: const TextStyle(
                      fontSize: 60.0,
                      fontWeight: FontWeight.normal,
                    ),
                  );
                }),

            //divider
            const SizedBox(
              height: 20.0,
            ),

            // **********************************************************
            // BUTTONS FOR CONTROLLING STOPWATCH
            // **********************************************************
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: giveButtons(),
            ),

            //divider
            const SizedBox(
              height: 20.0,
            ),

            // **********************************************************
            // LAP TIMESTAMPS
            // **********************************************************
            Container(
                height: 240,
                margin: const EdgeInsets.all(8),
                child: StreamBuilder<List<StopWatchRecord>>(
                  stream: stopwatch.records,
                  initialData: stopwatch.records.value,
                  builder: (context, snapshot) {
                    final value = snapshot.data;
                    if (value!.isEmpty) {
                      return Container();
                    }

                    Future.delayed(const Duration(milliseconds: 100), () {
                      scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut);
                    });

                    return ListView.builder(
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        final data = value[index];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${index + 1} - ${data.displayTime}',
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            const Divider(height: 1),
                          ],
                        );
                      },
                      itemCount: value.length,
                    );
                  },
                )),
          ],
        )));
  }

  void loadIdle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      time = (prefs.getInt('time') ?? 0);
    });
  }

  Future<int> loadTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getInt('time') != 0)
        ? prefs.getInt('time')
        : stopwatch.rawTime.value;
  }

  // this could use some improvement.
  // This gives the current buttons in view for use on LINE 72.
  // I tried to make this look/behave like Apple's stopwatch UI
  List<Widget> giveButtons() {
    switch (buttonsState) {
      // don't need break after each case b/c return statements

      case 0:
        {
          //********BEFORE START
          return [
            //start button
            TextButton(
              child: const Text('Start'), //TODO Start or reset
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),

              onPressed: () {
                stopwatch.onExecute.add(StopWatchExecute.start);
                setState(() {
                  buttonsState = 1;
                });
              },
            ),
          ];
        }

      case 1:
        {
          //********WHILE RUNNING
          return [
            //lap button
            TextButton(
              child: const Text('Lap'), //TODO Start or reset
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),

              onPressed: () {
                stopwatch.onExecute.add(StopWatchExecute.lap);
              },
            ),
            //stop button
            TextButton(
              child: const Text('Stop'), //TODO Start or reset
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),

              onPressed: () {
                stopwatch.onExecute.add(StopWatchExecute.stop);
                setState(() {
                  buttonsState = 2;
                });
              },
            ),
          ];
        }

      case 2:
        {
          //********STOPPED
          return [
            //reset button
            TextButton(
              child: const Text('Reset'), //TODO Start or reset
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),

              onPressed: () {
                stopwatch.onExecute.add(StopWatchExecute.reset);
                setState(() {
                  buttonsState = 0;
                });
              },
            ),
            //start button
            TextButton(
              child: const Text('Start'), //TODO Start or reset
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),

              onPressed: () {
                stopwatch.onExecute.add(StopWatchExecute.start);
                setState(() {
                  buttonsState = 1;
                });
              },
            ),
          ];
        }

      default:
        {
          return [];
        }
    }
  }
}
