import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer >= 0) {
        return Right(integer);
      } else {
        throw const FormatException();
      }
    } on FormatException catch (_) {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
