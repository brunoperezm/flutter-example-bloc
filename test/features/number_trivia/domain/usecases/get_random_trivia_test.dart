import 'package:dartz/dartz.dart';
import 'package:hell/core/usecases/usecase.dart';
import 'package:hell/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:hell/features/number_trivia/domain/respositories/number_trivia_repository.dart';
import 'package:hell/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:hell/features/number_trivia/domain/usecases/get_random_trivia.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomTrivia(mockNumberTriviaRepository);
  });
  final tNumberTrivia = NumberTrivia(text: "text", number: 1);

  test('deberia traer una trivia ', () async {
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tNumberTrivia));

    final result = await usecase(NoParams());

    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
