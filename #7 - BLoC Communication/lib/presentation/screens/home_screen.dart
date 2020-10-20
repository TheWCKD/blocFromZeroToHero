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
            BlocBuilder<InternetCubit, InternetState>(
              builder: (context, state) {
                if (state is InternetLoading) {
                  return CircularProgressIndicator();
                } else if (state is InternetAvailable &&
                    state.internetType == InternetType.Wifi) {
                  return Text(
                    'WIFI - CONNECTED',
                    style: Theme.of(context).textTheme.headline5,
                  );
                } else if (state is InternetAvailable &&
                    state.internetType == InternetType.Mobile) {
                  return Text(
                    'MOBILE - CONNECTED',
                    style: Theme.of(context).textTheme.headline5,
                  );
                } else if (state is NoInternet &&
                    state.internetType == InternetType.Mobile) {
                  return Text(
                    'MOBILE - NO CONNECTION',
                    style: Theme.of(context).textTheme.headline5,
                  );
                } else if (state is NoInternet &&
                    state.internetType == InternetType.Wifi) {
                  return Text(
                    'WIFI - NO CONNECTION',
                    style: Theme.of(context).textTheme.headline5,
                  );
                } else if (state is NoInternet &&
                    state.internetType == InternetType.None) {
                  return Text(
                    'NO CONNECTION',
                    style: Theme.of(context).textTheme.headline5,
                  );
                }
                return Text(
                  'CHECKING CONNECTION...',
                  style: Theme.of(context).textTheme.headline5,
                );
              },
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              'Internet Connection Counter',
            ),
            SizedBox(
              height: 24,
            ),
            BlocConsumer<CounterCubit, CounterState>(
              listener: (context, state) {
                if (state.wasIncremented == true) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Connection established!'),
                      duration: Duration(milliseconds: 300),
                    ),
                  );
                } else if (state.wasIncremented == false) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Connection lost!'),
                      duration: Duration(milliseconds: 300),
                    ),
                  );
                }
              },
              builder: (context, state) {
                // if (state.counterValue < 0) {
                //   return Text(
                //     'BRR, NEGATIVE ' + state.counterValue.toString(),
                //     style: Theme.of(context).textTheme.headline4,
                //   );
                // } else if (state.counterValue % 2 == 0) {
                //   return Text(
                //     'YAAAY ' + state.counterValue.toString(),
                //     style: Theme.of(context).textTheme.headline4,
                //   );
                // } else if (state.counterValue == 5) {
                //   return Text(
                //     'HMM, NUMBER 5',
                //     style: Theme.of(context).textTheme.headline4,
                //   );
                // } else
                return Text(
                  state.counterValue.toString(),
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
            SizedBox(
              height: 24,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     FloatingActionButton(
            //       heroTag: Text('${widget.title}'),
            //       onPressed: () {
            //         BlocProvider.of<CounterCubit>(context).decrement();
            //         // context.bloc<CounterCubit>().decrement();
            //       },
            //       tooltip: 'Decrement',
            //       child: Icon(Icons.remove),
            //     ),
            //     FloatingActionButton(
            //       heroTag: Text('${widget.title} 2nd'),
            //       onPressed: () {
            //         // BlocProvider.of<CounterCubit>(context).increment();
            //         context.bloc<CounterCubit>().increment();
            //       },
            //       tooltip: 'Increment',
            //       child: Icon(Icons.add),
            //     ),
            //   ],
            // ),
            // SizedBox(
            //   height: 24,
            // ),
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
}
