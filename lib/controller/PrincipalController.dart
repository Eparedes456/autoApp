import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pruebatecnica/database/database.dart';
import 'package:pruebatecnica/model/AutoModel.dart';
import 'package:pruebatecnica/service/apiServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrincipalController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    Future.delayed(Duration(milliseconds: 500), () {
      this.validar();
    });
  }

  ApiServices apiServices = ApiServices();
  List<AutoModel> listAuto = [];
  List<AutoModel> listMostrar = [];
  bool hayData = false;
  bool loading = true;
  TextEditingController placa = TextEditingController();
  TextEditingController marca = TextEditingController();
  TextEditingController kilometraje = TextEditingController();

  validar() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var primeraVez = await preferences.getString("primera");
    if (primeraVez == null || primeraVez == "") {
      await preferences.setString("primera", "si");
      await getAllAutos();
    } else {
      hayData = true;
      loading = false;
      await getAllBD();
    }
  }

  getAllAutos() async {
    listAuto = [];
    //showLoading();

    var response = await apiServices.get("");
    print(response);

    response.forEach((items) {
      listAuto.add(AutoModel(
          Id: items["Id"],
          Descripcion: "",
          marca: items["Descripcion"],
          kilometraje: ""));
    });

    for (var i = 0; i < listAuto.length; i++) {
      await DBProvider.db.insert(listAuto[i]);
    }

    listMostrar = await DBProvider.db.getAllAutos();
    print(listMostrar);

    if (listMostrar.length > 0) {
      loading = false;
      hayData = true;
    }

    update();
    //Get.back();
  }

  modalInsert() async {
    Get.dialog(AlertDialog(
      title: Text('Insertar un nuevo auto'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: placa,
            decoration: InputDecoration(hintText: 'Ingrese la placa'),
          ),
          TextField(
            controller: marca,
            decoration: InputDecoration(hintText: 'Ingrese la marca'),
          ),
          TextField(
            controller: kilometraje,
            decoration: InputDecoration(hintText: 'Ingrese el kilometraje'),
          ),
          ElevatedButton(
              onPressed: () {
                saveAuto();
              },
              child: Text('Guardar'))
        ],
      ),
    ));
  }

  modalEdit(idAuto) async {
    Get.dialog(AlertDialog(
      title: Text('Editar un auto'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: placa,
            decoration: InputDecoration(hintText: 'Ingrese la placa'),
          ),
          TextField(
            controller: marca,
            decoration: InputDecoration(hintText: 'Ingrese la marca'),
          ),
          TextField(
            controller: kilometraje,
            decoration: InputDecoration(hintText: 'Ingrese el kilometraje'),
          ),
          ElevatedButton(
              onPressed: () {
                editAuto(idAuto);
              },
              child: Text('Guardar'))
        ],
      ),
    ));
  }

  saveAuto() async {
    AutoModel data = AutoModel(
        Descripcion: placa.text,
        marca: marca.text,
        kilometraje: kilometraje.text);

    var respuesta = await DBProvider.db.insert(data);
    print(respuesta);
    if (respuesta != 0) {
      placa.clear();
      marca.clear();
      kilometraje.clear();
      Get.back();
      await getAllBD();
    }
  }

  editAuto(idAuto) async {
    AutoModel data = AutoModel(
        Id: idAuto,
        Descripcion: placa.text,
        marca: marca.text,
        kilometraje: kilometraje.text);

    var respuesta = await DBProvider.db.updateFicha(data);
    print(respuesta);
    if (respuesta != 0) {
      placa.clear();
      marca.clear();
      kilometraje.clear();
      Get.back();
      await getAllBD();
    }
  }

  getAllBD() async {
    listMostrar = [];

    listMostrar = await DBProvider.db.getAllAutos();
    update();
  }

  getOne(int idAuto) async {
    List<AutoModel> oneAuto = await DBProvider.db.one(idAuto);
    print(oneAuto);
    placa = TextEditingController(text: oneAuto[0].Descripcion);
    marca = TextEditingController(text: oneAuto[0].marca);
    kilometraje = TextEditingController(text: oneAuto[0].kilometraje);
    modalEdit(oneAuto[0].Id);
  }

  deleteAuto(AutoModel auto) async {
    var data = await DBProvider.db.deletee(auto);
    print(data);
    await getAllBD();
  }

  showLoading(mensaje) async {
    Get.dialog(AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 8,
              ),
              Text(mensaje)
            ],
          )
        ],
      ),
    ));
  }
}
