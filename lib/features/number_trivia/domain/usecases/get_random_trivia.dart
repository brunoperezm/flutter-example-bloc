import 'package:hell/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:hell/core/usecases/usecase.dart';
import 'package:hell/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:hell/features/number_trivia/domain/respositories/number_trivia_repository.dart';

class GetRandomTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}

