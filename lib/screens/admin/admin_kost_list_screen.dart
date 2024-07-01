import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kospay_app/cubit/kost_cubit.dart';
import 'package:kospay_app/models/kost_model.dart';
import 'package:kospay_app/screens/kost/kost_form_screen.dart';

class AdminKostListScreen extends StatelessWidget {
  const AdminKostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<KostCubit>().getKosts();

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Kosts')),
      body: BlocBuilder<KostCubit, KostState>(
        builder: (context, state) {
          if (state is KostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is KostsLoaded) {
            return ListView.builder(
              itemCount: state.kosts.length,
              itemBuilder: (context, index) {
                KostModel kost = state.kosts[index];
                return ListTile(
                  title: Text(kost.name),
                  subtitle: Text(kost.address),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => KostFormScreen(kost: kost),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _showDeleteConfirmation(context, kost),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is KostError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No kosts available'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const KostFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, KostModel kost) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Kost'),
          content: const Text('Are you sure you want to delete this kost?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                context.read<KostCubit>().deleteKost(kost.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
