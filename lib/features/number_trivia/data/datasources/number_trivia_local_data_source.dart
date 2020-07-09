
import 'package:hell/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:hell/features/number_trivia/domain/entities/number_trivia.dart';


abstract class NumberTriviaLocalDataSource {


  /// Trae la última number trivia
  /// 
  /// Lanza [CacheException] si no hay data cacheada
  Future<NumberTrivia> getLastNumberTrivia();

  Future<void> saveNumberTrivia(NumberTriviaModel trivia);
}