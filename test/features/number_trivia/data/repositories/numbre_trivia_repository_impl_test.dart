import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hell/core/error/exceptions.dart';
import 'package:hell/core/error/failures.dart';
import 'package:hell/core/network/network_info.dart';
import 'package:hell/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:hell/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:hell/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:hell/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSourceImpl extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSourceImpl extends Mock
    implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockLocalDataSourceImpl mockLocalDataSource;
  MockRemoteDataSourceImpl mockRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockLocalDataSourceImpl();
    mockRemoteDataSource = MockRemoteDataSourceImpl();
    mockNetworkInfo = MockNetworkInfo();

    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getNumberTrivia', () {
    final tNumber = 1;
    final tTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'test trivia');
    test(
      'Deberia chequear si el dispositivo está online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'Deberia retornar remote data',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tTriviaModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Right(tTriviaModel)));
        },
      );

      test(
        'Debería cachear la data localmente si el data source es exitoso',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tTriviaModel);
          // act
          await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.saveNumberTrivia(tTriviaModel));
        },
      );

      test(
        'deberia retorar server failure cuando la call al remote data source no es exitosa',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenThrow(ServerException());
          // act
          final res = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(res, equals(Left(ServerFailure())));
        },
      );
    });
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'deberia retornar la ultima data cacheada localmente cuando hay ultima data cacheada',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tTriviaModel);
          // act
          final res = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(res, equals(Right(tTriviaModel)));
        },
      );

      test(
        'deberia retornar CacheFailure si no hay data presente',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final res = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(res, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getRandomTrivia', () {
    final tTriviaModel = NumberTriviaModel(number: 123, text: 'random trivia');
    test(
      'Deberia chequear si el dispositivo está online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getRandomNumberTrivia();
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'Deberia retornar remote data',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(Right(tTriviaModel)));
        },
      );

      test(
        'Debería cachear la data localmente si el data source es exitoso',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tTriviaModel);
          // act
          await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.saveNumberTrivia(tTriviaModel));
        },
      );

      test(
        'deberia retorar server failure cuando la call al remote data source no es exitosa',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          // act
          final res = await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(res, equals(Left(ServerFailure())));
        },
      );
    });
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'deberia retornar la ultima data cacheada localmente cuando hay ultima data cacheada',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tTriviaModel);
          // act
          final res = await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(res, equals(Right(tTriviaModel)));
        },
      );

      test(
        'deberia retornar CacheFailure si no hay data presente',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final res = await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(res, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
