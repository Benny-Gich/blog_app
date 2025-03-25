import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/common/entities/profile.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, Profile>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, Profile>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, Profile>> currentUSer() {
    throw UnimplementedError();
  }
}
