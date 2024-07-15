import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';

import 'app.dart';
import 'counter_observer.dart';

void main() {
  enableFlutterDriverExtension();
  Bloc.observer = const CounterObserver();
  runApp(const CounterApp());
}