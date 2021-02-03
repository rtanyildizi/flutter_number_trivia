import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../datasources/number_trivia_local_datasource.dart';
import '../datasources/number_trivia_remote_datasource.dart';
import '../models/number_trivia_model.dart';

typedef ConcreteOrRandomChooser = Future<NumberTriviaModel> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDatasource remoteDatasource;
  final NumberTriviaLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.remoteDatasource,
    @required this.localDatasource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) {
    return _getNumberTrivia(
      () => remoteDatasource.getConcreteNumberTrivia(number),
    );
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    return _getNumberTrivia(
      () => remoteDatasource.getRandomNumberTrivia(),
    );
  }

  Future<Either<Failure, NumberTrivia>> _getNumberTrivia(
      ConcreteOrRandomChooser getConcreteOrRandom) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteTrivia = await getConcreteOrRandom();
        localDatasource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } else {
        final localTrivia = await localDatasource.getLastNumberTrivia();
        return Right(localTrivia);
      }
    } on ServerException catch (_) {
      return Left(ServerFailure());
    } on CacheException catch (_) {
      return Left(CacheFailure());
    }
  }
}
