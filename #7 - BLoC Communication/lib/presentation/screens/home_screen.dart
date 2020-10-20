import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_concepts/logic/cubit/counter_cubit.dart';
import 'package:flutter_bloc_concepts/logic/cubit/internet_cubit.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title, this.color}) : super(key: key);

  final String title;
  final Color color;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocConsumer<InternetCubit, InternetState>(
              listener: internetListener,
              builder: internetBuilder,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Divider(
                thickness: 4,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              '(WIFI = +1, MOBILE = -1)',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              height: 24,
            ),
            BlocConsumer<CounterCubit, CounterState>(
              listener: counterListener,
              builder: counterBuilder,
            ),
            SizedBox(
              height: 24,
            ),
            MaterialButton(
              color: Colors.redAccent,
              child: Text(
                'Go to Second Screen',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/second',
                );
              },
            ),
            SizedBox(
              height: 24,
            ),
            MaterialButton(
              color: Colors.greenAccent,
              child: Text(
                'Go to Third Screen',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/third',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget counterBuilder(context, state) {
    if (state.counterValue < 0) {
      return Text(
        'BRR, NEGATIVE ' + state.counterValue.toString(),
        style: Theme.of(context).textTheme.headline3,
      );
    } else if (state.counterValue % 2 == 0) {
      return Text(
        'YAAAY ' + state.counterValue.toString(),
        style: Theme.of(context).textTheme.headline3,
      );
    } else if (state.counterValue == 5) {
      return Text(
        'HMM, NUMBER 5',
        style: Theme.of(context).textTheme.headline3,
      );
    } else
      return Text(
        state.counterValue.toString(),
        style: Theme.of(context).textTheme.headline3,
      );
  }

  void counterListener(context, state) {
    if (state.wasIncremented == true) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Wi-Fi connected!'),
          duration: Duration(milliseconds: 300),
        ),
      );
    } else if (state.wasIncremented == false) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Mobile connected!'),
          duration: Duration(milliseconds: 300),
        ),
      );
    }
  }

  void internetListener(context, state) {
    if (state is InternetAvailable && state.internetType == InternetType.Wifi) {
      context.bloc<CounterCubit>().increment();

      // BlocProvider.of<CounterCubit>(context).increment();
    } else if (state is InternetAvailable &&
        state.internetType == InternetType.Mobile) {
      BlocProvider.of<CounterCubit>(context).decrement();
    }
  }

  Widget internetBuilder(context, state) {
    if (state is InternetLoading) {
      return CircularProgressIndicator();
    } else if (state is InternetAvailable &&
        state.internetType == InternetType.Wifi) {
      return Text(
        'WIFI MODE',
        style: Theme.of(context)
            .textTheme
            .headline3
            .copyWith(color: Colors.blueAccent),
      );
    } else if (state is InternetAvailable &&
        state.internetType == InternetType.Mobile) {
      return Text(
        'MOBILE MODE',
        style: Theme.of(context)
            .textTheme
            .headline3
            .copyWith(color: Colors.blueAccent),
      );
    } else if (state is NoInternet) {
      return Text(
        'NO WIFI/MOBILE',
        style: Theme.of(context)
            .textTheme
            .headline3
            .copyWith(color: Colors.blueAccent),
      );
    }
    return Text(
      'CHECKING CONNECTION...',
      style: Theme.of(context).textTheme.headline5,
    );
  }
}
