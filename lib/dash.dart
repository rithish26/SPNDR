import 'dart:async';
import 'dart:ui';

import 'package:blurry/blurry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/addpost.dart';
import 'package:expenditure/anime.dart';
import 'package:expenditure/deletesheet.dart';
import 'package:expenditure/editprofile.dart';
import 'package:expenditure/google_sheets.dart';
import 'package:expenditure/homepage.dart';
import 'package:expenditure/login.dart';
import 'package:expenditure/search.dart';
import 'package:expenditure/searchservice.dart';
import 'package:expenditure/specificsheetoptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

late String sheetid;
String username = "";

class Dash extends StatefulWidget {
  @override
  _DashState createState() => _DashState();
}

class _DashState extends State<Dash> with TickerProviderStateMixin {
  late AnimationController controller1;
  late AnimationController controller2;
  late Animation<double> animation1;
  late Animation<double> animation2;
  late Animation<double> animation3;
  late Animation<double> animation4;

  var queryResultSet = [];
  var tempsearchstore = [];
  final FirebaseAuth auth = FirebaseAuth.instance;

  initiateSearch() {
    queryResultSet = [];
    tempsearchstore = [];

    SearchService().searchByName().then((QuerySnapshot docse) {
      for (int i = 0; i < docse.docs.length; ++i) {
        queryResultSet.add(docse.docs[i].data());
        setState(() {
          print(queryResultSet[i]);
          tempsearchstore.add(queryResultSet[i]);
        });
      }
    });
  }

  String userId = "";

  late User user;
  late QuerySnapshot snapshotData;
  bool isexecuted = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller1 = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 5,
      ),
    );
    animation1 = Tween<double>(begin: .1, end: .15).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.easeInOut,
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller1.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller1.forward();
        }
      });
    animation2 = Tween<double>(begin: .02, end: .04).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    controller2 = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 5,
      ),
    );
    animation3 = Tween<double>(begin: .41, end: .38).animate(CurvedAnimation(
      parent: controller2,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller2.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller2.forward();
        }
      });
    animation4 = Tween<double>(begin: 170, end: 190).animate(
      CurvedAnimation(
        parent: controller2,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    Timer(Duration(milliseconds: 2500), () {
      controller1.forward();
    });

    controller2.forward();

    initiateSearch();
    getdata();
    getusername();
  }

  void getusername() {
    FirebaseFirestore.instance
        .collection('userdata')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      setState(() {
        username = value['firstname'];
      });
    });
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  void setStateIfMounted(String f) {
    print(f);
    if (mounted)
      setState(() {
        sheetid = f;
      });
  }

  getdata() {
    print('dash');
    String refid = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance
        .collection('userdata')
        .doc(refid)
        .get()
        .then((value) {
      print(value['sheetid']);
      setStateIfMounted(value['sheetid']);
      /* setState(() {
        print(value['sheetid']);
        sheetid = value['sheetid'];
      }); */
    });
  }

  nonsearchdata(double x, double y) {
    return SizedBox(
      height: x,
      child: Stack(
        children: [
          Positioned(
            top: x * (animation2.value + .58),
            left: y * .21,
            child: CustomPaint(
              painter: MyPainter(50),
            ),
          ),
          Positioned(
            top: x * .98,
            left: y * .1,
            child: CustomPaint(
              painter: MyPainter(animation4.value - 30),
            ),
          ),
          Positioned(
            top: x * .5,
            left: y * (animation2.value + .8),
            child: CustomPaint(
              painter: MyPainter(30),
            ),
          ),
          Positioned(
            top: x * animation3.value,
            left: y * (animation1.value + .1),
            child: CustomPaint(
              painter: MyPainter(60),
            ),
          ),
          Positioned(
            top: x * .1,
            left: y * .8,
            child: CustomPaint(
              painter: MyPainter(animation4.value),
            ),
          ),
          ListView(
              padding: EdgeInsets.all(20),
              primary: true,
              shrinkWrap: true,
              children: tempsearchstore.map((element) {
                return buildResultCard(context, element);
              }).toList()),
        ],
      ),
    );
  }

  Widget searchedData() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.all(4.0),
          child: Container(
            height: 70,
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
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: ListTile(
              focusColor: Colors.green,
              title: Center(
                child: Text(snapshotData.docs[index].data()['sheetname'],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
              ),
              onLongPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Dsheet(
                          refid: snapshotData.docs[index].data()['refid'],
                          name: snapshotData.docs[index].data()['sheetname'])),
                );
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(
                      sheetname: snapshotData.docs[index].data()['sheetname'],
                      sheetid: sheetid,
                      username: username,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      itemCount: snapshotData.docs.length,
    );
  }

  _logOut() async {
    await FirebaseAuth.instance.signOut().then((_) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => AnimeHomePage()));
      });
      /*  Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    }); */
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xff192028),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(
            Icons.add,
            color: Colors.orange,
            size: 30.0,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Addsheet(
                        sheetid: sheetid,
                      )),
            );
            /*  Blurry.info(
                title: 'Tip',
                description: 'Double Tap on sheet for more options',
                confirmButtonText: '',
                onConfirmButtonPressed: () {
                  print('hello world');
                }).show(context); */
          },
        ),
        appBar: AppBar(
          flexibleSpace: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            GetBuilder<DataController>(
                init: DataController(),
                builder: (val) {
                  return IconButton(
                      onPressed: () {
                        val.queryData(searchController.text).then((value) {
                          snapshotData = value;
                          setState(() {
                            isexecuted = true;
                          });
                        });
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ));
                }),
            IconButton(
              onPressed: () {
                searchController.clear();
                setState(() {
                  isexecuted = false;
                });
              },
              icon: Icon(Icons.clear),
              color: Colors.white,
            ),
          ],
          title: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaY: 10,
              sigmaX: 10,
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                cursorColor: Colors.white,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                decoration: InputDecoration(
                    hintText: 'Search Sheets (Case sensitive)',
                    hintStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                controller: searchController,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          brightness: Brightness.light,
        ),
        body: isexecuted
            ? SizedBox(
                height: size.height,
                child: Stack(
                  children: [
                    Positioned(
                      top: size.height * (animation2.value + .58),
                      left: size.width * .21,
                      child: CustomPaint(
                        painter: MyPainter(50),
                      ),
                    ),
                    Positioned(
                      top: size.height * .98,
                      left: size.width * .1,
                      child: CustomPaint(
                        painter: MyPainter(animation4.value - 30),
                      ),
                    ),
                    Positioned(
                      top: size.height * .5,
                      left: size.width * (animation2.value + .8),
                      child: CustomPaint(
                        painter: MyPainter(30),
                      ),
                    ),
                    Positioned(
                      top: size.height * animation3.value,
                      left: size.width * (animation1.value + .1),
                      child: CustomPaint(
                        painter: MyPainter(60),
                      ),
                    ),
                    Positioned(
                      top: size.height * .1,
                      left: size.width * .8,
                      child: CustomPaint(
                        painter: MyPainter(animation4.value),
                      ),
                    ),
                    searchedData(),
                  ],
                ))
            : nonsearchdata(size.height, size.width),
        /* ListView(
          padding: EdgeInsets.all(20),
          primary: true,
          shrinkWrap: true,
          children: tempsearchstore.reversed.map((element) {
            return buildResultCard(context, element); 
          }).toList()),*/
        bottomNavigationBar: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaY: 100,
              sigmaX: 100,
            ),
            child: BottomAppBar(
              shape: CircularNotchedRectangle(),
              color: Colors.black,
              child: IconTheme(
                data: IconThemeData(
                    color: Theme.of(context).colorScheme.onPrimary),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      tooltip: 'Log out',
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.blue,
                        size: 30,
                      ),
                      onPressed: () {
                        _logOut();
                      },
                    ),
                    /* IconButton(
                      tooltip: 'Add',
                      icon: const Icon(
                        Icons.add,
                        color: Colors.orange,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Addsheet(
                                    sheetid: sheetid,
                                  )),
                        );
                      },
                    ), */
                    IconButton(
                      tooltip: 'Edit Profile',
                      icon: const Icon(
                        Icons.account_box,
                        color: Colors.purple,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Editp(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

Widget buildResultCard(BuildContext context, data) {
  return SingleChildScrollView(
    child: Column(
      children: [
        Tooltip(
          message: 'Longpress for more options',
          child: GestureDetector(
              child: Container(
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
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 100,
                child: Center(
                    child: Text(data['sheetname'],
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ))),
              ),
              onLongPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Dsheet(
                          refid: data['refid'], name: data['sheetname'])),
                );
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(
                      sheetname: data['sheetname'],
                      sheetid: sheetid,
                      username: username,
                    ),
                  ),
                );

                /*  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobApply(
                      jobtitle: data['jobtitle'],
                      jobdisc: data['jobdisc'],
                      qualification: data['qualification'],
                      websitelink: data['websitelink'],
                      isadmin: true,
                      companyname: data['companyname'],
                      refid: data['refid'],
                      email: data['email link'],
                      aboutcompany: data['about company'],
                      isprev: false,
                    ),
                  ),
                ); */
              }),
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    ),
  );
}

class MyPainter extends CustomPainter {
  final double radius;

  MyPainter(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
              colors: [Colors.orange, Colors.purple, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)
          .createShader(Rect.fromCircle(
        center: Offset(0, 0),
        radius: radius,
      ));

    canvas.drawCircle(Offset.zero, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
