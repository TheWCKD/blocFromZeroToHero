part of 'counter_cubit.dart';

class CounterState {
  int counterValue;
  bool wasIncremented;

  CounterState({
    @required this.counterValue,
    this.wasIncremented,
  });
}
