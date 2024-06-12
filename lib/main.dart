import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Pages/ContactsList.dart';
import 'Services/ContactsService.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ContactsService(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ContactsList(),
    );
  }
}