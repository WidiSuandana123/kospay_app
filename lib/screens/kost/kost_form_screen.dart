import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kospay_app/cubit/kost_cubit.dart';
import 'package:kospay_app/models/kost_model.dart';

class KostFormScreen extends StatefulWidget {
  final KostModel? kost;

  const KostFormScreen({super.key, this.kost});

  @override
  // ignore: library_private_types_in_public_api
  _KostFormScreenState createState() => _KostFormScreenState();
}

class _KostFormScreenState extends State<KostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.kost?.name ?? '');
    _addressController =
        TextEditingController(text: widget.kost?.address ?? '');
    _priceController =
        TextEditingController(text: widget.kost?.price.toString() ?? '');
    _descriptionController =
        TextEditingController(text: widget.kost?.description ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kost == null ? 'Add Kost' : 'Edit Kost'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final kost = KostModel(
                      id: widget.kost?.id ??
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _nameController.text,
                      address: _addressController.text,
                      price: double.parse(_priceController.text),
                      description: _descriptionController.text,
                      ownerId:
                          'currentUserId', // You should replace this with the actual user ID
                    );

                    if (widget.kost == null) {
                      context.read<KostCubit>().createKost(kost);
                    } else {
                      context.read<KostCubit>().updateKost(kost);
                    }

                    Navigator.of(context).pop();
                  }
                },
                child: Text(widget.kost == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
