import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
  }

class _HomeState extends State<Home> {

  TextEditingController questioncontroller = TextEditingController();
  TextEditingController responsecontroller = TextEditingController();

  var isLoading = false;
  List<String> list = ["","",""];
  int counter = 0;


  translateToLanguage(String question,String response,String languageCode,int index) async{
    print("Doing");

    final translator = GoogleTranslator();
    var questionTranslated = await translator.translate(question,from: 'en',to: languageCode);
    var responseTranslated = await translator.translate(response,from: 'en',to: languageCode);

    print("done");

    setState(() {
      isLoading = false;  
      list[index] += "$counter :" + questionTranslated.text + "--------" + responseTranslated.text + "\n";
    });

  }

  // readWrite() async {
  //   print("Readwrite");

  //   // Write file
  //   var fileCopy = await File('data-copy.txt').writeAsString("Hello thisis the file");
  //   print(await fileCopy.exists());
  //   print(await fileCopy.length());
  // }

  printDownload(String text,String fileName){
    // prepare
final bytes = utf8.encode(text);
final blob = html.Blob([bytes]);
final url = html.Url.createObjectUrlFromBlob(blob);
final anchor = html.document.createElement('a') as html.AnchorElement
  ..href = url
  ..style.display = 'none'
  ..download = '$fileName.txt';
html.document.body.children.add(anchor);

// download
anchor.click();

// cleanup
html.document.body.children.remove(anchor);
html.Url.revokeObjectUrl(url);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Data Entry'),
        ),
       body: isLoading?Center(child: CircularProgressIndicator()): Column(
         mainAxisAlignment: MainAxisAlignment.spaceAround,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Padding(
             padding: EdgeInsets.all(20),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Expanded(
                     child: Padding(
                       padding: const EdgeInsets.all(15.0),
                       child: TextField(
                         controller: questioncontroller,
                       decoration: InputDecoration(
                         hintText: "Enter the question in english"
                         
                       ),
                       style: TextStyle(
                         fontSize: 20
                       ),
                   ),
                     ),
                 ),
                 Spacer(),
                 Expanded(
                     child: Padding(
                       padding: const EdgeInsets.all(15.0),
                       child: TextField(
                         controller: responsecontroller,
                       decoration: InputDecoration(
                         hintText: "Enter the response in english"
                         
                       ),
                       style: TextStyle(
                         fontSize: 20
                       ),
                   ),
                     ),
                 ),
               ],
             ),
           ),
           Text(list[0]),
           Text(list[1]),
           Text(list[2]),
          //  Padding(
          //    padding: EdgeInsets.all(20),
          //    child: Row(
          //      mainAxisAlignment: MainAxisAlignment.spaceAround,
          //      crossAxisAlignment: CrossAxisAlignment.start,
          //      children: [
          //        Expanded(
          //            child: Padding(
          //              padding: const EdgeInsets.all(15.0),
          //              child: Text(
          //                hindiquestion,
          //              style: TextStyle(
          //                fontSize: 20
          //              ),
          //          ),
          //            ),
          //        ),
          //        Spacer(),
          //        Expanded(
          //            child: Padding(
          //              padding: const EdgeInsets.all(15.0),
          //              child: Text(
          //                hindiresponse,
          //              style: TextStyle(
          //                fontSize: 20
          //              ),
          //          ),
          //            ),
          //        ),
          //      ],
          //    ),
          //  ),
           Center(
             child: ElevatedButton(
               child:Padding(
                 padding: const EdgeInsets.all(20.0),
                 child: Text('Press to translate', style: TextStyle(fontSize: 20)),
               ) ,
               onPressed: (){
                 counter+=1;
                 list[0]+= "$counter :" +questioncontroller.text + "--------" + responsecontroller.text + "\n"; 
                 translateToLanguage(questioncontroller.text ,responsecontroller.text, "hi",1);
                 translateToLanguage(questioncontroller.text, responsecontroller.text, "es",2);
                 questioncontroller.clear();
                 responsecontroller.clear();
                 isLoading = true;
               },
             ),
           ),
           Center(
             child: ElevatedButton(
               child:Padding(
                 padding: const EdgeInsets.all(20.0),
                 child: Text('Download', style: TextStyle(fontSize: 20)),
               ) ,
               onPressed: (){
                 printDownload(list[0], "english");
                 printDownload(list[1], "hindi");
                 printDownload(list[2], "spanish");
               },
             ),
           )
         ],
       ),
    );
  }
}