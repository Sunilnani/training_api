// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Welcome {
  Welcome({
    this.genreId,
    this.genreName,
    this.channels,
  });

  int genreId;
  String genreName;
  List<Channel> channels;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    genreId: json["genre_id"],
    genreName: json["genre_name"],
    channels: List<Channel>.from(json["channels"].map((x) => Channel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "genre_id": genreId,
    "genre_name": genreName,
    "channels": List<dynamic>.from(channels.map((x) => x.toJson())),
  };
}

class Channel {
  Channel({
    this.channelId,
    this.image,
    this.genre,
    this.nameOfCountry,
    this.channelType,
    this.created,
    this.updated,
  });

  int channelId;
  String image;
  String genre;
  String nameOfCountry;
  bool channelType;
  DateTime created;
  DateTime updated;

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
    channelId: json["channel_id"],
    image: json["image"] == null ? null : json["image"],
    genre: json["genre"],
    nameOfCountry: json["name_of_country"],
    channelType: json["channel_type"],
    created: DateTime.parse(json["created"]),
    updated: DateTime.parse(json["updated"]),
  );

  Map<String, dynamic> toJson() => {
    "channel_id": channelId,
    "image": image == null ? null : image,
    "genre": genre,
    "name_of_country": nameOfCountry,
    "channel_type": channelType,
    "created": created.toIso8601String(),
    "updated": updated.toIso8601String(),
  };
}
