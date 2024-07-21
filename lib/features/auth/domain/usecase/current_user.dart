import 'package:fpdart/fpdart.dart';
import 'package:tezda/core/shared/entities/user.dart';
import 'package:tezda/core/error/failure.dart';
import 'package:tezda/core/shared/usecase.dart';
import 'package:tezda/features/auth/domain/repository/auth_repository.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.getCurrentUserData();
  }
}
