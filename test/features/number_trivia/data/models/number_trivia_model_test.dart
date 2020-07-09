import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:hell/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'holaa');

  test('deberia ser una subclase de number trivia entity', () async {
    expect(tNumberTriviaModel, isA<NumberTriviaModel>());
  });

  group('fromJson', () {
    test(
      'deberia dar un modelo valudo cuando el json number es un int',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));

        final result = NumberTriviaModel.fromJson(jsonMap);

        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'deberia dar un modelo valudo cuando el json number es un double',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json'));

        final result = NumberTriviaModel.fromJson(jsonMap);

        expect(result, equals(tNumberTriviaModel));
      },
    );
  });

  group('toJson', () {
    test(
      'deberia retornar un Json Map con los datos apropiados',
      () async {
        final result = tNumberTriviaModel.toJson();

        final expectedMap = {"number": 1, "text": 'holaa'};
        expect(result, expectedMap);
      },
    );
  });
}
