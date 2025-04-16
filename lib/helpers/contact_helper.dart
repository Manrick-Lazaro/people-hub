import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String _contactTable = 'contactTable';
final String _idColumn = 'idColumn';
final String _nameColumn = 'nameColumn';
final String _emailColumn = 'emailColumn';
final String _phoneColumn = 'phoneColumn';
final String _imageColumn = 'imageColumn';

class Contact {
  late int id;
  late String name;
  late String email;
  late String phone;
  late String image;

  Contact({
    this.name = '',
    this.id = 0,
    this.email = '',
    this.phone = '',
    this.image = '',
  });

  Contact.fromMap(Map map) {
    id = map[_idColumn];
    name = map[_nameColumn];
    email = map[_emailColumn];
    phone = map[_phoneColumn];
    image = map[_imageColumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      _nameColumn: name,
      _emailColumn: email,
      _phoneColumn: phone,
      _imageColumn: image,
    };
    return map;
  }
}
