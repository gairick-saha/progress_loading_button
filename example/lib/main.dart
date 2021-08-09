import 'package:flutter/material.dart';
import 'package:progress_loading_button/progress_loading_button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Progress Loading Button Example'),
        ),
        body: Center(
          child: LoadingButton(
            defaultWidget: const Text('Click Me'),
            width: 196,
            height: 60,
            onPressed: () async {
              await Future.delayed(
                const Duration(milliseconds: 3000),
                () {
                  print('Button Pressed');
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
