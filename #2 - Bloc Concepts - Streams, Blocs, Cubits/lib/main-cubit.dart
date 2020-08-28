import 'package:bloc/bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

Future<void> main(List<String> args) async {
  final cubit = CounterCubit();

  final streamSubscription = cubit.listen(
      print); //! this subscribes to the cubit state stream and prints the state values emitted by it

  cubit.increment();
  cubit.increment();
  cubit.increment();
  cubit.increment();

  await Future.delayed(Duration
      .zero); //! we use this to not cancel the subscription immediately down here

  await streamSubscription.cancel();
  await cubit.close();
}
