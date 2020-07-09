import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hell/core/error/exceptions.dart';
import 'package:hell/features/number_trivia/data/datasources/number_trivia_local_data_source_impl.dart';
import 'package:hell/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

main() {
  NumberTriviaLocalDataSourceImpl dataSource;

  MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();

    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
      'deberia retornar NumberTrivia de las sp cuando hay una',
      () async {
        // arrange
        when(mockSharedPreferences.getString(CACHED_TRIVIA_MODEL))
            .thenReturn(fixture("trivia_cached.json"));
        final result = await dataSource.getLastNumberTrivia();
        // act
        verify(mockSharedPreferences.getString(CACHED_TRIVIA_MODEL));
        expect(result, equals(tNumberTriviaModel));
        // assert
      },
    );

    test(
      'deberia retornar CachedException cuando no hay un model',
      () async {
        // arrange
        when(mockSharedPreferences.getString(CACHED_TRIVIA_MODEL))
            .thenReturn(null);
        // act
        final call = dataSource.getLastNumberTrivia;
        // assert
        expect(() => call(), throwsA(isA<CacheException>()));
      },
    );
  });

  group('saveNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'test trivia');
    test(
      'deberia llamar sp para guardar la data',
      () async {
        // act

        dataSource.saveNumberTrivia(tNumberTriviaModel);
        // assert
        final expectedString = json.encode(tNumberTriviaModel.toJson());
        verify(mockSharedPreferences.setString(
            CACHED_TRIVIA_MODEL, expectedString));
      },
    );
  });
}
