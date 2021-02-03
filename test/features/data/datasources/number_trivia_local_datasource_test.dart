import 'dart:convert';

import 'package:NumberTriviaApp/core/errors/exceptions.dart';
import 'package:NumberTriviaApp/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:NumberTriviaApp/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  NumberTriviaLocalDatasourceIml datasource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    datasource = NumberTriviaLocalDatasourceIml(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
        json.decode(fixture('trivia_cached.json')) as Map<String, dynamic>);
    test(
      'should return NumberTrivia from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('trivia_cached.json'));
        // act
        final result = await datasource.getLastNumberTrivia();
        // assert
        verify(mockSharedPreferences
            .getString(NumberTriviaLocalDatasourceIml.cachedNumberTrivia));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw CacheException when there is not a cached value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = datasource.getLastNumberTrivia;
        // assert
        // verify(mockSharedPreferences
        //     .getString(NumberTriviaLocalDatasourceIml.CACHED_NUMBER_TRIVIA));
        expect(() => call(), throwsA(isInstanceOf<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 1);
    test(
      'should call SharedPreferences to cache the data',
      () async {
        // act
        datasource.cacheNumberTrivia(tNumberTriviaModel);
        // assert
        final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
        verify(
          mockSharedPreferences.setString(
            NumberTriviaLocalDatasourceIml.cachedNumberTrivia,
            expectedJsonString,
          ),
        );
      },
    );
  });
}
