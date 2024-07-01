import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kospay_app/cubit/room_cubit.dart';
import 'package:kospay_app/models/room_model.dart';

class RoomFormScreen extends StatefulWidget {
  final String kostId;
  final RoomModel? room;

  const RoomFormScreen({super.key, required this.kostId, this.room});

  @override
  // ignore: library_private_types_in_public_api
  _RoomFormScreenState createState() => _RoomFormScreenState();
}

class _RoomFormScreenState extends State<RoomFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late bool _isAvailable;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.room?.name ?? '');
    _priceController =
        TextEditingController(text: widget.room?.price.toString() ?? '');
    _descriptionController =
        TextEditingController(text: widget.room?.description ?? '');
    _isAvailable = widget.room?.isAvailable ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room != null ? 'Edit Room' : 'Add Room'),
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
              SwitchListTile(
                title: const Text('Available'),
                value: _isAvailable,
                onChanged: (bool value) {
                  setState(() {
                    _isAvailable = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final room = RoomModel(
                      id: widget.room?.id ??
                          FirebaseFirestore.instance
                              .collection('kost')
                              .doc(widget.kostId)
                              .collection('rooms')
                              .doc()
                              .id,
                      kostId: widget.kostId,
                      name: _nameController.text,
                      price: double.parse(_priceController.text),
                      description: _descriptionController.text,
                      isAvailable: _isAvailable,
                    );

                    if (widget.room == null) {
                      context.read<RoomCubit>().createRoom(room);
                    } else {
                      context.read<RoomCubit>().updateRoom(room);
                    }

                    Navigator.of(context).pop();
                  }
                },
                child: Text(widget.room != null ? 'Update' : 'Add'),
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
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
