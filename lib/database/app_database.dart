import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
part 'app_database.g.dart';

@DataClassName('ExpenseData')
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  RealColumn get amount => real()();

  TextColumn get category => text()();

  DateTimeColumn get date => dateTime()();

  TextColumn get note => text().nullable()();
}

@DriftDatabase(tables: [Expenses])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
  Future<int> insertExpense({
    required String title,
    required double amount,
    required String category,
    required DateTime date,
    String? note,
  }) {
    return into(expenses).insert(
      ExpensesCompanion.insert(
        title: title,
        amount: amount,
        category: category,
        date: date,
        note: Value(note),
      ),
    );
  }

  //Updaet Expense
  Future<int> updateExpense({
    required int id,
    required String title,
    required double amount,
    required String category,
    required DateTime date,
    String? note,
  }) {
    return (update(expenses)..where((tbl) => tbl.id.equals(id))).write(
      ExpensesCompanion(
        title: Value(title),
        amount: Value(amount),
        category: Value(category),
        date: Value(date),
        note: Value(note),
      ),
    );
  }

  Future<List<ExpenseData>> getAllExpenses() {
    return select(expenses).get();
  }

  Future<int> deleteExpense(int id) {
    return (delete(expenses)..where((tbl) => tbl.id.equals(id))).go();
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'expenses_database',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.dart.js'),
    ),
  );
}

final AppDatabase appDatabase = AppDatabase();
