import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessCounterNotifier extends ChangeNotifier {
  static const String _counterKey = 'access_counter';
  static const int _maxAccess = 20;

  int _counter = 0;
  bool _isPremium = false;

  int get counter => _counter;
  bool get isLimited => !_isPremium && _counter >= _maxAccess;

  AccessCounterNotifier() {
    _loadCounter();
    _scheduleMidnightReset();
  }

  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt(_counterKey) ?? 0;
    notifyListeners();
  }

  Future<void> incrementCounter() async {
    if (_isPremium || _counter < _maxAccess) {
      _counter++;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_counterKey, _counter);
      notifyListeners();
    }
  }

  Future<void> _resetCounter() async {
    _counter = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_counterKey, _counter);
    notifyListeners();
  }

  void _scheduleMidnightReset() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = nextMidnight.difference(now);

    Timer(durationUntilMidnight, () {
      _resetCounter();
      _scheduleMidnightReset(); // Reschedule for next midnight
    });
  }

  void setPremiumStatus(bool value) {
    _isPremium = value;
    notifyListeners();
  }
}


// Consumer<AccessCounterNotifier>(
//   builder: (context, notifier, _) {
//     return Column(
//       children: [
//         Text('Accès utilisé : ${notifier.counter}/20'),
//         ElevatedButton(
//           onPressed: notifier.isLimited
//               ? null
//               : () {
//                   notifier.incrementCounter();
//                 },
//           child: Text('Accéder à la fonctionnalité'),
//         ),
//       ],
//     );
//   },
// )