import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/Addtransaction.dart';
import 'package:expenditure/dash.dart';
import 'package:expenditure/loadingcircle.dart';
import 'package:expenditure/plus_button.dart';
import 'package:expenditure/top_card.dart';
import 'package:expenditure/transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'google_sheets.dart';

class HomePage extends StatefulWidget {
  String sheetname = "";
  String sheetid = "";
  String username = "";
  HomePage(
      {required this.sheetname, required this.sheetid, required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _textcontrollerNOTE = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;
  var gg = new GoogleSheetsApi();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.sheetid);
    print(widget.sheetname);

    gg.init(widget.sheetname, widget.sheetid);
  }

  // enter the new transaction into the spreadsheet
  void _enterTransaction() {
    gg.insert(
      _textcontrollerITEM.text,
      _textcontrollerAMOUNT.text,
      _isIncome,
      _textcontrollerNOTE.text,
    );
    setState(() {});
  }

  void _newTransaction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                backgroundColor: Colors.purple[400],
                title: Text(
                  'N E W  T R A N S A C T I O N',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Expense',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Switch(
                            activeTrackColor: Colors.white,
                            hoverColor: Colors.white,
                            focusColor: Colors.white,
                            inactiveThumbColor: Colors.white,
                            value: _isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = newValue;
                              });
                            },
                          ),
                          Text('Income',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                cursorColor: Colors.white,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(20),
                                  fillColor: Colors.purple[400],
                                  filled: true,
                                  border: OutlineInputBorder(),
                                  labelText: 'Ammount',
                                  labelStyle: TextStyle(color: Colors.white),
                                  hintText: '₹',
                                  hintStyle: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Enter an amount';
                                  }

                                  return null;
                                },
                                controller: _textcontrollerAMOUNT,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Expanded(
                            child: TextField(
                              cursorColor: Colors.white,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(20),
                                fillColor: Colors.purple[400],
                                filled: true,
                                border: OutlineInputBorder(),
                                labelText: 'For?',
                                labelStyle: TextStyle(color: Colors.white),
                                hintText: '',
                                hintStyle: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              controller: _textcontrollerITEM,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              maxLines: 2,
                              cursorColor: Colors.white,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(20),
                                fillColor: Colors.purple[400],
                                filled: true,
                                border: OutlineInputBorder(),
                                labelText: 'Note',
                                labelStyle: TextStyle(color: Colors.white),
                                hintText: '',
                                hintStyle: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              controller: _textcontrollerNOTE,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.black12,
                        ),
                      ),
                      child:
                          Text('Cancel', style: TextStyle(color: Colors.black)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.black12,
                        ),
                      ),
                      child:
                          Text('Enter', style: TextStyle(color: Colors.black)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _enterTransaction();
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  )
                ],
              );
            },
          );
        });
  }

  bool timerHasStarted = false;
  void startLoading() {
    timerHasStarted = true;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (gg.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (gg.loading == true && timerHasStarted == false) {
      startLoading();
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _textcontrollerITEM.clear();
          _textcontrollerAMOUNT.clear();
          _isIncome = false;
          _textcontrollerNOTE.clear();
          _newTransaction();
          /* Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Addtransaction(
                gg: gg,
              ),
            ), 
          );*/
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
          size: 30.0,
        ),
        backgroundColor: Colors.grey[200],
      ),
      backgroundColor: Color(0xff192028),
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff192028),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Dash()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
                child: Text('Welcome',
                    style: TextStyle(color: Colors.white, fontSize: 15))),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
                child: Text('$username!!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold))),
          ),
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            TopNeuCard(
              balance:
                  (gg.calculateIncome() - gg.calculateExpense()).toString(),
              income: gg.calculateIncome().toString(),
              expense: gg.calculateExpense().toString(),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  child: Text('Transactions..',
                      style: TextStyle(color: Colors.white, fontSize: 25))),
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 0,
                      ),
                      Expanded(
                        child: gg.loading == true
                            ? LoadingCircle()
                            : ListView.builder(
                                itemCount: gg.currentTransactions.length,
                                itemBuilder: (context, index) {
                                  return MyTransaction(
                                    username: widget.username,
                                    id: gg.currentTransactions[index][0],
                                    gg: gg,
                                    transactionName:
                                        gg.currentTransactions[index][1],
                                    money: gg.currentTransactions[index][2],
                                    expenseOrIncome:
                                        gg.currentTransactions[index][3],
                                    day: gg.currentTransactions[index][4],
                                    date: gg.currentTransactions[index][5],
                                    month: gg.currentTransactions[index][6],
                                    year: gg.currentTransactions[index][7],
                                    note: gg.currentTransactions[index][9],
                                    sheetname: widget.sheetname,
                                    sheetid: widget.sheetid,
                                  );
                                }),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
