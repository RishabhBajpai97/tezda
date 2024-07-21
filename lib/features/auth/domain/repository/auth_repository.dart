import 'package:fpdart/fpdart.dart';
import 'package:tezda/core/shared/entities/user.dart';
import 'package:tezda/core/error/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> getCurrentUserData();
  Future<Either<Failure, String>> logout();
}
