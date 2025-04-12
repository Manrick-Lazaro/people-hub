import 'package:sqflite/sqflite.dart';

final String idColumn = 'idColumn';
final String nameColumn = 'nameColumn';
final String emailColumn = 'emailColumn';
final String phoneColumn = 'phoneColumn';
final String imageColumn = 'imageColumn';

class ContactHelper {

}

class Contact {
  late int id;
  late String name;
  late String? email;
  late String phone;
  late String? image;

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    image = map[imageColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      idColumn: id,
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      idColumn: image,
    };
    return map;
  }
}
