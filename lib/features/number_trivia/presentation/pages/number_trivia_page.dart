import 'package:NumberTriviaApp/features/number_trivia/presentation/predefined_values/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Text('Number Trivia App'),
      // ),
      body: buildBody(context),
    );
  }

  final beginColor = const Color(0xffe9defa);
  final endColor = const Color(0xfffbfcdb);

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      builder: (_) => g<NumberTriviaBloc>(),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Number Trivia',
              style: TextStyle(
                fontFamily: 'Khula',
                fontSize: 32.0,
                color: triviaPurple,
              ),
            ),
            const SizedBox(height: 10),
            ShowCase(
              child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is NumberTriviaInitial) {
                    return const MessageDisplay(message: 'Hey');
                  } else if (state is NumberTriviaLoading) {
                    return LoadingDisplay();
                  } else if (state is NumberTriviaLoaded) {
                    return TriviaDisplay(trivia: state.trivia);
                  } else if (state is NumberTriviaError) {
                    return MessageDisplay(message: state.message);
                  }
                  return const MessageDisplay(message: 'Start Searching');
                },
              ),
            ),
            const SizedBox(height: 20),
            TriviaControls()
          ],
        ),
      ),
    );
  }
}

class TriviaControls extends StatelessWidget {
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<NumberTriviaBloc, NumberTriviaState>(
      bloc: BlocProvider.of<NumberTriviaBloc>(context),
      listener: (context, state) {
        if (state is NumberTriviaLoaded) {
          _textEditingController.text = state.trivia.number.toString();
        }
      },
      child: Column(
        children: [
          PhysicalModel(
            color: Colors.grey,
            shadowColor: Colors.grey[200],
            elevation: 4.0,
            borderRadius: BorderRadius.circular(30),
            child: InputField(textEditingController: _textEditingController),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              GetTriviaButton(
                gradient: const LinearGradient(
                  colors: [triviaTurquose, triviaYellow],
                ),
                onPressed: () {
                  BlocProvider.of<NumberTriviaBloc>(context).dispatch(
                    GetTriviaForConcreteNumber(_textEditingController.text),
                  );
                },
                text: 'Search',
              ),
              const SizedBox(width: 10),
              GetTriviaButton(
                gradient: const LinearGradient(
                  colors: [triviaLightPurple, triviaTurquose],
                ),
                onPressed: () =>
                    BlocProvider.of<NumberTriviaBloc>(context).dispatch(
                  GetTriviaForRandomNumber(),
                ),
                text: 'Random',
              )
            ],
          ),
        ],
      ),
    );
  }
}
