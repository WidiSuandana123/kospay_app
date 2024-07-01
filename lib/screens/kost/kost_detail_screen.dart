import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kospay_app/cubit/kost_cubit.dart';
import 'package:kospay_app/models/kost_model.dart';
import 'package:kospay_app/screens/kost/kost_form_screen.dart';

class KostDetailScreen extends StatelessWidget {
  final String kostId;

  const KostDetailScreen({super.key, required this.kostId});

  @override
  Widget build(BuildContext context) {
    context.read<KostCubit>().getKostById(kostId);

    return Scaffold(
      appBar: AppBar(title: const Text('Kost Detail')),
      body: BlocBuilder<KostCubit, KostState>(
        builder: (context, state) {
          if (state is KostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is KostLoaded) {
            KostModel kost = state.kost;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${kost.name}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Address: ${kost.address}'),
                  const SizedBox(height: 8),
                  Text('Price: Rp ${kost.price.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  Text('Description: ${kost.description}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => KostFormScreen(kost: kost),
                        ),
                      );
                    },
                    child: const Text('Edit'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.read<KostCubit>().deleteKost(kost.id);
                      Navigator.of(context).pop();
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          } else if (state is KostError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Kost not found'));
        },
      ),
    );
  }
}
