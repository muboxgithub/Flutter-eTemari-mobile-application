import 'dart:async';
import 'dart:convert';
//import 'dart:ffi';

import 'package:etemarilite/content.dart';
import 'package:etemarilite/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;

import 'package:etemarilite/main.dart';

//import 'pacakge:asy';

class Dashboard extends StatefulWidget {
  final int userid;
  const Dashboard({required this.userid});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<String> imageurl = [
    'images/logo4.png',
    'images/logo2.png',
    'images/logo4.jpg',
  ];

  Future<void> _logout() async {
    const url = "http://192.168.43.40/etemari/logout.php/";

    final response = await http.get(
      Uri.parse(url),
    );

    try {
      if (response.statusCode == 200) {
//print('logoutscuccessfully');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Logout Successfully'),
          duration: Duration(seconds: 2),
        ));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Anotherlogin(),
          ),
        );
      } else {
        print('logout failed');
      }
    } catch (error) {
      print('Logourt failed woth erorr code: $error');
    }
  }

  Future<List<dynamic>> catagory() async {
    const url = "http://192.168.43.40/etemari/catagory.php/";

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final jsondata = jsonDecode(response.body);
      return List<dynamic>.from(jsondata);
    } else {
      print('error fething catagories');
    }

    return [];
  }

  late ScrollController _scrollcontroller;

  Timer? _timer;
  double _scrolloffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollcontroller = ScrollController();
    _starttime();

    final int userid = widget.userid;

   courses(userid);
  }

  Future<List<dynamic>> courses(int userid) async {
    const url = "http://192.168.43.40/etemari/course.php?userid=";

    final response = await http.get(
      Uri.parse(url + userid.toString()),
    );

    if (response.statusCode == 200) {
      final ddata = jsonDecode(response.body);

      if(ddata is List)
      {
      return ddata;
      }
      else
      {
      return [];
      }


      
    } 
    
    
    else {
      print('erro occured during fetching user data');
    }

    return [];
  }

  @override
  void dispose() {
    _scrollcontroller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _starttime() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_scrolloffset < _scrollcontroller.position.maxScrollExtent) {
        _scrolloffset += MediaQuery.sizeOf(context).width;

        _scrollcontroller.animateTo(_scrolloffset,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      } else {
        _scrolloffset = 0.0;
        _scrollcontroller.animateTo(_scrolloffset,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF9932cc),

        // padding: EdgeInsets.only(top:MediaQuery.of(context).size.height* 0.5),
        leading: Row(
          children: [
            //IconButton(onPressed: (){}, icon: Icon(Icons.menu)),

            Flexible(
              child: Container(
                height: 50,
                width: 50,
                //color: Colors.white,
                padding: EdgeInsets.only(left: 5),
                child: CircleAvatar(
                  //radius: 10,
                  backgroundImage: AssetImage('images/llo.jpg'),
                ),
              ),
            ),
          ],
        ),

        title: Text(
          'eTemari',
          style: TextStyle(
            // backgroundColor: Colors.white,
            color: Colors.white,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notification_add_rounded,
              color: Colors.white,
            ),
          ),
          Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            );
          }),
        ],
      ),
      drawer: Drawer(
        child: FutureBuilder<List<dynamic>>(
            future: catagory(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final catagorylist = snapshot.data!;
                return ListView.builder(
                    itemCount: catagorylist.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return DrawerHeader(
                          decoration: BoxDecoration(
                            color: Color(0xFF9932cc),
                          ),
                          child: Text(
                            'eTemari catagoriey lsit',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (index == 1) {
                        return ListTile(
                          title: Text('Logout'),
                          leading: IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Alert',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        content: Text(
                                            'Do you want to exit from eTemari'),
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('No')),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Anotherlogin(),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      );
                                    });
                              },
                              icon: Icon(Icons.logout_rounded)),
                        );
                      }

                      final cat = catagorylist[index - 2];
                      final catname = cat['name'] as String;
                      return ListTile(
                        title: Text(catname),
                        onTap: () {},
                      );
                    });
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Eroor:${snapshot.error}'),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 200,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollcontroller,
                    itemCount: imageurl.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                          imageurl[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    }),
              ),

              SizedBox(
                height: 20,
              ),
              Text('Courses',
                  style: TextStyle(color: Colors.black, fontSize: 25)),

              FutureBuilder<List<dynamic>>(
                  future: catagory(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        padding: EdgeInsets.all(5),
                        height: 400,
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final cat = snapshot.data![index];
                              return Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      width: 170,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              offset: Offset(0, 4),
                                              blurRadius: 8)
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Text(cat['name']),
                                          CircleAvatar(
                                            radius: 50,
                                            backgroundImage: AssetImage(
                                              'images/chem.jpg',
                                            ),
                                          ),
                                          TextButton(
                                              onPressed: () {},
                                              child: Text('Enter')),
                                        ],
                                      )),
                                  Positioned(
                                    top: 80,
                                    child: Text('item: $index'),
                                  ),
                                ],
                              );
                            }),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error:${snapshot.hasError}'),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),

              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Course catagories'),
              ),
              //Listsubcatagories(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //SizedBox(height: 10,),
                  // ElevatedButton(onPressed: (){}, child: Text('Course catagories'),),
                 // Listsubcatagories(userid: widget.userid),



                 FutureBuilder<List<dynamic>>(
        future: courses(widget.userid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final course = snapshot.data![index];
                       final courseid=int.parse(course['id']);
                      return Container(
                        padding: EdgeInsets.all(7),
                        margin: EdgeInsets.all(8),
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ]),
                        child: ListTile(
                          title: Text(course['fullname']),
                          subtitle: Text(course['id']),
                          
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('images/logo4.png'),
                          ),
                                                   trailing: IconButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder:  (context)=>Content(courseid: courseid, catname: course['fullname'] as String)));
                              },
                              icon: Icon(Icons.forward_sharp)),
                        ),
                      );
                    }),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erorr:${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
                  TextButton(onPressed: () {}, child: Text('last'))
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.amber,
          fixedColor: Colors.white,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.notification_add),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.download),
              label: 'download',
            ),
          ]),
    );
  }
}

/*
class Listsubcatagories extends StatefulWidget {
  final int userid;
  const Listsubcatagories({required this.userid});
  @override
  State<Listsubcatagories> createState() => _ListsubcatagoriesState();
}

class _ListsubcatagoriesState extends State<Listsubcatagories> {
  void initState() {
    super.initState();

    final userid = widget.userid;

    courses(userid);
  }

  Future<List<dynamic>> courses(int userid) async {
    const url = "http://192.168.43.40/etemari/course.php?userid=";

    final response = await http.get(
      Uri.parse(url + userid.toString()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
if(data is List){
      return data ;

      }
      else{
      return [];
      }
    } else {
      print('erro occured during fetching user data');
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    final userid = widget.userid;
    return FutureBuilder<List<dynamic>>(
        future: courses(userid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final course = snapshot.data![index];
                      return Container(
                        padding: EdgeInsets.all(7),
                        margin: EdgeInsets.all(8),
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ]),
                        child: ListTile(
                          title: Text(course['fullname']),
                          subtitle: Text('hfyf'),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('images/logo4.png'),
                          ),
                          trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.forward_sharp)),
                        ),
                      );
                    }),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erorr:${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
*/