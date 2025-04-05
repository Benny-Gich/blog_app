// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names
import 'dart:io';

import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecase/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecase/upload_blog.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/kt.dart';
part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogState()) {
    // on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onFetchAllBlogs);
  }

  void _onBlogUpload(
    BlogUpload event,
    Emitter<BlogState> emit,
  ) async {
    emit(state.copyWith(status: BlogStatus.uploading));
    final res = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );
    res.fold(
      (failure) => emit(state.copyWith(
        status: BlogStatus.failure,
        error: failure.message,
      )),
      (blog) => emit(state.copyWith(
        status: BlogStatus.uploadSuccess,
        blogs: [blog, ...state.blogs]
            .toImmutableList()
            .distinctBy((e) => e.id)
            .asList(),
      )),
    );
  }

  //delete
  //blogs: state.blog.map((e)=>e.id!=event.blog.id).toList()

  void _onFetchAllBlogs(
    BlogFetchAllBlogs event,
    Emitter<BlogState> emit,
  ) async {
    emit(state.copyWith(status: BlogStatus.loading));
    final res = await _getAllBlogs(
      NoParams(),
    );
    res.fold(
      (failure) => emit(state.copyWith(
        status: BlogStatus.failure,
        error: failure.message,
      )),
      (blogs) => emit(state.copyWith(
        status: BlogStatus.success,
        blogs: [...state.blogs, ...blogs]
            .toImmutableList()
            .distinctBy((e) => e.id)
            .asList(),
      )),
    );
  }
}
