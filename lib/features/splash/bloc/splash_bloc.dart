import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shop_lite/core/storage/secure_storage.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final SecureStorage storage;

  SplashBloc(this.storage) : super(SplashInitial()) {
    on<CheckAuthStatus>((event, emit) async {
      final token = await storage.getToken();

      if (token != null) {
        Map cred = await storage.getUserCred();
        emit(SplashAuthenticated(cred));
      } else {
        emit(SplashUnauthenticated());
      }
    });
  }
}
