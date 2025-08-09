import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techy/controller/auth_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _storage = FlutterSecureStorage();
  AuthBloc() : super(AuthInitial()) {
    on<LogInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final username = event.username;
        final password = event.password;

        if (username.isEmpty || password.isEmpty) {
          return emit(AuthFailure(error: 'Field is Required'));
        }
        if (password.length < 6) {
          return emit(
            AuthFailure(error: 'password must be more than 6 character'),
          );
        }
        final user = await AuthController().logInUser(username, password);
        if (user is String) {
          return emit(AuthFailure(error: user.toString()));
        }
        await _storage.write(key: 'token', value: user.token);
        await _storage.write(key: 'userId', value: user.id);
        return emit(AuthSuccess(msg: "Hello $username"));
      } catch (e) {
        return emit(AuthFailure(error: e.toString()));
      }
    });

    on<RegisterEvent>((event, emit) async {
      String username = event.username;
      String email = event.email;
      String password = event.password;
      emit(AuthLoading());
      try {
        if (username.isEmpty || password.isEmpty || email.isEmpty) {
          return emit(AuthFailure(error: 'Field is Required'));
        }
        if (password.length < 6) {
          return emit(
            AuthFailure(error: 'Password must be more than 6 character'),
          );
        }
        final res = await AuthController().registerUser(
          username,
          email,
          password,
        );
        if (res is String) {
          return emit(AuthFailure(error: res));
        }

        return emit(AuthSuccess(msg: "Register successful"));
      } catch (e) {
        return emit(AuthFailure(error: e.toString()));
      }
    });
  }
}
