import 'dart:convert';

List<ListModel> listModelFromJson(String str) =>
    List<ListModel>.from(jsonDecode(str).map((x) => ListModel.fromJson(x)));
String listModelToJson(List<ListModel> data) =>
    jsonEncode(data.map((e) => e.toJson()));

class ListModel {
  String code;
  String name;
  String city;
  dynamic cityname;
  ListModel(
      {required this.code,
      required this.name,
      required this.city,
      required this.cityname});

  factory ListModel.fromJson(Map<String, dynamic> json) => ListModel(
      code: json["code"],
      name: json["name"],
      city: json["city"],
      cityname: json["cityname"]);

  Map<String, dynamic> toJson() =>
      {"code": code, "name": name, "city": city, "cityname": cityname};
}
