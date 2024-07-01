import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kospay_app/cubit/kost_cubit.dart';
import 'package:kospay_app/models/kost_model.dart';
import 'package:kospay_app/screens/room/room_list_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<KostCubit>().getKosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Kost', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: const TextStyle(color: Colors.grey),
                  suffixIcon:
                      const Icon(Icons.search, color: Colors.deepPurple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  context.read<KostCubit>().searchKosts(value);
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<KostCubit, KostState>(
                builder: (context, state) {
                  if (state is KostLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is KostsLoaded) {
                    return ListView.builder(
                      itemCount: state.kosts.length,
                      itemBuilder: (context, index) {
                        KostModel kost = state.kosts[index];
                        return Card(
                          child: ListTile(
                            title: Text(kost.name),
                            subtitle: Text(kost.address),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => RoomListScreen(
                                    kostId: kost.id,
                                    roomId: '',
                                  ),
                                ),
                              );
                            },
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new kost button
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
