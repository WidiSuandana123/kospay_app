import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kospay_app/cubit/kost_cubit.dart';
import 'package:kospay_app/models/kost_model.dart';
import 'package:kospay_app/screens/kost/kost_detail_screen.dart';
import 'package:kospay_app/screens/kost/kost_form_screen.dart';

class KostListScreen extends StatelessWidget {
  const KostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kost List')),
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
                  trailing: Text('Rp ${kost.price.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => KostDetailScreen(kostId: kost.id),
                      ),
                    );
                  },
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
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const KostFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
