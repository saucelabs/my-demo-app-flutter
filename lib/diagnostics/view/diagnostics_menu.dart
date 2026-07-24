import 'package:flutter/material.dart';

import '../diagnostics_service.dart';

/// The set of artifact-generating actions exposed by [DiagnosticsMenu].
enum DiagnosticsAction { nativeCrash, dartCrash, testFairyLogs }

/// {@template diagnostics_menu}
/// An [AppBar] overflow menu that lets a tester generate the RDC
/// destructive-read artifacts: a native crash report, a Dart-side
/// crash, and a burst of TestFairy log events.
///
/// Every entry carries a stable [Key] and a [Semantics] label so it can be
/// driven from Appium (Flutter integration driver) and Flutter integration
/// tests.
/// {@endtemplate}
class DiagnosticsMenu extends StatelessWidget {
  /// {@macro diagnostics_menu}
  const DiagnosticsMenu({super.key, DiagnosticsService? service})
      : service = service ?? const DiagnosticsService();

  /// Service used to trigger the underlying platform behaviour.
  final DiagnosticsService service;

  Future<void> _onSelected(
    BuildContext context,
    DiagnosticsAction action,
  ) async {
    switch (action) {
      case DiagnosticsAction.nativeCrash:
        await service.crashNative();
      case DiagnosticsAction.dartCrash:
        service.crashDart();
      case DiagnosticsAction.testFairyLogs:
        final written = await service.generateTestFairyLogs();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              key: const Key('diagnostics_logsGenerated_snackBar'),
              content: Text('Generated $written TestFairy log lines'),
            ),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Diagnostics Menu',
      child: PopupMenuButton<DiagnosticsAction>(
        key: const Key('counterView_diagnostics_menuButton'),
        icon: const Icon(Icons.bug_report),
        tooltip: 'Generate test artifacts',
        onSelected: (action) => _onSelected(context, action),
        itemBuilder: (context) => <PopupMenuEntry<DiagnosticsAction>>[
          PopupMenuItem<DiagnosticsAction>(
            key: const Key('diagnostics_nativeCrash_menuItem'),
            value: DiagnosticsAction.nativeCrash,
            child: Semantics(
              label: 'Force Native Crash',
              child: const ListTile(
                leading: Icon(Icons.dangerous),
                title: Text('Force Native Crash'),
                subtitle: Text('Backtrace crash report'),
              ),
            ),
          ),
          PopupMenuItem<DiagnosticsAction>(
            key: const Key('diagnostics_dartCrash_menuItem'),
            value: DiagnosticsAction.dartCrash,
            child: Semantics(
              label: 'Force Dart Crash',
              child: const ListTile(
                leading: Icon(Icons.error_outline),
                title: Text('Force Dart Crash'),
                subtitle: Text('Uncaught Dart error'),
              ),
            ),
          ),
          PopupMenuItem<DiagnosticsAction>(
            key: const Key('diagnostics_testFairyLogs_menuItem'),
            value: DiagnosticsAction.testFairyLogs,
            child: Semantics(
              label: 'Generate TestFairy Logs',
              child: const ListTile(
                leading: Icon(Icons.article),
                title: Text('Generate TestFairy Logs'),
                subtitle: Text('Console/logcat events'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
