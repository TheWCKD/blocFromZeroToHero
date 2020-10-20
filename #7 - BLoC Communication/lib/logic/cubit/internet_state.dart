part of 'internet_cubit.dart';

enum InternetType {
  Mobile,
  Wifi,
  None,
}

@immutable
abstract class InternetState extends Equatable {}

class InternetInitial extends InternetState {
  @override
  List<Object> get props => [];
}

class InternetLoading extends InternetState {
  @override
  List<Object> get props => [];
}

class NoInternet extends InternetState {
  NoInternet();

  @override
  List<Object> get props => [];
}

class InternetAvailable extends InternetState {
  final InternetType internetType;

  InternetAvailable({@required this.internetType});

  @override
  List<Object> get props => [internetType];
}

class UnknownConnection extends InternetState {
  @override
  List<Object> get props => [];
}
