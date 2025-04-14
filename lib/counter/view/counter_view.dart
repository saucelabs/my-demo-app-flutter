import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../counter.dart';

/// {@template counter_view}
/// A [StatefulWidget] which reacts to the provided
/// [CounterCubit] state and notifies it in response to user input,
/// and also displays a timer.
/// {@endtemplate}
class CounterView extends StatefulWidget {
  /// {@macro counter_view}
  const CounterView({super.key});

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  int _secondsElapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo.png',
              height: 162,
              width: 162,
            ),
            const SizedBox(height: 20),
            Text(
              'Timer: $_secondsElapsed seconds',
              key: const Key('textView_timer_Text'),
              style: textTheme.titleLarge?.copyWith(color: Colors.blue),
            ),
            const SizedBox(height: 10),
            BlocBuilder<CounterCubit, int>(
              builder: (context, state) {
                return Semantics(
                  label: 'counter_value',
                  child: Text(
                    '$state',
                    key: const Key('textView_counterValue_Text'),
                    style: textTheme.displayMedium,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Semantics(
            label: 'Increment Button',
            child: FloatingActionButton(
              key: const Key('counterView_increment_floatingActionButton'),
              child: const Icon(Icons.add),
              onPressed: () => context.read<CounterCubit>().increment(),
            ),
          ),
          const SizedBox(height: 8),
          Semantics(
            label: 'Decrement Button',
            child: FloatingActionButton(
              key: const Key('counterView_decrement_floatingActionButton'),
              child: const Icon(Icons.remove),
              onPressed: () => context.read<CounterCubit>().decrement(),
            ),
          ),
        ],
      ),
    );
  }
}
