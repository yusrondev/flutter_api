import 'package:flutter/material.dart';
import 'package:flutter_api/api/api_service.dart';
import 'package:flutter_api/models/product.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  ApiService apiService = ApiService();
  List<Product> products = [];

  Future<void> fetchProduct() async {
    final data = await ApiService().fetchProducts();
    setState(() {
      products = data;
    });
  }

  @override
  void initState(){
    super.initState();
    fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: products == [] ? CircularProgressIndicator() : 
      ListView(
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
              height: 50,
              decoration: BoxDecoration(
                color: Colors.amber
              ),
              child: Center(
                child: Text("Tambah Data"),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index){
              final product = products[index];
              return Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Color(0xffe1e1e1),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(product.shortDescription),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            await ApiService().deleteProduct(product.id); // Tunggu proses hapus selesai
                            setState(() {}); // Memicu perubahan UI
                            fetchProduct(); // Ambil ulang data setelah setState()
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.lightGreenAccent
                            ),
                            child: Center(
                              child: Text("Hapus"),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/edit-product', arguments: product).then((value){
                              if (value == true) {
                                setState(() {
                                  fetchProduct();
                                });
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.amber
                            ),
                            child: Center(
                              child: Text("Edit"),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
          }),
        ],
      ),
    );
  }
}