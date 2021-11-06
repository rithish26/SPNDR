import 'package:expenditure/google_sheets.dart';
import 'package:flutter/material.dart';

class Addtransaction extends StatefulWidget {
  var gg = new GoogleSheetsApi();
  Addtransaction({required this.gg});
  @override
  _AddtransactionState createState() => _AddtransactionState();
}

class _AddtransactionState extends State<Addtransaction> {
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _textcontrollerNOTE = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  func1() {
    setState(() {
      _isIncome = false;
    });
  }

  func2() {
    setState(() {
      _isIncome = true;
    });
  }

  void _enterTransaction() {
    widget.gg.insert(
      _textcontrollerITEM.text,
      _textcontrollerAMOUNT.text,
      _isIncome,
      _textcontrollerNOTE.text,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue,
                Colors.purpleAccent,
                Colors.orange,
                /*  Color(0xff405DE6),
              Color(0xff5851DB),
              Color(0xff833AB4),
              Color(0xffC13584),
              Color(0xffE1306C),
              Color(0xffFD1D1D),
              Color(0xffF56040),
              Color(0xffF77737),
              Color(0xffFCAF45),
              Color(0xffFFDC80), */
              ],
            ),
          ),
        ),
        title: Text(
          'N E W  T R A N S A C T I O N',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: func1,
                  child: Container(
                    height: 240,
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Expense',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Center(
                              child: Image.asset('assets/expenses.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: _isIncome ? Colors.blue[800] : Colors.blue,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                )),
                Expanded(
                    child: GestureDetector(
                  onTap: func2,
                  child: Container(
                    height: 240,
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Income',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Center(
                              child: Image.asset('assets/income.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: _isIncome ? Colors.blue : Colors.blue[800],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                )),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    fillColor: Colors.blue[700],
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Ammount',
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: '₹',
                    hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
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
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: TextField(
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  fillColor: Colors.blue[700],
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'For?',
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: '',
                  hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
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
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                  fillColor: Colors.blue[700],
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Note',
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: '',
                  hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
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
            Row(
              children: [
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
                    child: Text('Enter', style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _enterTransaction();
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
