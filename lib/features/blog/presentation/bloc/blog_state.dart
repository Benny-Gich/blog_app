// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'blog_bloc.dart';

class BlogState extends Equatable {
  const BlogState({
    this.status = BlogStatus.initial,
    this.blogs = const [],
    this.error = '',
  });
  final BlogStatus status;
  final List<Blog> blogs;
  final String error;

  @override
  List<Object?> get props => [status, blogs, error];

  BlogState copyWith({
    BlogStatus? status,
    List<Blog>? blogs,
    String? error,
  }) {
    return BlogState(
      status: status ?? this.status,
      blogs: blogs ?? this.blogs,
      error: error ?? '',
    );
  }
}

enum BlogStatus {
  initial,
  loading,
  uploading,
  deleting,
  success,
  uploadSuccess,
  failure,
}

// final class BlogInitial extends BlogState {}

// final class BlogLoading extends BlogState {}

// final class BlogFailure extends BlogState {
//   final String error;
//   const BlogFailure(this.error);
//   @override
//   List<Object?> get props => [error];
// }

// final class BlogUploadSuccess extends BlogState {}

// final class BlogDisplaySuccess extends BlogState {
//   final List<Blog> blogs;
//   const BlogDisplaySuccess(this.blogs);
// }
