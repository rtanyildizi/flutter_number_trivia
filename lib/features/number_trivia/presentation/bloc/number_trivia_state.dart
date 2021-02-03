part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  NumberTriviaState([List props = const <dynamic>[]]) : super(props);
}

class NumberTriviaInitial extends NumberTriviaState {}

class NumberTriviaLoading extends NumberTriviaState {}

class NumberTriviaLoaded extends NumberTriviaState {
  final NumberTrivia trivia;

  NumberTriviaLoaded(this.trivia) : super([trivia]);
}

class NumberTriviaError extends NumberTriviaState {
  final String message;

  NumberTriviaError(this.message) : super([message]);
}
