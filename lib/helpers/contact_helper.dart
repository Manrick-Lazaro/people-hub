import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = 'contactTable';
final String idColumn = 'idColumn';
final String nameColumn = 'nameColumn';
final String emailColumn = 'emailColumn';
final String phoneColumn = 'phoneColumn';
final String imageColumn = 'imageColumn';

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  late Database _db;

  Future<Database> get db async => _db = await initDb();

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'contacts.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newerversion) async {
        await db.execute(
          "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, "
          "$emailColumn TEXT, $phoneColumn TEXT, $imageColumn TEXT)",
        );
      },
    );
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbConnection = await db;

    contact.id = await dbConnection.insert(contactTable, contact.toMap());

    return contact;
  }

  Future<Contact?> getContact(int id) async {
    Database dbConnection = await db;

    List<Map> maps = await dbConnection.query(
      contactTable,
      columns: [idColumn, nameColumn, emailColumn, phoneColumn, imageColumn],
      where: "$idColumn = ?",
      whereArgs: [id],
    );

    if(maps.isNotEmpty) {
      return Contact.fromMap(maps[0]);
    } else {
      return null;
    }
  }
}

class Contact {
  late int id;
  late String name;
  late String email;
  late String phone;
  late String image;

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    image = map[imageColumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      idColumn: id,
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imageColumn: image,
    };
    return map;
  }
}
