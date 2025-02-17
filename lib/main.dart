// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_api/models/product.dart';
import 'package:flutter_api/screens/create_product.dart';
import 'package:flutter_api/screens/product_list.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/product_list_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env"); // Load file .env
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product CRUD',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ProductList(),
      routes: {
        '/create-product' : (context) => ProductFormScreen(),
        '/edit-product': (context) {
          final product = ModalRoute.of(context)!.settings.arguments as Product;
          return ProductFormScreen(product: product);
        }, 
      },
    );
  }
}