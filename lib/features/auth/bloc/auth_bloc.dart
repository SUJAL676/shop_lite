import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shop_lite/core/storage/secure_storage.dart';
import 'package:shop_lite/features/auth/data/auth_api_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SecureStorage storage;
  final AuthApiService repository;

  AuthBloc(this.repository, this.storage) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final token = await repository.login(event.email, event.password);

        await storage.saveTokens(
          token: token["accessToken"],
          refreshToken: token["refreshToken"],
        );

        await storage.saveUserCred(
          firstName: token["firstName"],
          lastName: token["lastName"],
          email: token["email"],
          photo: token["image"],
          gender: token["gender"],
          userName: token["username"],
        );

        Map cred = await storage.getUserCred();

        emit(AuthSuccess(cred));
      } catch (e) {
        emit(AuthFailure("Invalid credentials faahhhhhh"));
      }
    });
  }
}
