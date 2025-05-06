import 'package:path/path.dart';
import 'package:peoplehub/helpers/contact_helper.dart';
import 'package:sqflite/sqflite.dart';

final String _contactTable = 'contactTable';
final String _idColumn = 'idColumn';
final String _nameColumn = 'nameColumn';
final String _emailColumn = 'emailColumn';
final String _phoneColumn = 'phoneColumn';
final String _imageColumn = 'imageColumn';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDatabase();
      return _db!;
    }
  }

  Future<Database> initDatabase() async {
    final directoryPath = await getDatabasesPath();
    final databasePath = join(directoryPath, "contacts.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_contactTable (
          $_idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
          $_nameColumn TEXT NOT NULL,
          $_emailColumn TEXT,
          $_phoneColumn TEXT NOT NULL,
          $_imageColumn TEXT
        )
        ''');
      },
    );
    return database;
  }

  Future<Contact> saveContact(Contact contact) async {
    final dbConnection = await database;

    Map<String, dynamic> contactMap = contact.toMap();
    contactMap.remove(_idColumn);

    int newId = await dbConnection.insert(_contactTable, contactMap);

    contact.id = newId;

    return contact;
  }

  Future<Contact?> getContact(int id) async {
    final dbConnection = await database;

    List<Map> maps = await dbConnection.query(
      _contactTable,
      columns: [
        _idColumn,
        _nameColumn,
        _emailColumn,
        _phoneColumn,
        _imageColumn,
      ],
      where: "$_idColumn = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Contact.fromMap(maps[0]);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    final dbConnection = await database;

    return await dbConnection.delete(
      _contactTable,
      where: "$_idColumn = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateContact(Contact contact) async {
    final dbConnection = await database;

    return await dbConnection.update(
      _contactTable,
      contact.toMap(),
      where: "$_idColumn = ?",
      whereArgs: [contact.id],
    );
  }

  Future<List<Contact>> getAllContacts() async {
    final dbConnection = await database;

    List listMap = await dbConnection.rawQuery("SELECT * FROM $_contactTable");

    List<Contact> listContacts = [];

    for (Map m in listMap) {
      Contact c = new Contact(
        image: m[_imageColumn],
        email: m[_emailColumn],
        id: m[_idColumn],
        name: m[_nameColumn],
        phone: m[_phoneColumn],
      );

      listContacts.add(c);
    }

    return listContacts;
  }

  Future<int?> getTotalContacts() async {
    final dbConnection = await database;

    return Sqflite.firstIntValue(
      await dbConnection.rawQuery('SELECT COUNT(*) FROM $_contactTable'),
    );
  }

  Future close() async {
    final dbConnection = await database;
    dbConnection.close();
  }
}
