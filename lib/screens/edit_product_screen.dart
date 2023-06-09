import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product-screen';
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController imageURLController = TextEditingController();
  final FocusNode imageURLFocusNode = FocusNode();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool init = true;

  Product product = Product(
    id: '',
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  @override
  void initState() {
    imageURLFocusNode.addListener(previewImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (init == true) {
      String id = ModalRoute.of(context)!.settings.arguments as String;
      init = false;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    imageURLController.dispose();
    imageURLFocusNode.removeListener(previewImage);
    imageURLFocusNode.dispose();
    super.dispose();
  }

  void previewImage() {
    if (!imageURLFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    if (_form.currentState!.validate() == false) {
      return;
    }
    _form.currentState!.save();
    Provider.of<ProductsProvider>(context, listen: false).addProduct(product);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item is added.'),
        duration: Duration(seconds: 2),
      ),
    );
    _form.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty == true) {
                    return 'Please enter the title';
                  } else if (value.length <= 5) {
                    return 'The length of title must be 5 characters or more. But you entered ${value.length} characters.';
                  } else if (value.length > 15) {
                    return 'The length of title must be 15 characters or fewer. But uou entered ${value.length} characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  product = Product(
                    id: '',
                    title: value as String,
                    price: product.price,
                    description: product.description,
                    imageUrl: product.imageUrl,
                  );
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: '0.0',
                decoration: const InputDecoration(
                  labelText: 'Price',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty == true) {
                    return 'Please enter the price';
                  } else if (double.tryParse(value) == null) {
                    return 'Please enter valid number';
                  } else if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero';
                  }

                  return null;
                },
                onSaved: (value) {
                  product = Product(
                    id: '',
                    title: product.title,
                    price: double.parse(value as String),
                    description: product.description,
                    imageUrl: product.imageUrl,
                  );
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty == true) {
                    return 'Please enter the description';
                  } else if (value.length <= 10) {
                    return 'The length of description must be 10 characters or more. But you entered ${value.length} characters.';
                  } else if (value.length > 30) {
                    return 'The length of description must be 30 characters or fewer. But uou entered ${value.length} characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  product = Product(
                    id: '',
                    title: product.title,
                    price: product.price,
                    description: value as String,
                    imageUrl: product.imageUrl,
                  );
                },
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(right: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: imageURLController.text.isEmpty == true
                        ? const Text(
                            'Enter Image URL',
                            textAlign: TextAlign.center,
                          )
                        : FittedBox(
                            child: Image.network(
                              imageURLController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Enter an image URL',
                      ),
                      controller: imageURLController,
                      focusNode: imageURLFocusNode,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty == true) {
                          return 'Please enter an image URL';
                        } else if (value.startsWith('http') == false &&
                            value.startsWith('https') == false) {
                          return 'Please enter valid image URL';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        product = Product(
                          id: '',
                          title: product.title,
                          price: product.price,
                          description: product.description,
                          imageUrl: value as String,
                        );
                      },
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
