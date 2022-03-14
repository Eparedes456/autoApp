import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pruebatecnica/controller/PrincipalController.dart';

class PrincipalPage extends StatelessWidget {
  const PrincipalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrincipalController>(
      init: PrincipalController(),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text('Mis vehiculos'),
          centerTitle: true,
          leading: Icon(Icons.menu),
          actions: [
            IconButton(
                onPressed: () {
                  _.getAllBD();
                },
                icon: Icon(Icons.refresh))
          ],
        ),
        body: Container(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text('Estos son tus vehiculos registrados'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tienes ${_.listMostrar.length} vehiculos'),
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Expanded(
                child: _.hayData == false && _.loading == true
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator()),
                          ),
                        ],
                      )
                    : _.hayData == false && _.loading == false ||
                            _.listMostrar.length == 0
                        ? Center(
                            child: Text('No hay datos que mostrar'),
                          )
                        : ListView.builder(
                            itemCount: _.listMostrar.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 10,
                                            bottom: 10),
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Icon(Icons.local_shipping),
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _.listMostrar[index]
                                                                .Descripcion ==
                                                            "" ||
                                                        _.listMostrar[index]
                                                                .Descripcion ==
                                                            null
                                                    ? Text(
                                                        'Placa : No registra')
                                                    : Text(
                                                        "Placa : ${_.listMostrar[index].Descripcion}"),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                _.listMostrar[index].marca ==
                                                            null ||
                                                        _.listMostrar[index]
                                                                .marca ==
                                                            ""
                                                    ? Text(
                                                        "Marca : No registra")
                                                    : Text(
                                                        "Marca : ${_.listMostrar[index].marca}"),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                _.listMostrar[index]
                                                                .kilometraje ==
                                                            null ||
                                                        _.listMostrar[index]
                                                                .kilometraje ==
                                                            ""
                                                    ? Text(
                                                        "Kilometraje : No registra")
                                                    : Text(
                                                        "Kilometraje : ${_.listMostrar[index].kilometraje}"),
                                              ],
                                            )),
                                            GestureDetector(
                                              onTap: () {
                                                _.deleteAuto(
                                                    _.listMostrar[index]);
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color:
                                                    Colors.red.withOpacity(0.5),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _.getOne(_.listMostrar[index].Id!);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 25, right: 25),
                                          child: Container(
                                            height: 45,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: Colors.teal,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Center(
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.edit,
                                                    color: Colors.white),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  'Editar',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            )),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _.modalInsert();
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
