import 'dart:io';
import 'dart:math';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as converter;
import 'package:transparent_image/transparent_image.dart';
import 'package:children/children.dart';
import 'main.dart';
import 'package:like_button/like_button.dart';

class jokeApp extends StatefulWidget {
  @override
  _jokeAppState createState() => _jokeAppState();
}

class _jokeAppState extends State<jokeApp> {
  String joke = 'Tap to Tell a Joke!!';
  Color color = Colors.blueAccent;
  List<Color> colors = [Colors.redAccent, Colors.greenAccent, Colors.greenAccent, Colors.blueAccent, Colors.orangeAccent, Colors.deepOrange, Colors.deepPurple];

  bool _isFavorite = false ;

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
      appBar: AppBar(
        title: Text("JokesOnYou", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: <Widget>[

          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ]
      ),
      body: SafeArea(
        child: FutureBuilder<dynamic>(
          future: getJokes(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done)
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      QuoteImage(),
                      (snapshot.data != null)?GestureDetector(
                      onTap: ()=> randomJoke(snapshot.data),
                      child: Text(joke ?? '', style: TextStyle(fontFamily: 'Roboto Slab',color: Colors.white, fontSize: 30), textAlign: TextAlign.center,)
                    )
                    : Text('No Jokes At This Time',  style: TextStyle(fontFamily: 'Roboto Slab',color: Colors.white, fontSize: 30), textAlign:  TextAlign.center,),
                      QuoteImage(
                        isTopImage : false
                      ),
                      Text('Tell a New Joke!', style: TextStyle(color: Colors.grey))
                    ]),
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
  void handleClick(String value) {
    switch (value) {
      case 'Logout':
          Navigator.push(context,
            MaterialPageRoute(builder: (_) => LoginDemo()));
        break;
    }
  }
}


class QuoteImage extends StatelessWidget {
  final bool isTopImage;

  const QuoteImage({Key key, this.isTopImage = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Padding(
        padding: EdgeInsets.only(
            top: isTopImage ? 0.0 : 10.0, bottom: isTopImage ? 10.0 : 0.0),
        child: Align(
          alignment: isTopImage ? Alignment.topLeft : Alignment.bottomRight,
          child: SizedBox(
            child: FadeInImage(
              fadeInDuration: Duration(milliseconds: 300),
              placeholder: MemoryImage(kTransparentImage),
              fadeInCurve: Curves.easeInOut,
              image: AssetImage(
                isTopImage
                    ? 'assets/images/left-quote.png'
                    : 'assets/images/right-quote.png',
              ),
            ),
            height: 80,
          ),
        ),
      ),
    );
  }
}
