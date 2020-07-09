import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final body = MyBody();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MiApp",
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Sample Code'),
          ),
          body: Column(
            children: <Widget>[
              Text('Deliver features faster'),
              Text('Craft beautiful UIs'),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.contain, // otherwise the logo will be tiny
                  child: const FlutterLogo(),
                ),
              ),
            ],
          )),
    );
  }
}

class MyBody extends StatefulWidget {
  void increment() {
    state.increment();
  }

  MyBodyState state;
  @override
  MyBodyState createState() {
    state = MyBodyState();
  }
}

class MyBodyState extends State<MyBody> {
  int counter = 0;
  void increment() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text("Contador : $counter");
  }
}
