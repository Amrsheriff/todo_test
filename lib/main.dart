import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:untitled/layout/home_layout.dart';
import 'package:untitled/shared/bloc_observer.dart';


void main() {

    Bloc.observer = MyBlocObserver();
    // Use cubits...

  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }

}


