import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_api/api/api_service.dart';
import 'package:flutter_api/models/product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

class ProductFormScreen extends StatefulWidget {
  final Product? product;
  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController shortDescriptionController = TextEditingController();
  File? _image;
  String? urlImage;
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      nameController.text = widget.product!.name;
      priceController.text = widget.product!.price.toString();
      shortDescriptionController.text = widget.product!.shortDescription;
      urlImage = widget.product!.image;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Sesuaikan Ukuran',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
          ),
          IOSUiSettings(
            title: 'Sesuaikan Ukuran',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          urlImage = null;
          _image = File(croppedFile.path);
        });
      }
    }
  }

  Future<void> saveProduct() async {
    if (_formKey.currentState!.validate()) {
      bool success;

      if (widget.product == null) {
        // Jika produk baru, buat produk
        success = await apiService.createProduct(
          nameController.text,
          priceController.text,
          _image,
          shortDescriptionController.text
        );
      } else {
        // Jika produk sudah ada, update produk
        success = await apiService.updateProduct(
          widget.product!.id, // ID produk yang akan diupdate
          nameController.text,
          priceController.text,
          _image,
          shortDescriptionController.text
        );
      }

      if (success == true) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create product')));
      }
    }
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product == null ? 'Add Product' : 'Edit Product')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        icon: Icon(Icons.camera),
                        label: Text('Camera'),
                        onPressed: () => pickImage(ImageSource.camera),
                      ),
                      SizedBox(width: 10),
                      TextButton.icon(
                        icon: Icon(Icons.image),
                        label: Text('Gallery'),
                        onPressed: () => pickImage(ImageSource.gallery),
                      ),
                    ],
                  ),
                  TextFormField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
                  TextFormField(controller: priceController, decoration: InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
                  TextFormField(controller: shortDescriptionController, decoration: InputDecoration(labelText: 'Short Description')),
                  SizedBox(height: 10),
                  _image == null ? Text('No image selected') : Image.file(_image!, width: 100, height: 100),
                  if(urlImage != null) ... [
                  Image.network(urlImage ?? ""),
                  ],
                  SizedBox(height: 20),
                  ElevatedButton(onPressed: saveProduct, child: Text('Save')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}