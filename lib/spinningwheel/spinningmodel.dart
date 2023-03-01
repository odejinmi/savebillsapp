// To parse this JSON data, do
//
//     final spinningmodel = spinningmodelFromJson(jsonString);

import 'dart:convert';

List<Spinningmodel> spinningmodelFromJson(String str) => List<Spinningmodel>.from(json.decode(str).map((x) => Spinningmodel.fromJson(x)));

String spinningmodelToJson(List<Spinningmodel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Spinningmodel {
  Spinningmodel({
    required this.id,
    required this.name,
    required this.qty,
    required this.type,
    required this.network,
    required this.coded,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  int qty;
  String type;
  String network;
  String coded;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  factory Spinningmodel.fromJson(Map<String, dynamic> json) => Spinningmodel(
    id: json["id"],
    name: json["name"],
    qty: json["qty"],
    type: json["type"],
    network: json["network"],
    coded: json["coded"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "qty": qty,
    "type": type,
    "network": network,
    "coded": coded,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
