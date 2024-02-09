import 'package:flutter/material.dart';
import 'package:pearl_smart_crate/classes/is_checked.dart';
import 'package:pearl_smart_crate/utils/constants.dart';
import 'package:pearl_smart_crate/utils/rpi_connector.dart';
import 'package:pearl_smart_crate/utils/shared_pref.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pearl Smart Crate',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, bool> isChecked = {};
  TimeOfDay time = const TimeOfDay(hour: 7, minute: 15);

  // @override
  // void initState() {
  //   super.initState();
  //   loadWeekdayPreferences();
  //   loadTimePreferences();
  // }

// loads the weekdays and times on program start that are saved in shared pref
  void initLoadPreferences() async {
    final DaysAndTimes allDaysAndTime = await loadAllPreferences();
    // isChecked =
    //     allDaysAndTime.day ?? {for (var item in daysOfWeek) item: false};
    // time = allDaysAndTime.time!;
    setState(() {
      isChecked =
          allDaysAndTime.day ?? {for (var item in daysOfWeek) item: false};
      time = allDaysAndTime.time!;
    });
  }

  void selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: time,
    );

    if (newTime != null) {
      await setAllPreferences(isChecked, newTime);

      setState(() {
        time = newTime;
      });
    } else {
      throw Exception('newTime is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DaysAndTimes>(
      future: loadAllPreferences(),
      builder: (BuildContext context, AsyncSnapshot<DaysAndTimes> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('sharedpref has no data');
        } else {
          isChecked =
              snapshot.data?.day ?? {for (var item in daysOfWeek) item: false};
          time = snapshot.data?.time ?? const TimeOfDay(hour: 7, minute: 15);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView(
                    children: daysOfWeek.map((day) {
                      return CheckboxListTile(
                        title: Text(day),
                        value: isChecked[day] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked[day] = value!;
                            setAllPreferences(isChecked, time);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    loadAllPreferences();
                    final TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: time,
                        initialEntryMode: TimePickerEntryMode.inputOnly);
                    if (newTime != null) {
                      await setAllPreferences(isChecked, newTime);

                      setState(() {
                        time = newTime;
                      });
                    } else {
                      throw Exception('newTime is null');
                    }
                  },
                  child: const Text('Select time'),
                ),
                Text('Selected time: ${time.format(context)}'),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () async {
                    openCrateRequest();
                  },
                  child: const Text('Open Crate'),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
