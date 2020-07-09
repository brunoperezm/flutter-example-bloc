import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hell/core/error/exceptions.dart';
import 'package:hell/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:hell/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:hell/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:http/http.dart' as http;

class NumberTriviaRemoteDataSourceImpl extends NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});

  @override
  Future<NumberTrivia> getConcreteNumberTrivia(int number) async {
    final response =
        await client.get('http://numbersapi.com/$number', headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode != 200) {
      throw ServerException();
    }
    else {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    }

  }

  @override
  Future<NumberTrivia> getRandomNumberTrivia() async {
    final response =
        await client.get('http://numbersapi.com/random', headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode != 200) {
      throw ServerException();
    }
    else {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    }
  }
}
