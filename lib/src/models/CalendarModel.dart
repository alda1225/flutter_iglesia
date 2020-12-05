// To parse this JSON data, do
//
//     final client = clientFromJson(jsonString);

import 'dart:convert';

Client clientFromJson(String str) => Client.fromJson(json.decode(str));

String clientToJson(Client data) => json.encode(data.toJson());

class Client {
    Client({
        this.id,
        this.fecha,
        this.titulo,
        this.descripcion,
        this.nombreLugar,
        this.latitud,
        this.longitud,
        this.urlImagen,
    });

    int id;
    DateTime fecha;
    String titulo;
    String descripcion;
    String nombreLugar;
    String latitud;
    String longitud;
    String urlImagen;

    factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json["id"],
        fecha: DateTime.parse(json["fecha"]),
        titulo: json["titulo"],
        descripcion: json["descripcion"],
        nombreLugar: json["NombreLugar"],
        latitud: json["latitud"],
        longitud: json["longitud"],
        urlImagen: json["urlImagen"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "fecha": "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "titulo": titulo,
        "descripcion": descripcion,
        "NombreLugar": nombreLugar,
        "latitud": latitud,
        "longitud": longitud,
        "urlImagen": urlImagen,
    };
}
