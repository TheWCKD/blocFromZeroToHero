import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'internet_state.dart';

Future<bool> testInternetConnection() async {
  try {
    final hasInternet = await InternetAddress.lookup('example.com')
        .timeout(Duration(seconds: 5), onTimeout: () {
      return throw SocketException('no Internet');
    });
    if (hasInternet.isNotEmpty && hasInternet[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}

Future<bool> forceCheckInternetConnection(
    Connectivity _connectivity, InternetCubit cubit) async {
  final forceConnectionResult = await (_connectivity.checkConnectivity());
  cubit.showLoadingAnimation();

  if (forceConnectionResult == ConnectivityResult.wifi) {
    if (await testInternetConnection()) {
      cubit.showInternetAvailable(InternetType.Wifi);
      print('WIFI - CONNECTED');
      return true;
    } else {
      cubit.showNoInternet(InternetType.Wifi);
      print('WIFI - NO INTERNET');
      return false;
    }
  } else if (forceConnectionResult == ConnectivityResult.mobile) {
    if (await testInternetConnection()) {
      cubit.showInternetAvailable(InternetType.Mobile);
      print('MOBILE - CONNECTED');
      return true;
    } else {
      cubit.showNoInternet(InternetType.Mobile);
      print('MOBILE - NO INTERNET');
      return false;
    }
  } else if (forceConnectionResult == ConnectivityResult.none) {
    cubit.showNoInternet(InternetType.None);
    return false;
  }
  return false;
}

void monitorInternetConnection(
  StreamSubscription _connectivityStreamSubscription,
  Connectivity _connectivity,
  InternetCubit cubit,
  Timer _timer,
) async {
  _connectivityStreamSubscription =
      _connectivity.onConnectivityChanged.listen((connectivityResult) async {
    cubit.showLoadingAnimation();
    switch (connectivityResult) {
      case ConnectivityResult.none:
        print('NO CONNECTION');
        cubit.showNoInternet(InternetType.None);
        break;
      case ConnectivityResult.wifi:
        print('WIFI');
        if (await testInternetConnection()) {
          _timer?.cancel();
          cubit.showInternetAvailable(InternetType.Wifi);
          print('WIFI - CONNECTED');
        } else {
          cubit.showNoInternet(InternetType.Wifi);

          _timer = Timer.periodic(Duration(seconds: 10), (Timer t) async {
            if (await forceCheckInternetConnection(_connectivity, cubit)) {
              t.cancel();
            }
          });

          print('WIFI - NO INTERNET');
        }
        break;
      case ConnectivityResult.mobile:
        print('MOBILE');
        if (await testInternetConnection()) {
          _timer?.cancel();
          cubit.showInternetAvailable(InternetType.Mobile);
          print('MOBILE - CONNECTED');
        } else {
          cubit.showNoInternet(InternetType.Mobile);
          print('Timer started');
          _timer = Timer.periodic(Duration(seconds: 10), (Timer t) async {
            if (await forceCheckInternetConnection(_connectivity, cubit)) {
              t.cancel();
            }
          });

          print('MOBILE - NO INTERNET');
        }
        break;
      default:
        cubit.showUnknownConnection();
        break;
    }
  });
}

class InternetCubit extends Cubit<InternetState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription _connectivityStreamSubscription;
  Timer _timer;

  InternetCubit() : super(InternetInitial()) {
    monitorInternetConnection(
        _connectivityStreamSubscription, _connectivity, this, _timer);
  }

  void showNoInternet(InternetType internetType) =>
      emit(NoInternet(internetType: internetType));
  void showInternetAvailable(InternetType internetType) =>
      emit(InternetAvailable(internetType: internetType));
  void showUnknownConnection() => emit(UnknownConnection());
  void showLoadingAnimation() => emit(InternetLoading());

  @override
  Future<void> close() {
    _connectivityStreamSubscription.cancel();
    _timer?.cancel();
    return super.close();
  }
}
