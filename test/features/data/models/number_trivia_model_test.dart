import 'dart:convert';

import 'package:NumberTriviaApp/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:NumberTriviaApp/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');

  test('should be a subclass of NumberTrivia entity', () {
    // assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group(
    'fromJson',
    () {
      test(
        'should return a valid model when the JSON number is an integer',
        () {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('trivia.json')) as Map<String, dynamic>;

          // act
          final result = NumberTriviaModel.fromJson(jsonMap);

          // assert
          expect(result, tNumberTriviaModel);
        },
      );

      test(
        'should return a valid model when the JSON number is regarded as a double',
        () {
          // arrange
          final Map<String, dynamic> jsonMap = json
              .decode(fixture('trivia_double.json')) as Map<String, dynamic>;

          // act
          final result = NumberTriviaModel.fromJson(jsonMap);

          // assert
          expect(result, tNumberTriviaModel);
        },
      );
    },
  );

  group(
    'toJson',
    () {
      test(
        'should return a valid JSON map containing the proper data',
        () {
          // act
          final result = tNumberTriviaModel.toJson();

          final expectedMap = {
            "text": "Test text",
            "number": 1,
          };

          // assert
          expect(result, expectedMap);
        },
      );
    },
  );
}
