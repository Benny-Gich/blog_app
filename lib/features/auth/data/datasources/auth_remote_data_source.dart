import 'dart:developer';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/auth/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<ProfileModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<ProfileModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<ProfileModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  // TODO: implement currentUserSession
  Session? get currentUserSession => supabaseClient.auth.currentSession;

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
    } on AuthException catch (_) {
      rethrow;
    } catch (e, s) {
      log("Error loging in", error: e, stackTrace: s);
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
    } on AuthException catch (_) {
      rethrow;
    } catch (e, s) {
      log("Error signing up", error: e, stackTrace: s);
      throw ServerException(
        e.toString(),
      );
    }
  }

  @override
  Future<ProfileModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final profileData =
            await supabaseClient.from('User Profile Table').select().eq(
                  'id',
                  currentUserSession!.user.id,
                );
        return ProfileModel.fromJson(profileData.first).copyWith(
          email: currentUserSession!.user.email,
        );
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
