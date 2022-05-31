import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'lap_database.db'),
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE Laps(id INTEGER PRIMARY KEY, lap_time TEXT NOT NULL)');
        await db.execute(
            'CREATE TABLE StartStopTime(id INTEGER PRIMARY KEY, start_time INTEGER, stop_time INTEGER)');
        await db.execute(
            'INSERT INTO StartStopTime (start_time, stop_time) VALUES (0, 0)');
      },
      version: 1,
    );
  }

  Future<int> insertInterval(int startTimeMs, int stopTimeMs) async {
    final Database db = await initializeDB();
    return await db.insert(
        'StartStopTime', {'start_time': startTimeMs, 'stop_time': stopTimeMs});
  }

  Future<int> updateInterval(int startTimeMs, int stopTimeMs) async {
    final Database db = await initializeDB();
    return await db.update(
      'StartStopTime',
      {'stop_time': stopTimeMs},
      where: 'start_time = ?',
      whereArgs: [startTimeMs],
    );
  }

  Future<List<Map<String, int>>> getIntervals() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryStartStopTimeResult =
        await db.query('StartStopTime');
    List<Map<String, int>> startStopTime = queryStartStopTimeResult
        .map((e) => {
              'start_time': e['start_time'] as int,
              'stop_time': e['stop_time'] as int
            })
        .toList();

    return startStopTime;
  }

  Future<int> insertLap(String lapTime) async {
    final Database db = await initializeDB();
    return await db.insert('laps', {'lap_time': lapTime});
  }

  Future<List<DataRow>> getLaps() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryLapsResult = await db.query('laps');

    return queryLapsResult
        .map((lap) => DataRow(cells: [
              DataCell(
                Text(lap['id'].toString()),
              ),
              DataCell(Text(
                lap['lap_time']!.toString(),
                textAlign: TextAlign.right,
              ))
            ]))
        .toList()
        .reversed
        .toList();
  }

  Future<void> deleteAllLaps() async {
    final db = await initializeDB();
    db.execute("DELETE FROM laps");
  }

  Future<void> resetIntervals() async {
    final db = await initializeDB();
    db.execute("DELETE FROM StartStopTime");
    db.execute(
        'INSERT INTO StartStopTime (start_time, stop_time) VALUES (0, 0)');
  }
}
