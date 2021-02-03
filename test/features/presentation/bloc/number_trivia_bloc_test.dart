import 'package:NumberTriviaApp/core/errors/failures.dart';
import 'package:NumberTriviaApp/core/usecases/usecase.dart';
import 'package:NumberTriviaApp/core/util/input_converter.dart';
import 'package:NumberTriviaApp/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:NumberTriviaApp/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:NumberTriviaApp/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:NumberTriviaApp/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc numberTriviaBloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockInputConverter = MockInputConverter();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();

    numberTriviaBloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be NumberTriviInitial', () {
    expect(numberTriviaBloc.initialState, equals(NumberTriviaInitial()));
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
      'should get data from the random use case',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        numberTriviaBloc.dispatch(GetTriviaForRandomNumber());
        await untilCalled(
            mockGetRandomNumberTrivia(params: anyNamed('params')));
        // assert
        verify(mockGetRandomNumberTrivia(params: NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Right(tNumberTrivia));

        // assert later
        final expected = [
          NumberTriviaInitial(),
          NumberTriviaLoading(),
          NumberTriviaLoaded(tNumberTrivia),
        ];

        expectLater(numberTriviaBloc.state, emitsInOrder(expected));
        // act
        numberTriviaBloc.dispatch(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          NumberTriviaInitial(),
          NumberTriviaLoading(),
          NumberTriviaError(serverFailureMessage),
        ];

        expectLater(numberTriviaBloc.state, emitsInOrder(expected));
        // act
        numberTriviaBloc.dispatch(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          NumberTriviaInitial(),
          NumberTriviaLoading(),
          NumberTriviaError(cacheFailureMessage),
        ];

        expectLater(numberTriviaBloc.state, emitsInOrder(expected));
        // act
        numberTriviaBloc.dispatch(GetTriviaForRandomNumber());
      },
    );
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(tNumberString))
          .thenReturn(Right(tNumberParsed));
    }

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        // act
        numberTriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));

        // assert later
        expectLater(
          numberTriviaBloc.state,
          emitsInOrder(
            [
              NumberTriviaInitial(),
              NumberTriviaError(inputFailureMessage),
            ],
          ),
        );

        // act
        numberTriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        numberTriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(
            mockGetConcreteNumberTrivia(params: anyNamed('params')));
        // assert
        verify(
            mockGetConcreteNumberTrivia(params: Params(number: tNumberParsed)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Right(tNumberTrivia));

        // assert later
        final expected = [
          NumberTriviaInitial(),
          NumberTriviaLoading(),
          NumberTriviaLoaded(tNumberTrivia),
        ];

        expectLater(numberTriviaBloc.state, emitsInOrder(expected));
        // act
        numberTriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          NumberTriviaInitial(),
          NumberTriviaLoading(),
          NumberTriviaError(serverFailureMessage),
        ];

        expectLater(numberTriviaBloc.state, emitsInOrder(expected));
        // act
        numberTriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          NumberTriviaInitial(),
          NumberTriviaLoading(),
          NumberTriviaError(cacheFailureMessage),
        ];

        expectLater(numberTriviaBloc.state, emitsInOrder(expected));
        // act
        numberTriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });
}
