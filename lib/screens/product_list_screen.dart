import 'package:flutter/material.dart';
import 'package:flutter_api/api/api_service.dart';
import 'package:flutter_api/models/product.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  ApiService apiService = ApiService();
  List<Product> products = [];

  @override
  void initState(){
    super.initState();
    fetchProduct();    
  }

  Future<void> fetchProduct() async {
    final data = await ApiService().fetchProducts();
    setState(() {
      products = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/create-product').then((value){
                if (value == true) {
                  setState(() {
                  fetchProduct();    
                  });
                }
              });

            },
            child: Container(
              width: 200,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.red
              ),
              child: Text("Tambah data"),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index){
              final product = products[index];
          
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/edit-product', arguments: product).then((value) {
                    if (value == true) { 
                      setState(() {
                        fetchProduct();    
                      }); // Refresh halaman jika produk berhasil diedit
                    }
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(product.image),
                    Text(product.name, style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600
                    ),),
                    Text(product.shortDescription, style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey
                    ),),
                    SizedBox(height: 10,)
                  ],
                ),
              );
          
          }),
        ],
      ),
    );
  }
}