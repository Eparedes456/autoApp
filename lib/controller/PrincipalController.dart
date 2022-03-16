import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pruebatecnica/database/database.dart';
import 'package:pruebatecnica/model/AutoModel.dart';
import 'package:pruebatecnica/model/MarcaModel.dart';
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
  List<MarcaModel> marcas = [];
  bool hayData = false;
  bool loading = true;
  TextEditingController placa = TextEditingController();
  TextEditingController marca = TextEditingController();
  TextEditingController kilometraje = TextEditingController();
  String? valueMarca;

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

      marcas.add(MarcaModel(
          Id: items["Id"],
          Descripcion: items["Descripcion"],
      ));
    });

    for (var i = 0; i < marcas.length; i++) {
      await DBProvider.db.insertMarca(marcas[i]);
    }

    listMostrar = await DBProvider.db.getAllAutos();
    print(listMostrar);

    if (marcas.length > 0) {
      loading = false;
      hayData = true;
    }

    update();
    //Get.back();
  }

  modalInsert(context) async {
    Get.dialog(AlertDialog(
      title: Text('Insertar un nuevo auto'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
      
            Text('Elige la marca'),
             Container(
               height: 45,
                width:double.infinity
                                              ,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 1,
                                                  offset: Offset(0, 2),
                                                )
                                              ],
                                              color: Colors.white),
               child: GetBuilder<PrincipalController>(
                                              id: 'marca',
                                              builder: (_) => Center(
                                                  child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: DropdownButton<String>(
                                                  value: _.valueMarca,
                                                  hint: Text(
                                                    'Seleccione',
                                                    textAlign: TextAlign.justify,
                                                  ),
                                                  icon: const Icon(Icons
                                                      .keyboard_arrow_down_outlined),
                                                  iconSize: 24,
                                                  elevation: 16,
                                                  isExpanded: true,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  underline: Container(
                                                    height: 2,
                                                    color: Colors.transparent,
                                                  ),
                                                  onChanged: (newValue) {
                                                    print(newValue);
                                                  },
                                                  items: _.marcas
                                                      .map((marca) {
                                                    return DropdownMenuItem(
                                                      child: Text(
                                                        marca.Descripcion
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.justify,
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                      ),
                                                      value: marca.Descripcion
                                                          .toString(),
                                                      onTap: () {
                                                        print( marca.Descripcion);
                                                        _.selectMarca(marca.Descripcion);
                                                      },
                                                    );
                                                  }).toList(),
                                                ),
                                              )),
                                            ),
             ),
            SizedBox(height:20),
            TextField(
              controller: placa,
              decoration: InputDecoration(hintText: 'Ingrese la placa'),
            ),
      
            
      
            
             SizedBox(height:12),
                                        
            /*TextField(
              controller: marca,
              decoration: InputDecoration(hintText: 'Ingrese la marca'),
            ),*/
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
      ),
    ));
  }

  selectMarca(marcaSelec)async{

    valueMarca = marcaSelec;
    update(['marca']);

  }

  modalEdit(idAuto) async {
    Get.dialog(AlertDialog(
      title: Text('Editar un auto'),
      content: SingleChildScrollView(
        child: Column(
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
      ),
    ));
  }

  saveAuto() async {
    AutoModel data = AutoModel(
        Descripcion: placa.text,
        marca: valueMarca,
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
