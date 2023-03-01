import '/model/model_magazine.dart';

import '/consttants.dart';
import '/widgets/book_rating.dart';
import '/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'detail_zurnal.dart';

class ZenanScreen extends StatefulWidget {
  @override
  State<ZenanScreen> createState() => _ZenanScreenState();
}

class _ZenanScreenState extends State<ZenanScreen> {
  String url = "";
  int? number;

  uploadDataToFirebase() async {
    // genrate random number
    //number = Random().nextInt(10);
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File pick = File(result!.files.single.path.toString());
    var file = pick.readAsBytesSync();
    String name = DateTime.now().millisecondsSinceEpoch.toString();
    // uploading file
    var pdfFile = FirebaseStorage.instance.ref().child(name).child("/.pdf");
    UploadTask task = pdfFile.putData(file);
    TaskSnapshot snapshot = await task;
    url = await snapshot.ref.getDownloadURL();
    // upload url cloud firebase
    await FirebaseFirestore.instance.collection("zenan").doc().set({
      'fileUrl': url,
      //'num': "Nesir " + number.toString() + " Zenan kalby žurnaly"
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(
                        top: size.height * .12,
                        left: size.width * .1,
                        right: size.width * .02),
                    height: size.height * .40,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/bg.png"),
                        fit: BoxFit.fitWidth,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: BookInfo(
                      size: size,
                    )),
                SizedBox(
                  height: 380,
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * .41 - 20),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("zenan")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, i) {
                              QueryDocumentSnapshot x = snapshot.data!.docs[i];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailZurnal(url: x['fileUrl'], i: i)));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 50),
                                  margin: EdgeInsets.only(bottom: 16),
                                  //width: 100,
                                  width: size.width - 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(38.5),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 10),
                                        blurRadius: 33,
                                        color:
                                            Color(0xFFD3D3D3).withOpacity(.84),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Neşir ${i+1} Zenan kalby žurnaly',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: kBlackColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            // TextSpan(
                                            //   text: magazinModel.details,
                                            //   style: TextStyle(
                                            //       color: kLightBlackColor),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      IconButton(
                                          icon: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 18,
                                          ),
                                          onPressed: (() {}))
                                    ],
                                  ),
                                ),
                              );
                              // return Container(
                              //   margin: EdgeInsets.symmetric(vertical: 10),
                              //   child: Text(x["fileUrl"]),
                              // );
                            });
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                  // child: ListView.builder(
                  //     shrinkWrap: true,
                  //     physics: BouncingScrollPhysics(),
                  //     itemCount: magazinsList.length,
                  //     itemBuilder: (context, index) {
                  //       ModelMagazin magazinModel = magazinsList[index];
                  //       return Container(
                  //         padding: EdgeInsets.symmetric(
                  //             vertical: 20, horizontal: 50),
                  //         margin: EdgeInsets.only(bottom: 16),
                  //         //width: 100,
                  //         width: size.width - 30,
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.circular(38.5),
                  //           boxShadow: [
                  //             BoxShadow(
                  //               offset: Offset(0, 10),
                  //               blurRadius: 33,
                  //               color: Color(0xFFD3D3D3).withOpacity(.84),
                  //             ),
                  //           ],
                  //         ),
                  //         child: Row(
                  //           children: <Widget>[
                  //             RichText(
                  //               text: TextSpan(
                  //                 children: [
                  //                   TextSpan(
                  //                     text:
                  //                         "Nesir ${index+1} : ${magazinModel.title} \n",
                  //                     style: TextStyle(
                  //                       fontSize: 16,
                  //                       color: kBlackColor,
                  //                       fontWeight: FontWeight.bold,
                  //                     ),
                  //                   ),
                  //                   TextSpan(
                  //                     text: magazinModel.details,
                  //                     style: TextStyle(
                  //                         color: kLightBlackColor),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             Spacer(),
                  //             IconButton(
                  //               icon: Icon(
                  //                 Icons.arrow_forward_ios,
                  //                 size: 18,
                  //               ),
                  //               onPressed: (() {

                  //               })
                  //             )
                  //           ],
                  //         ),
                  //       );
                  //     }),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                uploadDataToFirebase();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headline5,
                        children: [
                          TextSpan(
                            text: "Žurnal ",
                          ),
                          TextSpan(
                            text: "goşmak….",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Stack(
                      children: <Widget>[
                        Container(
                          height: 180,
                          width: double.infinity,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding:
                                EdgeInsets.only(left: 24, top: 24, right: 150),
                            height: 160,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(29),
                              color: Color(0xFFFFF8F9),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(color: kBlackColor),
                                    children: [
                                      TextSpan(
                                        text:
                                            "Täze çap edilen \n žurnallary goşmak\n",
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      // TextSpan(
                                      //   text: "Gary Venchuk",
                                      //   style: TextStyle(color: kLightBlackColor),
                                      // ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    // BookRating(
                                    //   score: 4.9,
                                    // ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: RoundedButton(
                                        text: "Goşmak",
                                        verticalPadding: 10,
                                        press: () {},
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Image.asset(
                            "assets/images/zenan.jpeg",
                            width: 120,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

class ChapterCard extends StatelessWidget {
  final String name;
  final String tag;
  final int chapterNumber;
  final Function press;
  const ChapterCard({
    required this.name,
    required this.tag,
    required this.chapterNumber,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      margin: EdgeInsets.only(bottom: 16),
      width: 200,
      //width: size.width - 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(38.5),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 33,
            color: Color(0xFFD3D3D3).withOpacity(.84),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Nesir $chapterNumber : $name \n",
                  style: TextStyle(
                    fontSize: 16,
                    color: kBlackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: tag,
                  style: TextStyle(color: kLightBlackColor),
                ),
              ],
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              size: 18,
            ),
            onPressed: press(),
          )
        ],
      ),
    );
  }
}

class BookInfo extends StatelessWidget {
  const BookInfo({
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Flex(
        crossAxisAlignment: CrossAxisAlignment.start,
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Zenan kalby",
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(fontSize: 28),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: this.size.height * .005),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 0),
                    child: Text(
                      "žurnaly",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: this.size.width * .3,
                            padding:
                                EdgeInsets.only(top: this.size.height * .02),
                            child: Text(
                              "Türkmen gelin-gyzlarymyzyň edebi, ekramy, milliligi….",
                              maxLines: 5,
                              style: TextStyle(
                                fontSize: 10,
                                color: kLightBlackColor,
                              ),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: this.size.height * .015),
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            // child: ElevatedButton(
                            //   onPressed: () {},
                            //   child: Text(
                            //     "Read",
                            //     style: TextStyle(fontWeight: FontWeight.bold),
                            //   ),
                            // ),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              size: 20,
                              color: Colors.grey,
                            ),
                            onPressed: () {},
                          ),
                          BookRating(score: 4.9),
                        ],
                      )
                    ],
                  )
                ],
              )),
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.transparent,
                child: Image.asset(
                  "assets/images/zenan.jpeg",
                  height: 200,
                  width: 70,
                  //height: double.infinity,
                  alignment: Alignment.topRight,
                  //fit: BoxFit.fitWidth,
                ),
              )),
        ],
      ),
    );
  }
}
