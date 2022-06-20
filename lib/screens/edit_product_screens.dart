// ignore_for_file: sized_box_for_whitespace, prefer_final_fields
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/product_provider.dart' show Products;

class EditProductsScreen extends StatefulWidget {
  static const routeName = "/editProducts";
  const EditProductsScreen({Key? key}) : super(key: key);

  @override
  State<EditProductsScreen> createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product editedProduct = Product(
    id: "",
    title: "",
    description: "",
    price: 0.0,
    imageUrl: "",
  );
  var _isInit = true;
  var _initFormValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments;
      if (productId != null) {
        final oneProduct =
            Provider.of<Products>(context).findById(productId.toString());
        editedProduct = oneProduct;
        _initFormValues = {
          'title': editedProduct.title,
          'price': editedProduct.price.toString(),
          'description': editedProduct.description,
        };
        _imageUrlController.text = editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState?.save();
    if (editedProduct.id.isNotEmpty) {
      Provider.of<Products>(
        context,
        listen: false,
      ).updateProduct(
        editedProduct.id,
        editedProduct,
      );
    } else {
      Provider.of<Products>(
        context,
        listen: false,
      ).addProduct(editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editedProduct.title.isEmpty
            ? "Add Product"
            : 'Edit ${editedProduct.title}'),
        actions: <Widget>[
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: "Title"),
                initialValue: _initFormValues['title'],
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a value';
                  }
                  return null;
                },
                onSaved: (value) {
                  editedProduct = Product(
                    id: editedProduct.id,
                    title: value as String,
                    description: editedProduct.description,
                    price: editedProduct.price,
                    imageUrl: editedProduct.imageUrl,
                    isFavourite: editedProduct.isFavourite,
                  );
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Price"),
                textInputAction: TextInputAction.next,
                initialValue: _initFormValues['price'],
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  if (double.parse(value) <= 0) {
                    return "Please enter a number greater than 0";
                  }
                  return null;
                },
                onSaved: (value) {
                  editedProduct = Product(
                    id: editedProduct.id,
                    title: editedProduct.title,
                    description: editedProduct.description,
                    price: double.parse(value as String),
                    imageUrl: editedProduct.imageUrl,
                    isFavourite: editedProduct.isFavourite,
                  );
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.next,
                initialValue: _initFormValues['description'],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.length < 10) {
                    return 'Please enter description of length more than 10';
                  }
                  return null;
                },
                onSaved: (value) {
                  editedProduct = Product(
                    id: editedProduct.id,
                    title: editedProduct.title,
                    description: value as String,
                    price: editedProduct.price,
                    imageUrl: editedProduct.imageUrl,
                    isFavourite: editedProduct.isFavourite,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "ImageUrl",
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an image';
                        }
                        if (!value.startsWith('https') &&
                            !value.startsWith('http')) {
                          return 'please enter a valid url';
                        }
                        if (!value.endsWith(".png") &&
                            !value.endsWith(".jpeg") &&
                            !value.endsWith("jpg")) {
                          return 'Please enter a valid image url';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                          id: editedProduct.id,
                          title: editedProduct.title,
                          description: editedProduct.description,
                          price: editedProduct.price,
                          imageUrl: value as String,
                          isFavourite: editedProduct.isFavourite,
                        );
                      },
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 8, left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? const Text("Enter a URL")
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
