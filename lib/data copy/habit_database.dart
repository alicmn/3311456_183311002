import 'package:todoflutter/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _noteBox = Hive.box("mybox");

class HabitDatabase {
  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};

  void createDefaultData() {
    todaysHabitList = [
      ["Run", false],
      ["Read", false],
    ];

    _noteBox.put("START_DATE", todaysDateFormatted());
  }

  void loadData() {
    if (_noteBox.get(todaysDateFormatted()) == null) {
      todaysHabitList = _noteBox.get("CURRENT_HABIT_LIST");
      for (int i = 0; i < todaysHabitList.length; i++) {
        todaysHabitList[i][1] = false;
      }
    } else {
      todaysHabitList = _noteBox.get(todaysDateFormatted());
    }
  }

  void updateDatabase() {
    _noteBox.put(todaysDateFormatted(), todaysHabitList);

    _noteBox.put("CURRENT_HABIT_LIST", todaysHabitList);

    calculateHabitPercentages();

    loadHeatMap();
  }

  void calculateHabitPercentages() {
    int countCompleted = 0;
    for (int i = 0; i < todaysHabitList.length; i++) {
      if (todaysHabitList[i][1] == true) {
        countCompleted++;
      }
    }

    String percent = todaysHabitList.isEmpty
        ? '0.0'
        : (countCompleted / todaysHabitList.length).toStringAsFixed(1);

    _noteBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_noteBox.get("START_DATE"));

    int daysInBetween = DateTime.now().difference(startDate).inDays;

    // "PERCENTAGE_SUMMARY_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        _noteBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      int year = startDate.add(Duration(days: i)).year;

      int month = startDate.add(Duration(days: i)).month;

      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      //print(heatMapDataSet);
    }
  }
}
