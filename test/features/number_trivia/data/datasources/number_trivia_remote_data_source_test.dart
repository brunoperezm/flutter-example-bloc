import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hell/core/error/exceptions.dart';
import 'package:hell/features/number_trivia/data/datasources/number_trivia_local_data_source_impl.dart';
import 'package:hell/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:hell/features/number_trivia/data/datasources/number_trivia_remote_data_source_impl.dart';
import 'package:hell/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getConcreteNumberTrivia', () {
    int tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
      '''Debería obtener un GET a la url con el numero en el endpoint 
      y con un application/json header''',
      () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('trivia.json'), 200));
        // act
        dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockHttpClient.get(
          any,
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'deberia return NumberTrivia cuado el rc es 200 (éxito)',
      () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('trivia.json'), 200));
        // act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );
    test(
      'deberia lanzar un ServerException cuando el rc no es 200 o 202',
      () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('trivia.json'), 404));
        // act
        final call = dataSource.getConcreteNumberTrivia;
        // assert
        expect(() => call(tNumber), throwsA(isA<ServerException>()));
      },
    );


  });


  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
      '''Debería obtener un GET a la url con el numero en el endpoint 
      y con un application/json header''',
      () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('trivia.json'), 200));
        // act
        dataSource.getRandomNumberTrivia();
        // assert
        verify(mockHttpClient.get(
          any,
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'deberia return NumberTrivia cuado el rc es 200 (éxito)',
      () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('trivia.json'), 200));
        // act
        final result = await dataSource.getRandomNumberTrivia();
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );
    test(
      'deberia lanzar un ServerException cuando el rc no es 200 o 202',
      () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('trivia.json'), 404));
        // act
        final call = dataSource.getRandomNumberTrivia;
        // assert
        expect(() => call(), throwsA(isA<ServerException>()));
      },
    );

    
  });
}
