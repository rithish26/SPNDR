import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class GoogleSheetsApi {
  static const _credentials = r'''
{
  
}


''';

  final _gsheets = GSheets(_credentials);
  Worksheet? _worksheet;
  int numberOfTransactions = 0;
  List<List<dynamic>> currentTransactions = [];
  bool loading = true;
  String sheetname = "";
  static int id = 0;

  Future init(String a, String b) async {
    final ss = await _gsheets.spreadsheet(b);
    _worksheet = ss.worksheetByTitle(a);
    currentTransactions.clear();
    print(currentTransactions);
    countRows();
    print(numberOfTransactions);
    print('class');
  }

  Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }

    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  Future loadTransactions() async {
    if (_worksheet == null) {
      print('failed load');
      return;
    }
    id = numberOfTransactions - 1;
    for (int i = 1; i < numberOfTransactions; i++) {
      final String index =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionName =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 3, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 4, row: i + 1);

      final String day = await _worksheet!.values.value(column: 5, row: i + 1);
      final String date = await _worksheet!.values.value(column: 6, row: i + 1);
      final String month =
          await _worksheet!.values.value(column: 7, row: i + 1);
      final String year = await _worksheet!.values.value(column: 8, row: i + 1);
      final String time = await _worksheet!.values.value(column: 9, row: i + 1);
      final String note =
          await _worksheet!.values.value(column: 10, row: i + 1);

      if (index == 'Id') {
        continue;
      }
      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          index,
          transactionName,
          transactionAmount,
          transactionType,
          day,
          date,
          month,
          year,
          time,
          note,
        ]);
      }
    }
    print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }

  Future start(String id, String sheetname) async {
    final sse = await _gsheets.spreadsheet(id);
    Worksheet? _work;
    _work = sse.worksheetByTitle(sheetname);
    await _work.values.appendRow([
      'Id',
      'Title',
      'Amount',
      'Expense/Income',
      'Day',
      'Date',
      'Month',
      'Year',
      'Time',
      'Note',
    ]);
  }

  Future insert(String name, String amount, bool _isIncome, String note) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    DateTime now = new DateTime.now();
    id++;
    Random random = new Random();
    int randomNumber = random.nextInt(10000);
    id += randomNumber;
    String x = id.toString();
    String day = new DateFormat('EEEEE').format(now);
    String date = new DateFormat('d').format(now);
    String month = new DateFormat('MMM').format(now);
    String year = new DateFormat('yyyy').format(now);
    String time = new DateFormat('hh:mm').format(now);
    currentTransactions.add([
      x,
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
      day,
      date,
      month,
      year,
      time,
      note
    ]);
    await _worksheet!.values.appendRow([
      x,
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
      day,
      date,
      month,
      year,
      time,
      note
    ]);
  }

  Future<bool> deleterow(String indexe) async {
    print('hello');
    if (_worksheet == null) return false;
    final index = await _worksheet!.values.rowIndexOf(indexe);
    print(index);
    print('hellow again');
    if (index == -1) return false;
    return _worksheet!.deleteRow(index);
  }

  double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][3] == 'income') {
        totalIncome += double.parse(currentTransactions[i][2]);
      }
    }
    return totalIncome;
  }

  double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][3] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][2]);
      }
    }
    return totalExpense;
  }
}
