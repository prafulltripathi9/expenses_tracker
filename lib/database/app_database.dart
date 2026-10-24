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
Future<List<ExpenseData>> getAllExpenses() {
  return select(expenses).get();
}
}
QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'expenses_database',
  );
}