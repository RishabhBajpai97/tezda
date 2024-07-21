import 'package:fpdart/fpdart.dart';
import 'package:tezda/core/error/failure.dart';
import 'package:tezda/core/shared/usecase.dart';
import 'package:tezda/features/auth/domain/repository/auth_repository.dart';

class UserLogout implements UseCase<String, NoParams> {
  AuthRepository authRepository;
  UserLogout(this.authRepository);
  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await authRepository.logout();
  }
}
