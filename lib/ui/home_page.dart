import 'package:flutter/material.dart';
import 'package:peoplehub/helpers/contact_helper.dart';
import 'package:peoplehub/services/database_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  void initState() {
    super.initState();

    Contact c = Contact();

    c.image = "Teste de imagem";
    c.email = "Teste@gmail.com";
    c.name = "Teste";
    c.phone = "999";

    _databaseService.saveContact(c);

    _databaseService.getTotalContacts().then((list) {
      print("=======================>>>>> $list");
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
