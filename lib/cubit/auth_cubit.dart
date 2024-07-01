// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:kospay_app/services/auth_service.dart';
// import 'package:kospay_app/models/user_model.dart';
// part 'auth_state.dart';

// class AuthCubit extends Cubit<AuthState> {
//   final AuthService _authService;

//   AuthCubit(this._authService) : super(AuthInitial());

//   Future<void> signIn(String email, String password) async {
//     emit(AuthLoading());
//     try {
//       UserModel? user = await _authService.signIn(email, password);
//       if (user != null) {
//         emit(AuthSuccess(user));
//       } else {
//         emit(const AuthError("Failed to sign in"));
//       }
//     } catch (e) {
//       emit(AuthError(e.toString()));
//     }
//   }

//   Future<void> signUp(String email, String password, String role) async {
//     emit(AuthLoading());
//     try {
//       UserModel? user = await _authService.signUp(email, password, role);
//       if (user != null) {
//         emit(AuthSuccess(user));
//       } else {
//         emit(const AuthError("Failed to sign up"));
//       }
//     } catch (e) {
//       emit(AuthError(e.toString()));
//     }
//   }

//   Future<void> signOut() async {
//     await _authService.signOut();
//     emit(AuthInitial());
//   }
// }
