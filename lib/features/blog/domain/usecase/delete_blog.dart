import 'package:blog_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/blog_repository.dart';

class DeleteBlogs implements UseCase<String, String>{
final BlogRepository blogRepository;
DeleteBlogs(this.blogRepository);

  @override
  Future<Either<Failure, String>> call(String params) async{
    return blogRepository.deleteBlog(id: params);
  }
}

