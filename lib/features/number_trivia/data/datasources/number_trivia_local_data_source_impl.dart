import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hell/core/error/exceptions.dart';
import 'package:hell/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:hell/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:hell/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHED_TRIVIA_MODEL = 'cnt';

class NumberTriviaLocalDataSourceImpl extends NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<NumberTrivia> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_TRIVIA_MODEL);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> saveNumberTrivia(NumberTriviaModel trivia) {
    return sharedPreferences.setString(
        CACHED_TRIVIA_MODEL, json.encode(trivia.toJson()));
  }
}
