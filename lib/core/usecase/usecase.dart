import 'package:blog_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UseCase<SuccessType, Params> {
  //Future <List<String>> getListOfString();
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}
