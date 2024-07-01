part of 'kost_cubit.dart';

abstract class KostState extends Equatable {
  const KostState();

  @override
  List<Object> get props => [];
}

class KostInitial extends KostState {}

class KostLoading extends KostState {}

class KostsLoaded extends KostState {
  final List<KostModel> kosts;

  const KostsLoaded(this.kosts);

  @override
  List<Object> get props => [kosts];
}

class KostLoaded extends KostState {
  final KostModel kost;

  const KostLoaded(this.kost);

  @override
  List<Object> get props => [kost];
}

class KostError extends KostState {
  final String message;

  const KostError(this.message);

  @override
  List<Object> get props => [message];
}
