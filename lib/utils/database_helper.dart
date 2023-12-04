import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:carpool/models/client.dart';

class DatabaseHelper {
  static const _databaseName = "ClientDatabase.db";
  static const _databaseVersion = 1;
  static const table = "client_table";

  // Make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        balance REAL,
        clientImageUrl TEXT
      )
    ''');
  }

  // Insert a Client into the database
  Future<void> insertClient(Client client) async {
    Database db = await database;
    await db.insert(table, client.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Fetch a client from the database
  Future<Client?> getClient(String id) async {
    Database db = await database;
    List<Map> maps = await db.query(table, where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      // Cast the map to the expected type
      Map<String, dynamic> clientMap = Map<String, dynamic>.from(maps.first);
      return Client.fromMap(clientMap);
    }
    return null;
  }
}
