

import 'package:fachowcy_app/Data/ServiceCard.dart';

class UserProfileData {

  final int userId;
  final String email;
  final String password;
  final String name;
  final String lastName;
  final String phoneNumber;
  final String profilePhoto;
  final String description;
  final String role;
  final String createdAt;
  final List<ServiceCardList> serviceCardLists;

  UserProfileData({this.userId, this.email, this.password, this.name, this.lastName, this.phoneNumber, this.profilePhoto, this.description, this.role, this.createdAt, this.serviceCardLists, });

  factory UserProfileData.fromJson(Map<String, dynamic> json) => UserProfileData(
    userId: json['userId'] == null ? null : json['userId'],
    email: json['email'] == null ? null : json['email'],
    password: json['password'] == null ? null : json['password'],
    name: json['name'] == null ? null : json['name'],
    lastName: json['lastName'] == null ? null : json['lastName'],
    phoneNumber: json['phoneNumber'] == null ? null : json['phoneNumber'],
    profilePhoto: json['profilePhoto'] == null ? null : json['profilePhoto'],
    description: json['description'] == null ? null : json['description'],
    role: json['role'] == null ? null : json['role'],
    createdAt: json['createdAt'] == null ? null : json['createdAt'],
    serviceCardLists: json['serviceCardList'] == null ? null : List<ServiceCardList>.from(json['serviceCardList'].map((x) => ServiceCardList.fromJson(x))),
  );
}

class ServiceCardList {

  final int serviceCardId;
  final String title;
  final String category;
  final String photo;
  final String serviceType;
  final String description;
  final String location;
  final String estimatedTime;
  final String createdAt;
  final bool active;

  ServiceCardList({this.serviceCardId, this.title, this.category, this.photo, this.serviceType, this.description, this.location, this.estimatedTime, this.createdAt, this.active, });

  factory ServiceCardList.fromJson(Map<String, dynamic> json) => ServiceCardList(
    serviceCardId: json['serviceCardId'] == null ? null : json['serviceCardId'],
    title: json['title'] == null ? null : json['title'],
    category: json['category'] == null ? null : json['category'],
    photo: json['photo'] == null ? null : json['photo'],
    serviceType: json['serviceType'] == null ? null : json['serviceType'],
    description: json['description'] == null ? null : json['description'],
    location: json['location'] == null ? null : json['location'],
    estimatedTime: json['estimatedTime'] == null ? null : json['estimatedTime'],
    createdAt: json['createdAt'] == null ? null : json['createdAt'],
    active: json['active'] == null ? null : json['active'],
  );

}