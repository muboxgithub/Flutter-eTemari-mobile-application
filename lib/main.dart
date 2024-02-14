import 'dart:convert';

import 'package:etemarilite/dashbord.dart';
import 'package:etemarilite/login.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(
    MaterialApp(
      title: 'etemar',
      home: Anotherlogin(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();

  final _namecontroller = TextEditingController();
  final _passwwordcontroller = TextEditingController();

  @override
  void dispose() {
    _namecontroller.dispose();
    _passwwordcontroller.dispose();
    super.dispose();
  }

  @override
  Future<void> _login() async {
    const url = "http://192.168.43.40/etemari/login.php/";

    final response = await http.post(
      Uri.parse(url),
      body: {
        'username': _namecontroller.text,
        'password': _passwwordcontroller.text,
      },
    );
    if (response.statusCode == 200) {
      
   

      //Navigator.push(
        //  context, MaterialPageRoute(builder: (context) => Dashboard(userid: userid,)));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Login Successfulluy',
        ),
        duration: Duration(seconds: 3),
      ));
//  print('you have succesfully logi ein');
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text('Error',style: TextStyle(color:Colors.red),),
                content: Text('you have enterd invalid user name or email'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Ok'),
                  ),
                ]);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/lo.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(top: 230, left: 30),
              child: Text(
                'Login Page',
                style: TextStyle(
                  fontSize: 33,
                  color: Color(0XFF9932cc),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5),
              child: Container(
                padding: EdgeInsets.only(right: 30, left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            TextField(
                              controller: _namecontroller,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fillColor: Color(0XFF9932cc),
                                filled: true,
                                hintText: 'User name',
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextField(
                              controller: _passwwordcontroller,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fillColor: Colors.amber,
                                filled: true,
                                hintText: 'Password',
                              ),
                              obscureText: true,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Color(0XFF9932cc),
                                      fontWeight: FontWeight.bold),
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  child: IconButton(
                                      onPressed: () {
                                        _login();
                                      },
                                      icon: Icon(Icons.arrow_forward_ios)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
