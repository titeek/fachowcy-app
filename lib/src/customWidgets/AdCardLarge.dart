import 'package:fachowcy_app/Config/Config.dart';
import 'package:fachowcy_app/Data/AdData.dart';
import 'package:fachowcy_app/Data/SimilarAdsData.dart';
import 'package:fachowcy_app/src/UserProfile.dart';
import 'package:fachowcy_app/src/customWidgets/CustomAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../ProfileFromAd.dart';
import 'AdCardSmall.dart';

class AdCardLarge extends StatelessWidget {

  int id;

  AdCardLarge(int id) {
    this.id = id;
  }

  static var adData;
  static int index;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueGrey,
        child: CustomScrollView(
          slivers: <Widget>[
            CustomAppBar(),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      Card(
                        color: Colors.blueGrey, //TODO: Zmienić kolor i dopasować do tła reszty
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(width: 4, color: Colors.white),
                        ),
                        child: Container(
                          //decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 4.0)),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 16),
                              HorizontalFotoSection(adData.serviceCardLists[index].photo, adData.serviceCardLists[index].serviceCardPhoto_2, adData.serviceCardLists[index].serviceCardPhoto_3, adData.serviceCardLists[index].serviceCardPhoto_4),
                              Container(
                                margin: const EdgeInsets.all(12),
                                child: Column(
                                  children: <Widget>[
                                    TextSection(adData.serviceCardLists[index].title, adData.serviceCardLists[index].estimatedTime, adData.serviceCardLists[index].description),
                                    SizedBox(height: 16),
                                    UserProfileShort(adData.name , adData.lastName, adData.profilePhoto, id),
                                    SizedBox(height: 16),
                                    LocalizationSection(adData.serviceCardLists[index].location, adData.phoneNumber),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 16),
                          Text("Podobne ogłoszenia", style: new TextStyle(color: Colors.white, fontSize: 24)),
                          SimilarAds(adData.serviceCardLists[index].category, adData.serviceCardLists[index].location),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }


  static Future<int> getAdDataByAdId(int id) async {
    var UserXML = {};

    UserXML["serviceCardId"] = id;
    String serviceCardId = json.encode(UserXML);

    final http.Response response = await http.post(
      Config.serverHostString + '/api/service-card/findbyID',
      headers: {'Content-Type': 'application/json'},
      body: serviceCardId,
    );

    Map cardDataMap = jsonDecode(response.body);
    var cardData = AdData.fromJson(cardDataMap);
    int indexx;

    for(int i = 0; i < cardData.serviceCardLists.length; i++) {
      if(cardData.serviceCardLists[i].serviceCardId == id) {
        indexx = i;
        break;
      }
    }

    // TODO: CHECK THE REPOSONE NUMBERS

    if ((response.statusCode >= 200) && (response.statusCode <= 299)) {

      adData = cardData;
      index = indexx;
      print("Ad data received from server");
      return response.statusCode;
    } else {
      throw new Exception('Failed to load ad data.');
    }
  }
}

//TODO: rozszerzyć to do FutureBuildera
class SimilarAds extends StatelessWidget {

  static var similarAdsData;
  String category;
  String location;

  SimilarAds(String category, String location) {
    this.category = category;
    this.location = location;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
          future: getSimilarAds(category, location),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            int numberOfAds = similarAdsData.length;
            if (numberOfAds == 0) {
              return Column(
                children: <Widget>[
                  Text(
                    "Nie ma podobnych ogłoszeń",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  SizedBox(height: 40),
                ],
              );
            }
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text(
                    "Loading..",
                    style: new TextStyle(fontSize: 50),
                  ),
                ),
              );
            } else {
              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: numberOfAds,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 0.56, //TODO: zrobić to mądrzej
                ),
                itemBuilder: (BuildContext context, int index) {
                  return AdCardSmall(
                    false,
                    similarAdsData[index].title,
                    similarAdsData[index].description,
                    similarAdsData[index].serviceCardId,
                    similarAdsData[index].photo,
                  );
                },
              );
            }
          },
        ));
  }


  static Future<int> getSimilarAds(String category, String location) async {
    SimilarAdsData similarAdsDataFuture = new SimilarAdsData();

    final response = await http.get(
        Config.serverHostString + "/api/service-card/similarCard?category="
            + category + "&location=" + location
    );

    if ((response.statusCode >= 200) && (response.statusCode <= 299)) {
      similarAdsData = similarAdsDataFuture.parseServiceCard(response.body);
      print("Similar ads data received");
      return response.statusCode;
    } else {
      throw Exception('Failed to load similar ads.');
    }
  }
}

class TextSection extends StatelessWidget {

  String title;
  String estimatedTime;
  String text;

  TextSection(String title, String estimatedTime, String text) {
    this.title = title;
    this.estimatedTime = estimatedTime;
    this.text = text;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 32),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 16),
        Row(
          children: <Widget>[
            Icon(Icons.timer, color: Colors.green),
            SizedBox(width: 8),
            Text(
              estimatedTime,
              style: new TextStyle(color: Colors.white, fontSize: 24),
            ),

          ],
        ),
        SizedBox(height: 16),
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          maxLines: 8,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

}

class LocalizationSection extends StatelessWidget {

  String location;
  String phone;

  LocalizationSection(String location, String phone) {
    this.location = location;
    this.phone = phone;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(Icons.location_on, color: Colors.white),
            SizedBox(width: 8),
            Text(
              location,
              style: new TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: <Widget>[
            Icon(Icons.phone, color: Colors.white),
            SizedBox(width: 8),
            Text(
              phone,
              style: new TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

}

class UserProfileShort extends StatelessWidget {

  String name;
  String lastName;
  String photoLink;
  int id;

  UserProfileShort(String name, String lastName, String photoLink, int id) {
    this.name = name;
    this.lastName = lastName;
    this.photoLink = photoLink;
    this.id = id;
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        await ProfileFromAd.getProfileDataByAdId(id);

        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileFromAd(id)));
      },
      child: Row(
        children: <Widget>[
          Icon(Icons.person, color: Colors.white),
          SizedBox(width: 8),
          Column(
            children: <Widget>[
              Text(
                name,
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              Text(
                lastName,
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ],
          ),
          SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: photoLink == null ?
            Container(color: Colors.grey, width: 60, height: 60, child: Center(child: Icon(Icons.no_photography, size: 32.0,),),) :
            Image.network(photoLink, width: 60, height: 60, fit: BoxFit.contain)
          ),

        ],
      ),
    );
  }

}

class HorizontalFotoSection extends StatelessWidget {

  String photo_1;
  String photo_2;
  String photo_3;
  String photo_4;


  HorizontalFotoSection(String photo_1, String photo_2, String photo_3, String photo_4) {
    this.photo_1 = photo_1;
    this.photo_2 = photo_2;
    this.photo_3 = photo_3;
    this.photo_4 = photo_4;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[

              photo_1 == "link_to_photo" ?
              Container(color: Colors.grey, width: 320, height: 200, child: Center(child: Icon(Icons.no_photography, size: 32.0,),),) :
              Image.network(photo_1, width: 320, height: 200, fit: BoxFit.contain),

              photo_2 == null ?
              SizedBox(width: 0.01,) :
              // Container(color: Colors.grey, width: 320, height: 200, child: Center(child: Icon(Icons.no_photography, size: 32.0,),),) :
              Image.network(photo_2, width: 320, height: 200, fit: BoxFit.contain),

              photo_3 == null ?
              SizedBox(width: 0.01,) :
              //Container(color: Colors.grey, width: 320, height: 200, child: Center(child: Icon(Icons.no_photography, size: 32.0,),),) :
              Image.network(photo_3, width: 320, height: 200, fit: BoxFit.contain),

              photo_4 == null ?
              SizedBox(width: 0.01,) :
              //Container(color: Colors.grey, width: 320, height: 200, child: Center(child: Icon(Icons.no_photography, size: 32.0,),),) :
              Image.network(photo_4, width: 320, height: 200, fit: BoxFit.contain),

            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

}