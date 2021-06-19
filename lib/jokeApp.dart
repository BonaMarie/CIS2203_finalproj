import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as converter;

class jokeApp extends StatefulWidget {
  @override
  _jokeAppState createState() => _jokeAppState();
}

class _jokeAppState extends State<jokeApp> {
  String joke = 'Touch Screen!!';
  Color color = Colors.blueAccent;
  List<Color> colors = [Colors.redAccent, Colors.greenAccent, Colors.greenAccent, Colors.blueAccent, Colors.orangeAccent, Colors.deepOrange, Colors.deepPurple];

  Future<dynamic> getJokes() async{
    var jokeUrl = 'https://official-joke-api.appspot.com/random_ten';
    // await response from the url 
    var response = await http.get(Uri.parse(jokeUrl));

    if(response.statusCode == 200){
        var jsonData = converter.jsonDecode(response.body);
        return jsonData;
    }
    else return null;
  }

  randomJoke(List jokes){
    var random = new Random();
    int index = random.nextInt(jokes.length ?? 0);
    int colorIndex = random.nextInt(colors.length);
    setState(() {
      color = colors[colorIndex];
      joke = '${jokes[index]['setup']} \n ${jokes[index]['punchline']}';
    });
  }

  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: PreferredSize(
          child: JokeAppBar(), preferredSize: Size(double.maxFinite, 54)),
      body: SafeArea(
        child: FutureBuilder<dynamic>(
          future: getJokes(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done)
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: (snapshot.data != null)?GestureDetector(
                    onTap: ()=> randomJoke(snapshot.data),
                    child: Text(joke ?? '', style: TextStyle(color: Colors.white, fontSize: 50), textAlign: TextAlign.center,)
                  )
                  : Text('No Jokes At This Time',  style: TextStyle(color: Colors.white, fontSize: 50), textAlign:  TextAlign.center,)
                  ),
                );
         

            else if(snapshot.connectionState == ConnectionState.waiting)
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CircularProgressIndicator( )
                ),
              );
            else return 
            Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Text('Unable To Connect'),
                ),
              );
          }
          
        ),
        ),

    );
  }
}

class JokeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Platform.isAndroid
              ? IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.grey,
              ),
              tooltip: 'Exit App',
              onPressed: () {
                SystemNavigator.pop();
              })
              : Container(),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Text(
              'Menu',
              style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Sarabun',
                  color: Colors.white),
            ),
          )
        ],
      ),
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    );
  }
}