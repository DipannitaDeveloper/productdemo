
import 'package:productlist/product.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:path/path.dart';

class DBHelper{
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String LAUNCHAT = 'launchedAt';
  static const String POPULAROTY = 'popularity';
  static const String LAUNCHSITE = 'launchSite';
  static const String TABLE = 'Product';
  static const String DB_NAME = 'employee.db';
  static const int DB_VERSION = 1;
  Future<Database> get db async
  {
    if (_db != null)
      {
        return _db;
      }
    _db = await initDb();
    return _db;
  }

  initDb() async
  {
    Directory documentdirectory = await getApplicationDocumentsDirectory();
    String path = join(documentdirectory.path,DB_NAME);
    var db = await(openDatabase(path,version:DB_VERSION, onCreate: _onCreate ));
    return db;
  }

  _onCreate(Database db, int version) async
  {
    await db.execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $NAME TEXT, $LAUNCHAT TEXT , $POPULAROTY TEXT, $LAUNCHSITE TEXT)");
  }

  Future<Product> save(Product employee) async
  {
    var dbClient  = await db;
    employee.id = await dbClient.insert(TABLE, employee.toMap());
  }

    Future<List<Product>> getProducts() async
    {
      var dbClient = await db;
      List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME, LAUNCHAT, LAUNCHSITE, POPULAROTY]);
     // List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
      List<Product> employees = [];
      if (maps.length >0)
        {
          for (int i = 0; i < maps.length;i++)
            {
              employees.add(Product.fromMap(maps[i]));
            }
        }
      return employees;
    }
  Future<List<Product>> getProductsSearch(String name, String launchedAt) async
  {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME, LAUNCHAT, LAUNCHSITE, POPULAROTY], where: '$NAME =?',whereArgs: [name]);
    // List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Product> employees = [];
    if (maps.length >0)
    {
      for (int i = 0; i < maps.length;i++)
      {
        employees.add(Product.fromMap(maps[i]));
      }
    }
    return employees;
     }
    Future<int> delete (int id)  async
    {
      var dbclient = await db;
      return await dbclient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
    }

    Future <int> update (Product employee) async
    {
      var dbclient = await db;
      return await dbclient.update(TABLE, employee.toMap(), where:'$ID = ?', whereArgs: [employee.id] );
    }
    Future close() async{
    var dbclient = await db;
    dbclient.close();
    }

}