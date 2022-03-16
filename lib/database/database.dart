import 'package:path/path.dart';
import 'package:pruebatecnica/model/AutoModel.dart';
import 'package:pruebatecnica/model/MarcaModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(join(await getDatabasesPath(), 'prueba2.db'),
        onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE autos(

            Id INTEGER PRIMARY KEY AUTOINCREMENT,
            Descripcion TEXT,
            marca TEXT,
            kilometraje TEXT
            
          )
          ''');

      await db.execute('''
          CREATE TABLE marca(

            Id INTEGER PRIMARY KEY AUTOINCREMENT,
            Descripcion TEXT
           
            
          )
          ''');
    }, version: 6);
  }

  getAllAutos() async {
    final db = await database;
    var respuesta = await db?.query("autos");

    List<AutoModel> listAuto = respuesta!.isNotEmpty
        ? respuesta.map((e) => AutoModel.fromMap(e)).toList()
        : [];

    return listAuto;
  }

  insert(AutoModel auto) async {
    final db = await database;
    var respuesta = await db?.insert("autos", auto.toJson());
    return respuesta;
  }

  insertMarca(MarcaModel marca) async {
    final db = await database;
    var respuesta = await db?.insert("marca", marca.toJson());
    return respuesta;
  }

  deletee(AutoModel auto) async {
    final db = await database;
    var respuesta =
        await db?.delete("autos", where: 'Id = ?', whereArgs: [auto.Id]);
    return respuesta;
  }

  one(idAuto) async {
    final db = await database;
    var response = await db?.rawQuery('''
      SELECT * FROM autos WHERE  Id = $idAuto
      ''');
    List<AutoModel> fichaList = response!.isNotEmpty
        ? response.map((e) => AutoModel.fromMap(e)).toList()
        : [];
    return fichaList;
  }

  updateFicha(AutoModel autoEdit) async {
    final db = await database;
    var response2 = await db?.update('autos', autoEdit.toJson(),
        where: 'Id = ?', whereArgs: [autoEdit.Id]);

    return response2;
    //return response;
  }

  eliminarAuto(int idAuto) async {
    final db = await database;

    var response = await db?.rawQuery('''
      
      DELETE FROM autos WHERE Id = $idAuto  

      ''');

    return response;
  }
}
