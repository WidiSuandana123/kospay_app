part of 'room_cubit.dart';

abstract class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object> get props => [];
}

class RoomInitial extends RoomState {}

class RoomLoading extends RoomState {}

class RoomsLoaded extends RoomState {
  final List<RoomModel> rooms;
  const RoomsLoaded(this.rooms);

  @override
  List<Object> get props => [rooms];
}

class RoomLoaded extends RoomState {
  final RoomModel room;
  const RoomLoaded(this.room);

  @override
  List<Object> get props => [room];
}

class RoomError extends RoomState {
  final String message;
  const RoomError(this.message);

  @override
  List<Object> get props => [message];
}
