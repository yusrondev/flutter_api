import 'package:flutter/material.dart';
import 'package:flutter_api/api/auth_service.dart';
import 'package:flutter_api/models/product.dart';
import 'package:flutter_api/screens/create_product.dart';
import 'package:flutter_api/screens/login_page.dart';
import 'package:flutter_api/screens/product_list.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env"); // Load file .env
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> checkToken() async {
    AuthService authService = AuthService();
    String? token = await authService.getToken();
    return token == null ? LoginPage() : ProductList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: checkToken(),
        builder: (context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return snapshot.data!;
        },
      ),
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
