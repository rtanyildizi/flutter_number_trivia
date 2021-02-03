import 'package:NumberTriviaApp/core/errors/exceptions.dart';
import 'package:NumberTriviaApp/core/errors/failures.dart';
import 'package:NumberTriviaApp/core/network/network_info.dart';
import 'package:NumberTriviaApp/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:NumberTriviaApp/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:NumberTriviaApp/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:NumberTriviaApp/features/number_trivia/data/repositories/number_trivia_repository_iml.dart';
import 'package:NumberTriviaApp/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDatasource extends Mock
    implements NumberTriviaRemoteDatasource {}

class MockLocalDatasource extends Mock implements NumberTriviaLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDatasource mockRemoteDatasource;
  MockLocalDatasource mockLocalDatasource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDatasource = MockLocalDatasource();
    mockRemoteDatasource = MockRemoteDatasource();
    mockNetworkInfo = MockNetworkInfo();
    final mockNetworkInfo2 = mockNetworkInfo;
    final mockNetworkInfo22 = mockNetworkInfo2;
    repository = NumberTriviaRepositoryImpl(
      remoteDatasource: mockRemoteDatasource,
      localDatasource: mockLocalDatasource,
      networkInfo: mockNetworkInfo22,
    );
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        body();
      });
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        body();
      });
    });
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(
      text: 'Test trivia',
      number: tNumber,
    );

    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if the device is connected',
      () {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestOnline(() {
      test(
        'should return remote data when the call to remote data source is successfull',
        () async {
          // arrange
          when(mockRemoteDatasource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache data locally when the call to remote data source is successfull',
        () async {
          when(mockRemoteDatasource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessfull',
        () async {
          // arrange
          when(mockRemoteDatasource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockLocalDatasource);
          verify(mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDatasource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDatasource);
          verify(mockLocalDatasource.getLastNumberTrivia());
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        'should return cache failure when there is no cached data',
        () async {
          // arrange
          when(mockLocalDatasource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDatasource);
          verify(mockLocalDatasource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(
      text: 'Test trivia',
      number: 123,
    );

    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if the device is connected',
      () {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getRandomNumberTrivia();
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestOnline(() {
      test(
        'should return remote data when the call to remote data source is successfull',
        () async {
          // arrange
          when(mockRemoteDatasource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDatasource.getRandomNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache data locally when the call to remote data source is successfull',
        () async {
          when(mockRemoteDatasource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDatasource.getRandomNumberTrivia());
          verify(mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessfull',
        () async {
          // arrange
          when(mockRemoteDatasource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockLocalDatasource);
          verify(mockRemoteDatasource.getRandomNumberTrivia());
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDatasource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDatasource);
          verify(mockLocalDatasource.getLastNumberTrivia());
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        'should return cache failure when there is no cached data',
        () async {
          // arrange
          when(mockLocalDatasource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDatasource);
          verify(mockLocalDatasource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });
}
