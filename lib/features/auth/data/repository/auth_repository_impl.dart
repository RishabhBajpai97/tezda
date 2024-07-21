import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:tezda/core/shared/entities/user.dart';
import 'package:tezda/core/error/exception.dart';
import 'package:tezda/core/error/failure.dart';
import 'package:tezda/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:tezda/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(() async => await remoteDataSource.signUpWithEmailPassword(
        name: name, email: email, password: password));
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword(
      {required String email, required String password}) async {
    return _getUser(() async => await remoteDataSource.loginWithEmailPassword(
        email: email, password: password));
  }

  @override
  Future<Either<Failure, User>> getCurrentUserData() async {
    try {
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure("User is not logged In!"));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> logout() async {
    try {
      final String message = await remoteDataSource.logout();
      return right(message);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}

Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
  try {
    final user = await fn();
    return right(user);
  } on sb.AuthException catch (e) {
    return left(Failure(e.message));
  } on ServerException catch (e) {
    return left(Failure(e.message));
  }
}
