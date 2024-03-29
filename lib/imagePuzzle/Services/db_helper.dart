import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/photo_model.dart';

class LocalDatabase {
  LocalDatabase._init();

  static final LocalDatabase localDatabase = LocalDatabase._init();

  static Database? _database;

  static const String tableName = "PhotosTable";
  static const String id = "id";
  static const String name = "photoName";

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    final mobilePath = await getDatabasesPath();
    final String path = join(mobilePath, 'favouriteMovieTable.db');
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE $tableName($id INTEGER,$name TEXT);");
    });

    return _database!;
  }

  //Insert Photo
  Future<PhotoModel> savePhoto({required PhotoModel photoModel}) async {
    var dbClient = await database;

    photoModel.id = await dbClient.insert(tableName, photoModel.toMap());

    return photoModel;
  }

  //Fetch Photo
  Future<List<PhotoModel>> fetchPhotos() async {
    var dbClient = await database;
    List<Map<String, dynamic>> maps = await dbClient.query(tableName);
    List<PhotoModel> photos = [];
    if (maps.isNotEmpty) {
      for (var i = 0; i < maps.length; i++) {
        photos.add(PhotoModel.fromMap(maps[i]));
      }
    }

    return photos;
  }

  Future<void> closeDatabase() async {
    _database!.close();
  }
}
