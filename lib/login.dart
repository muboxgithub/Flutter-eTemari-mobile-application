import 'dart:convert';

import 'package:etemarilite/dashbord.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class Anotherlogin extends StatefulWidget {
  const Anotherlogin({super.key});

  @override
  State<Anotherlogin> createState() => _AnotherloginState();
}

class _AnotherloginState extends State<Anotherlogin> {
  final _formkey = GlobalKey<FormState>();

  final _namecontroller = TextEditingController();

  final _passwwordcontroller = TextEditingController();

  Future<void> _login() async {
    const url = "http://192.168.43.40/etemari/login.php/";

    final response = await http.post(
      Uri.parse(url),
      body: {

        'username':_namecontroller.text,
        'password':_passwwordcontroller.text,
      }
    );

    if (response.statusCode == 200) {

      final data=jsonDecode(response.body);

      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 2),
          content: Text('Login Successfully'),
        ),
      );

      Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard(userid: data['id'])));
    }
    else
    {
    showDialog(context: context, builder: (BuildContext context)
    {
      return AlertDialog(
title: Text('Error',style: TextStyle(color:Colors.red,),),
content: Text('you have enterd invalid username or email'),
actions: [
  TextButton(
    onPressed: (){
Navigator.of(context).pop();
    },
    child: Text('Ok'),
  ),
],

      );
    });
    }
  }

  void dispose() {
    _namecontroller.dispose();
    _passwwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(35),
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image:
                    DecorationImage(image: AssetImage(''), fit: BoxFit.cover),
                color: Color(0XFFf8f8f8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  )
                ]),
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0XFFf8f8f8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 70,
                      width: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/logo1.jpg'),
                        ),
                      ),
                    ),

                    // SizedBox(height:10,),
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 100,
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Hi Welcome to eTemari',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text('Enter your details to login in your account'),
                        ],
                      ),
                    ),

                    Container(
                      height: 200,
                      width: 250,
                      padding: EdgeInsets.only(top: 7),
                      child: Form(
                          key: _formkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextField(
                                controller: _namecontroller,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    // borderRadius: BorderRadius.circular(0),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  labelText: 'Username',
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: TextField(
                                  controller: _passwwordcontroller,
                                  obscureText:true,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      //borderRadius: BorderRadius.circular(0),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                      
                                    ),
                                    
                                    labelText: 'Password',
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                              ),
                              Text('Forgetyour password', style: TextStyle()),
                            ],
                          )),
                    ),

                    Container(
                      height: 40,
                      width: 250,
                      decoration: BoxDecoration(
                        color: Color(0xFF9932cc),
                      ),
                      child: TextButton(
                          onPressed: () {
                            _login();
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
