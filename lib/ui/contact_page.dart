import 'dart:io';

import 'package:flutter/material.dart';
import 'package:peoplehub/helpers/contact_helper.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;

  const ContactPage({super.key, this.contact});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact = Contact();

  bool _userEdited = false;

  final _nameFieldController = TextEditingController();
  final _emailFieldController = TextEditingController();
  final _phoneFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.contact != null) {
      _editedContact = Contact.fromMap(widget.contact!.toMap());

      _nameFieldController.text = _editedContact.name;
      _emailFieldController.text = _editedContact.email;
      _phoneFieldController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          _editedContact.name != '' ? _editedContact.name : 'Novo Contato',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: CircleBorder(),
        backgroundColor: Colors.red,
        child: Icon(Icons.save, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
        GestureDetector(
        child: Container(
        height: 80,
          width: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image:
              _editedContact.image != ""
                  ? FileImage(File(_editedContact.image))
                  : AssetImage('images/person.png'),
            ),
          ),
        ),
      ),
      TextField(
        controller: _nameFieldController,
        decoration: InputDecoration(labelText: "Nome"),
        onChanged: (text) {
          setState(() {
            _userEdited = true;
            _editedContact.name = text;
          });
        },
      ),
      TextField(
        controller: _emailFieldController,
        decoration: InputDecoration(labelText: "Email"),
        onChanged: (text) {
          setState(() {
            _userEdited = true;
            _editedContact.email = text;
          });
        },
        keyboardType: TextInputType.emailAddress,
      ),
      TextField(
          controller: _phoneFieldController,
          decoration: InputDecoration(labelText: "Telefone"),
      onChanged: (text) {
        setState(() {
          _userEdited = true;
          _editedContact.phone = text;
        });
      },
      keyboardType: TextInputType.phone,
    ),]
    ,
    )
    ,
    )
    ,
    );
  }
}
