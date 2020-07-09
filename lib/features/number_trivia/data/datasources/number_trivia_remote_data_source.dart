import 'package:dartz/dartz.dart';
import 'package:hell/core/error/failures.dart';
import 'package:hell/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRemoteDataSource {

  /// Llama al endpoint http://numbersapi.com/{number}
  /// 
  /// Lanza una [ServerException] para todos los errores http
  Future<NumberTrivia> getConcreteNumberTrivia(int number);
  /// Llama al endpoint http://numbersapi.com/random
  /// 
  /// Lanza una [ServerException] para todos los errores http
  Future<NumberTrivia> getRandomNumberTrivia();
}