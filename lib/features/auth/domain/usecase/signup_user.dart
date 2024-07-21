import 'package:fpdart/fpdart.dart';
import 'package:tezda/core/shared/entities/user.dart';
import 'package:tezda/core/error/failure.dart';
import 'package:tezda/core/shared/usecase.dart';
import 'package:tezda/features/auth/domain/repository/auth_repository.dart';

class UserSignup implements UseCase<User, UserSigunpParams> {
  final AuthRepository authRepository;
  const UserSignup(this.authRepository);
  @override
  Future<Either<Failure, User>> call(UserSigunpParams params) async {
    return await authRepository.signUpWithEmailPassword(
        name: params.name, email: params.email, password: params.password);
  }
}

class UserSigunpParams {
  String email;
  String password;
  String name;
  UserSigunpParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
