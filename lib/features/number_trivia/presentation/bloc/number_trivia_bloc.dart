import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String inputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required this.getConcreteNumberTrivia,
    @required this.getRandomNumberTrivia,
    @required this.inputConverter,
  });

  @override
  NumberTriviaState get initialState => NumberTriviaInitial();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);
      yield* inputEither.fold(
        (_) async* {
          yield NumberTriviaError(inputFailureMessage);
        },
        (integer) async* {
          yield* _getTrivia(
            () => getConcreteNumberTrivia(params: Params(number: integer)),
          );
        },
      );
    } else if (event is GetTriviaForRandomNumber) {
      yield* _getTrivia(() => getRandomNumberTrivia(params: NoParams()));
    }
  }

  Stream<NumberTriviaState> _getTrivia(
      Future<Either<Failure, NumberTrivia>> Function()
          getConcreteOrRandomTrivia) async* {
    yield NumberTriviaLoading();
    final failureOrTrivia = await getConcreteOrRandomTrivia();

    yield failureOrTrivia.fold(
      (failure) {
        final failureMessage = failure is ServerFailure
            ? serverFailureMessage
            : cacheFailureMessage;
        return NumberTriviaError(failureMessage);
      },
      (trivia) => NumberTriviaLoaded(trivia),
    );
  }
}
