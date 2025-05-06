import 'dart:io';

import 'package:flutter/material.dart';
import 'package:peoplehub/helpers/contact_helper.dart';
import 'package:peoplehub/services/database_services.dart';
import 'package:peoplehub/ui/contact_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService.instance;

  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();

    _getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        backgroundColor: Colors.red,
        shape: CircleBorder(),
        elevation: 6,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image:
                        contacts[index].image != ""
                            ? FileImage(File(contacts[index].image))
                            : AssetImage('images/person.png'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contacts[index].name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(contacts[index].email, style: TextStyle(fontSize: 18)),
                    Text(contacts[index].phone, style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _showContactPage(contact: contacts[index]);
      },
    );
  }

  void _showContactPage({Contact? contact}) async {
    final Contact res = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact)),
    );
    if (res != null) {
      if (contact != null) {
        print('zzzzzzz===============>>>>> ${res.toMap()}');
        await _databaseService.updateContact(res);
      } else {
        await _databaseService.saveContact(res);
      }
      _getContacts();
    }
  }

  void _getContacts() {
    _databaseService.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }
}
