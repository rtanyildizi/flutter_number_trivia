import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDatasource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDatasourceIml implements NumberTriviaLocalDatasource {
  static const cachedNumberTrivia = 'CACHED_NUMBER_TRIVIA';
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDatasourceIml({@required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString('CACHED_NUMBER_TRIVIA');

    if (jsonString != null) {
      final jsonTrivia = json.decode(jsonString) as Map<String, dynamic>;
      return Future.value(NumberTriviaModel.fromJson(jsonTrivia));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    final jsonString = json.encode(triviaToCache.toJson());
    return sharedPreferences.setString(cachedNumberTrivia, jsonString);
  }
}
