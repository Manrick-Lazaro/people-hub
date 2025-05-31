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

  final _nameFocus = FocusNode();

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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, result) async {
        if (didPop) {
          return;
        }

        _requestPop();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(
            _editedContact.name != '' ? _editedContact.name : 'Novo Contato',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
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
                focusNode: _nameFocus,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _requestPop() {
    if (_userEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Desfazer alterações?"),
            content: Text("Se sair todas as alterações serão perdidas."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("Confirmar"),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.pop(context);
    }
  }
}
