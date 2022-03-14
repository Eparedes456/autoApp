import 'dart:convert';

class AutoModel {
  int? Id;
  String? Descripcion;
  String? marca;
  String? kilometraje;

  AutoModel({this.Id, required this.Descripcion, this.marca, this.kilometraje});

  factory AutoModel.fromMap(Map<String, dynamic> json) => AutoModel(
      Id: json['Id'],
      Descripcion: json['Descripcion'],
      marca: json['marca'],
      kilometraje: json['kilometraje']);

  Map<String, dynamic> toJson() {
    return {
      'Id': Id,
      'Descripcion': Descripcion,
      'marca': marca,
      'kilometraje': kilometraje
    };
  }
}
