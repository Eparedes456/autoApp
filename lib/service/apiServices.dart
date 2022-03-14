import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

class ApiServices {
  var url =
      "https://fn-fe-evaluacion-personal.azurewebsites.net/api/auto/modelo";

  loginUser(String username, String pass) async {
    var urlService = Uri.parse(url + 'auth');
    Map dataSend = {"password": pass, "username": username};
    String body = json.encode(dataSend);
    var response = await http.post(urlService,
        headers: {
          'Content-Type': 'application/json',
          //'Accept': 'application/json',
        },
        body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var decodedData = json.decode(utf8.decode(response.bodyBytes));

      return decodedData;
    } else if (response.statusCode == 500) {
      print(response);
      print('error de servidor');
      return 1;
    } else if (response.statusCode == 404) {
      print(
          'ruta no encontrada, verifique la ruta de envio, en ese caso usuario no existe');
      return 2;
    }
  }

  get(String ruta) async {
    var urlService = Uri.parse(url + ruta);
    var response = await http.get(
      urlService,
      headers: {
        'Content-Type': 'application/json',

        //'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var decodedData = json.decode(utf8.decode(response.bodyBytes));

      return decodedData;
    } else if (response.statusCode == 500) {
      print(response);
      print('error de servidor');
      return 1;
    } else if (response.statusCode == 404) {
      print(
          'ruta no encontrada, verifique la ruta de envio, en ese caso usuario no existe');
      return 2;
    } else if (response.statusCode == 401) {
      print('Token expirado');
      return 3;
    }
  }

  posts(ruta, data) async {
    var sendData = json.encode(data);
    print(sendData);

    print(url + ruta);
    var urlService = Uri.parse("$url$ruta");
    print(urlService); //Uri.parse(url+ruta);
    var response = await http.post(urlService,
        headers: {
          'Content-Type': 'application/json',

          //'Accept': 'application/json',
        },
        body: sendData);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var decodedData = json.decode(utf8.decode(response.bodyBytes));

      return decodedData["result"];
    } else if (response.statusCode == 500) {
      print(response.body);
      print('error de servidor');
      return 1;
    } else if (response.statusCode == 404) {
      print(response.body);
      return 2;
    } else {
      print("Error 500 server");
    }
  }

  updated(ruta, data) async {
    var sendData = json.encode(data);
    print(sendData);

    print(url + ruta);
    var urlService = Uri.parse("$url$ruta");
    print(urlService); //Uri.parse(url+ruta);
    var response = await http.put(
      urlService,
      headers: {
        'Content-Type': 'application/json',

        //'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var decodedData = json.decode(utf8.decode(response.bodyBytes));

      return decodedData["result"];
    } else if (response.statusCode == 500) {
      print(response.body);
      print('error de servidor');
      return 1;
    } else if (response.statusCode == 404) {
      print(response.body);
      return 2;
    } else {
      print("Error 500 server");
    }
  }

  updatedParameter(ruta) async {
    print(url + ruta);
    var urlService = Uri.parse("$url$ruta");
    print(urlService); //Uri.parse(url+ruta);
    var response = await http.put(
      urlService,
      headers: {
        'Content-Type': 'application/json',

        //'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var decodedData = json.decode(utf8.decode(response.bodyBytes));

      return decodedData;
    } else if (response.statusCode == 500) {
      print(response.body);
      print('error de servidor');
      return 1;
    } else if (response.statusCode == 404) {
      print(response.body);
      return 2;
    } else {
      print("Error 500 server");
    }
  }

  delete1(String ruta) async {
    var urlService = Uri.parse("$url$ruta");
    print(urlService);
    var response = await http.delete(
      urlService,
      headers: {
        'Content-Type': 'application/json',

        //'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var decodedData = json.decode(utf8.decode(response.bodyBytes));

      return decodedData;
    } else if (response.statusCode == 500) {
      print(response);
      print('error de servidor');
      return 1;
    } else if (response.statusCode == 404) {
      print(
          'ruta no encontrada, verifique la ruta de envio, en ese caso usuario no existe');
      var decodedData = json.decode(utf8.decode(response.bodyBytes));
      return decodedData;
    }
  }
}
