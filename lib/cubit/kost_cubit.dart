import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kospay_app/services/kost_service.dart';
import 'package:kospay_app/models/kost_model.dart';

part 'kost_state.dart';

class KostCubit extends Cubit<KostState> {
  final KostService _kostService;

  KostCubit(this._kostService) : super(KostInitial());

  Future<void> getKosts() async {
    emit(KostLoading());
    try {
      List<KostModel> kosts = await _kostService.getKosts();
      emit(KostsLoaded(kosts));
    } catch (e) {
      emit(KostError(e.toString()));
    }
  }

  Future<void> getKostById(String id) async {
    emit(KostLoading());
    try {
      KostModel? kost = await _kostService.getKostById(id);
      if (kost != null) {
        emit(KostLoaded(kost));
      } else {
        emit(const KostError("Kost not found"));
      }
    } catch (e) {
      emit(KostError(e.toString()));
    }
  }

  Future<void> createKost(KostModel kost) async {
    emit(KostLoading());
    try {
      bool success = await _kostService.createKost(kost);
      if (success) {
        emit(KostLoaded(kost));
      } else {
        emit(const KostError("Failed to create kost"));
      }
    } catch (e) {
      emit(KostError(e.toString()));
    }
  }

  Future<void> updateKost(KostModel kost) async {
    emit(KostLoading());
    try {
      bool success = await _kostService.updateKost(kost);
      if (success) {
        emit(KostLoaded(kost));
      } else {
        emit(const KostError("Failed to update kost"));
      }
    } catch (e) {
      emit(KostError(e.toString()));
    }
  }

  Future<void> deleteKost(String id) async {
    emit(KostLoading());
    try {
      bool success = await _kostService.deleteKost(id);
      if (success) {
        await getKosts();
      } else {
        emit(const KostError("Failed to delete kost"));
      }
    } catch (e) {
      emit(KostError(e.toString()));
    }
  }

  Future<void> searchKosts(String query) async {
    emit(KostLoading());
    try {
      List<KostModel> kosts = await _kostService.getKosts();
      List<KostModel> filteredKosts = kosts
          .where((kost) =>
              kost.name.toLowerCase().contains(query.toLowerCase()) ||
              kost.address.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(KostsLoaded(filteredKosts));
    } catch (e) {
      emit(KostError(e.toString()));
    }
  }
}
