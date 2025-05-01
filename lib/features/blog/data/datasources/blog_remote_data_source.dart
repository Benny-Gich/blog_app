import 'dart:async';
import 'dart:io';
import 'dart:developer';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });
  Future<List<BlogModel>> getAllBlogs();
  Future<String> deleteBlog(String id);
  Future<String> updateBlog(String id, String title, String content);
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData = await supabaseClient
          .from(
            'blogs',
          )
          .insert(
            blog.toJson(),
          )
          .select();
      return BlogModel.fromJson(blogData.first);
    } catch (e, s) {
      log('Error uploading blog', error: e, stackTrace: s);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      await supabaseClient.storage
          .from(
            'blog_images',
          )
          .upload(
            blog.id,
            image,
          );
      return supabaseClient.storage
          .from(
            'blog_images',
          )
          .getPublicUrl(
            blog.id,
          );
    } catch (e, s) {
      log('Error uploading image', error: e, stackTrace: s);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs =
          await supabaseClient.from('blogs').select('*, profiles (name)');
      return blogs
          .map(
            (blog) => BlogModel.fromJson(blog).copyWith(
              posterName: blog['profiles']['name'],
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> deleteBlog(String id) async {
    try {
      await supabaseClient.from('blogs').delete().eq('id', id);
      return 'Blog deleted successfully';
    } catch (e, s) {
      log('Failed to delete blog', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<String> updateBlog(String id, String title, String content) async {
    try {
      await supabaseClient.from('blogs').update().eq(
            'title',
            '',
            'content',
            '',
          );
      return 'Blog updated succesfully';
    } catch (e, s) {
      log('Failed to update blog', error: e, stackTrace: s);
      rethrow;
    }
  }
}
