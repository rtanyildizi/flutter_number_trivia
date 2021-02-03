import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_iml.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';

final g = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  //* Bloc
  g.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: g(),
      getRandomNumberTrivia: g(),
      inputConverter: g(),
    ),
  );

  //* Use cases
  g.registerLazySingleton(() => GetConcreteNumberTrivia(repository: g()));
  g.registerLazySingleton(() => GetRandomNumberTrivia(repository: g()));

  //* Repository
  g.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      localDatasource: g(),
      remoteDatasource: g(),
      networkInfo: g(),
    ),
  );

  //* Datasources
  g.registerLazySingleton<NumberTriviaLocalDatasource>(
      () => NumberTriviaLocalDatasourceIml(sharedPreferences: g()));
  g.registerLazySingleton<NumberTriviaRemoteDatasource>(
      () => NumberTriviaRemoteDatasourceIml(httpClient: g()));

  //! Core
  g.registerLazySingleton(() => InputConverter());
  g.registerLazySingleton<NetworkInfo>(() => NetworkInfoIml(g()));

  //! External
  final sharedPrefrences = await SharedPreferences.getInstance();
  g.registerLazySingleton<SharedPreferences>(() => sharedPrefrences);
  g.registerLazySingleton<http.Client>(() => http.Client());
  g.registerLazySingleton<DataConnectionChecker>(() => DataConnectionChecker());
}
