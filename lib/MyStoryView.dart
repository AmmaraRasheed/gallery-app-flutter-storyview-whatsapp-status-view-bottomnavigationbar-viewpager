import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as Path;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:toast/toast.dart';

class MyStoryView extends StatefulWidget {
  @override
  _MyStoryViewState createState() => _MyStoryViewState();
}

class _MyStoryViewState extends State<MyStoryView> {

  dynamic fb;
  List<String> itemList;
  File image;
  String _uploadedFileURL;
//  final StoryController controller = StoryController();
  String CreateCryptoRandomString([int length = 32]) {
    //create key
  }
  final StoryController controller = StoryController();

  @override
  Widget build(BuildContext context) {
    // get height and width
    double width;
    double height;

    Widget LoadImages(){
      return Expanded(
        child: itemList.length==0?Text("Loading"):ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount:itemList.length,
          itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Container(
                height: 60,
                width: 60,
                decoration:  BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xff9C27B0),
                  ),
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        itemList[index],
                      )
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(
          8,
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
              child: Container(
                height: 60,
                width: width,
                child: LoadImages(),
              ),
            ),
            itemList.length==0?Text("Loading"): Expanded(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      height: height-290,
                      child: StoryView(
                          controller: controller,
                          storyItems: [
                          for (var i in itemList)show1(i)
                ],
                progressPosition: ProgressPosition.bottom,
                repeat: false,
                inline: true,
              ),
            ),
            Material(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MoreStories()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(8))),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "View more stories",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //getImage()
        },
        backgroundColor: Colors.transparent,
        child: Icon(
          Icons.add,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  show1(String data){
    return StoryItem.inlineImage(
      url: data,
      controller: controller,
      caption: Text(
        "EasyCoding With AMMARA",
        style: TextStyle(
          color: Colors.white,
          backgroundColor: Colors.black54,
          fontSize: 17,
        ),
      ),
    );
  }



  @override
  void initState() {
    fb.once().then((DataSnapshot snap){
      var data=snap.value;
      itemList.clear();
      data.forEach((key,value) {
        //store data in listitem
      });
      setState(() {
      });
    });
  }

  Future<void> getImage() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((img){
      //store image in image
    });
    StorageReference storageReference = FirebaseStorage.instance
        .ref().child('new/${Path.basename(image.path)}}');

    StorageUploadTask uploadTask = storageReference.putFile(image);

    await uploadTask.onComplete;

    storageReference.getDownloadURL().then((fileURL) {
      _uploadedFileURL = fileURL;
      if(_uploadedFileURL!=null){
        dynamic key=CreateCryptoRandomString(32);
        fb.child(key).set({
          "id": key,
          "link": _uploadedFileURL,
        }).then((value) {
          ShowToastNow();
        });
      }else{
        print("url is null");
      }
    });
  }
  ShowToastNow(){
    //show toast
  }
}
class MoreStories extends StatefulWidget {
  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}
class _MoreStoriesState extends State<MoreStories> {
  final storyController = StoryController();

  @override
  void dispose() {
    //dispose contrioller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryView(
        storyItems: [
          StoryItem.text(
            title: "EasyCoding With Ammara",
            backgroundColor: Colors.purple[500],

          ),
          StoryItem.text(
            title: "Amazing\n\nTap to continue.",
            backgroundColor: Colors.pink[500],
            textStyle: TextStyle(
              fontFamily: 'Dancing',
              fontSize: 40,
            ),
          ),
          StoryItem.pageImage(
            url:
            "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
            caption: "Still sampling",
            controller: storyController,
          ),
          StoryItem.pageImage(
              url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
              caption: "Working with gifs",
              controller: storyController),
        ],
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      ),
    );
  }
}
