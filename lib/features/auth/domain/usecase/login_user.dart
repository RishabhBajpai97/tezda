import 'package:fpdart/fpdart.dart';
import 'package:tezda/core/shared/entities/user.dart';
import 'package:tezda/core/error/failure.dart';
import 'package:tezda/core/shared/usecase.dart';
import 'package:tezda/features/auth/domain/repository/auth_repository.dart';

class UserLogin implements UseCase<User, UserLoginParams> {
  final AuthRepository authRepository;
  const UserLogin(this.authRepository);
  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    return await authRepository.loginWithEmailPassword(
        email: params.email, password: params.password);
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({required this.email, required this.password});
}
