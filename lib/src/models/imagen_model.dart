// To parse this JSON data, do
//
//     final imagenModel = imagenModelFromJson(jsonString);

import 'dart:convert';

ImagenModel imagenModelFromJson(String str) => ImagenModel.fromJson(json.decode(str));

String imagenModelToJson(ImagenModel data) => json.encode(data.toJson());

class ImagenModel {
    ImagenModel({
        this.id,
        this.descripcion,
        this.url,
    });

    String id;
    String descripcion='';
    String url='';

    factory ImagenModel.fromJson(Map<String, dynamic> json) => ImagenModel(
        id: json["id"],
        descripcion: json["descripcion"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        //"id": id,
        "descripcion": descripcion,
        "url": url,
    };
}