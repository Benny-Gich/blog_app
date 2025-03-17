import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/auth/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<ProfileModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<ProfileModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<ProfileModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw const ServerException('User is null');
      }
      return ProfileModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(
        e.toString(),
      );
    }
  }

  @override
  Future<ProfileModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          'name': name,
        },
      );
      if (response.user == null) {
        throw const ServerException('User is null');
      }
      return ProfileModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(
        e.toString(),
      );
    }
  }
}
