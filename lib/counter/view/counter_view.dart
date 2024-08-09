import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../counter.dart';

/// {@template counter_view}
/// A [StatelessWidget] which reacts to the provided
/// [CounterCubit] state and notifies it in response to user input.
/// {@endtemplate}
class CounterView extends StatelessWidget {
  /// {@macro counter_view}
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo.png', // Path to the logo image
              height: 162, // Adjust height as needed
              width: 162,
            ),
            const SizedBox(height: 20), // Space between image and text
            BlocBuilder<CounterCubit, int>(
              builder: (context, state) {
                return Semantics(
                  label: 'counter_value',
                  child: Text(
                    '$state',
                    key: const Key('textView_counterValue_Text'),
                    style: textTheme.displayMedium),
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