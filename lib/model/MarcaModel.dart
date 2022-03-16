import 'dart:convert';

class MarcaModel {
  int? Id;
  String? Descripcion;
 

  MarcaModel({this.Id, required this.Descripcion});

  factory MarcaModel.fromMap(Map<String, dynamic> json) => MarcaModel(
      Id: json['Id'],
      Descripcion: json['Descripcion'],
      );

  Map<String, dynamic> toJson() {
    return {
      'Id': Id,
      'Descripcion': Descripcion,
      
    };
  }
}
