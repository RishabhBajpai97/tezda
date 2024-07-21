import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tezda/core/shared/cubits/app_user_cubit/app_user_cubit.dart';
import 'package:tezda/core/shared/entities/user.dart';
import 'package:tezda/core/shared/usecase.dart';
import 'package:tezda/features/auth/domain/usecase/current_user.dart';
import 'package:tezda/features/auth/domain/usecase/login_user.dart';
import 'package:tezda/features/auth/domain/usecase/signup_user.dart';
import 'package:tezda/features/auth/domain/usecase/user_logout.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthBlocState> {
  final UserSignup _userSignup;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final UserLogout _userLogout;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserSignup userSignup,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required UserLogout userLogout,
    required AppUserCubit appUserCubit,
  })  : _userSignup = userSignup,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _userLogout = userLogout,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>(
      (_, emit) => emit(AuthLoading()),
    );
    on<AuthSignup>(_onAuthSignup);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsLoggedIn>(_onAuthIsLoggedIn);
    on<AuthLogout>(_onAuthLogout);
  }
  _onAuthIsLoggedIn(AuthIsLoggedIn event, Emitter<AuthBlocState> emit) async {
    final res = await _currentUser(NoParams());
    res.fold(
      ((l) {
        emit(
          AuthFailure(
            message: l.message,
          ),
        );
      }),
      (user) {
        _appUserCubit.updateUser(user);
        emit(AuthSuccess(user: user));
      },
    );
  }

  _onAuthLogout(AuthLogout event, Emitter<AuthBlocState> emit) async {
    final res = await _userLogout(NoParams());
    res.fold((l) => emit(AuthFailure(message: l.message)), (msg) {
      _appUserCubit.updateUser(null);
      emit(AuthInitial());
    });
  }

  _onAuthLogin(AuthLogin event, Emitter<AuthBlocState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
        UserLoginParams(email: event.email, password: event.password));
    res.fold((l) => emit(AuthFailure(message: l.message)), (user) {
      _appUserCubit.updateUser(user);
      emit(AuthSuccess(user: user));
    });
  }

  _onAuthSignup(AuthSignup event, Emitter<AuthBlocState> emit) async {
    emit(AuthLoading());
    final res = await _userSignup(UserSigunpParams(
        email: event.email, password: event.password, name: event.name));
    res.fold((l) => emit(AuthFailure(message: l.message)), (user) {
      _appUserCubit.updateUser(user);
      emit(AuthSuccess(user: user));
    });
  }
}
