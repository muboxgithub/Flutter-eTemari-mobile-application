import 'dart:convert';


import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class Content extends StatefulWidget {
  final int courseid;

  final catname;
  const Content({required this.courseid, required this.catname});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  void initState() {
    super.initState();

    final int courseid = widget.courseid;

    final catname = widget.catname;
    coursedetail(courseid);
  }

  Future<List<dynamic>> coursedetail(int courseid) async {
    const url = "http://192.168.43.40/etemari/coursdetail.php?courseid=";

    final response = await http.get(
      Uri.parse(url + courseid.toString()),
    );
    if (response.statusCode == 200) {
      final jsond = jsonDecode(response.body);

      if (jsond is List) {
        return jsond;
      }  else {
        return [];
      }
    }
    return [];
  }

  final co = Color(0xFF9932cc);
  final bc = Colors.amber;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: co,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: Text(
          widget.catname,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(

        future: coursedetail(widget.courseid),
        builder: (context,snapshot){

          if(snapshot.hasData){
        return SingleChildScrollView(
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context,index){

              final coursedetail=snapshot.data![index];
            return Container(
                height: MediaQuery.of(context).size.height *0.4,
                width: MediaQuery.of(context).size.width *0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top:8,left: 3,right: 3,bottom: 5),
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 185, 184, 216),
                      ),
                      child: Text(coursedetail['section_name'],style: TextStyle(fontSize: 17,fontWeight:FontWeight.w500),),
                    ),
                      
                      if(coursedetail['lesson_name'] != null)

                      
                     Container(
                      height: 80,
                      width: 100,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(left: 3,top: 7,right: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 130, 112, 112),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[200],
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.note,color: Colors.white,),
                          ),
                         
                        ),
                         title:Text(coursedetail['lesson_name']),
                         subtitle: Text('States of accounting'),
                         trailing: IconButton(onPressed: (){}, icon:Icon(Icons.more_vert_outlined)),
                      ),
                    )
                    else
                    SizedBox.shrink(),

                      
                        if(coursedetail['assignment_name'] != null)
                    Container(
                      height: 80,
                      width: 100,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(left: 3,top: 4,right: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 130, 112, 112),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.pink,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.assessment,color: Colors.white,),
                          ),
                         
                        ),
                         title:Text(coursedetail['assignment_name']),
                         subtitle: Text('assessment u1'),
                         trailing: IconButton(onPressed: (){}, icon:Icon(Icons.more_vert_outlined)),
                      ),
                    )
                    else
                    SizedBox.shrink(),
                        
                if(coursedetail['quiz_name'] != null)        
                     Container(
                      height: 80,
                      width: 100,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(top:4,left: 3,right: 3),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 130, 112, 112),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.pink,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.quiz_rounded,color: Colors.white,),
                          ),
                         
                        ),
                         title:Text(coursedetail['quiz_name']),
                         subtitle: Text('Quize u1'),
                         trailing: IconButton(onPressed: (){}, icon:Icon(Icons.more_vert_outlined)),
                      ),
                    )
                    else
                    SizedBox.shrink(),
                      
                  
                    
                  ]
                ),
              );
          
      
      
            }
          ),
        );
        }
else if(snapshot.hasError){
  return Center(
    child: Text('Error:${snapshot.error}'),
  );
}
else{
  return Center(
    child: CircularProgressIndicator(),
  );
}


        }

      ),
    );
  }
}
