import 'dart:convert';

import 'package:NumberTriviaApp/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDatasourceIml datasource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = NumberTriviaRemoteDatasourceIml(httpClient: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
        json.decode(fixture('trivia.json')) as Map<String, dynamic>);
    test(
      '''
      should perform a GET request n a URL with number 
      being the endpoint and with application/json header
      ''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        datasource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(
          mockHttpClient.get(
            'http://numbersapi.com/$tNumber',
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test(
      'should return NumberTrivia when the response is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await datasource.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = datasource.getConcreteNumberTrivia;
        // assert

        expect(() => call(tNumber), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
        json.decode(fixture('trivia.json')) as Map<String, dynamic>);
    test(
      '''
      should perform a GET request n a URL with number 
      being the endpoint and with application/json header
      ''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        datasource.getRandomNumberTrivia();
        // assert
        verify(
          mockHttpClient.get(
            'http://numbersapi.com/random',
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test(
      'should return NumberTrivia when the response is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await datasource.getRandomNumberTrivia();
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = datasource.getRandomNumberTrivia;
        // assert

        expect(() => call(), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });
}
