import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_gallery/gallery/gallery.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class MyGallery extends StatefulWidget {
  @override
  _MyGalleryState createState() => _MyGalleryState();
}

class _MyGalleryState extends State<MyGallery> {

  final fb = FirebaseDatabase.instance.reference().child("MyImages");
  List<String> itemList=new List();
  List<String> listHeader=["Gallery"];
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        itemList.length==0?Text("Loading"):Container(
          height: height-380,
          child: ListView.builder(
              itemCount: listHeader.length,
              itemBuilder: (context, index) {
                return new StickyHeader(
                  header: new Container(
                    height: 38.0,
                    color: Colors.transparent,
                    padding: new EdgeInsets.symmetric(horizontal: 12.0),
                    alignment: Alignment.centerLeft,
                    child: new Text(listHeader[index],
                      style: const TextStyle(color: Colors.purple, fontSize: 20,fontWeight: FontWeight.bold),
                    ),
                  ),
                  content: Container(
                    color: Colors.white,
                    child: Card(
                      color: Colors.white,
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: itemList.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,childAspectRatio: 1,),
                          itemBuilder: (contxt, indx){
                            return GestureDetector(
                              child:  Padding(
                                padding: const EdgeInsets.all(4),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new NetworkImage(
                                          itemList[indx],
                                        ),
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(width: 3,color: Color(0xff9C27B0),style: BorderStyle.solid)
                                  ),
                                ),
                              ),
                            );
                          }
                      ),
                    ),
                  ),
                );
              }
          ),
        ),
        Container(
          height: 240,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Gallery(
              activeItemColor: Colors.purple,
              backgroundColor: Color(0xFFF3F3F3),
              carouselBackgroundColor: Colors.purple[100],
              children: List<Widget>.generate(
                10,
                    (index) => Image.network(
                  'https://picsum.photos/960/540?image=$index',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void initState() {
    //get data from firebase and store in list
  }
}
