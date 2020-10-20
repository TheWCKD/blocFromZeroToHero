import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'internet_state.dart';

void monitorInternetConnection(
  StreamSubscription _connectivityStreamSubscription,
  Connectivity _connectivity,
  InternetCubit cubit,
) async {
  _connectivityStreamSubscription =
      _connectivity.onConnectivityChanged.listen((connectivityResult) async {
    cubit.showLoadingAnimation();
    switch (connectivityResult) {
      case ConnectivityResult.none:
        print('NO INTERNET');
        cubit.showNoInternet();
        break;
      case ConnectivityResult.wifi:
        print('WIFI');
        cubit.showInternetAvailable(InternetType.Wifi);
        break;
      case ConnectivityResult.mobile:
        print('MOBILE');
        cubit.showInternetAvailable(InternetType.Mobile);
        break;
      default:
        print('UNKNOWN');
        cubit.showUnknownConnection();
        break;
    }
  });
}

class InternetCubit extends Cubit<InternetState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription _connectivityStreamSubscription;

  InternetCubit() : super(InternetInitial()) {
    monitorInternetConnection(
        _connectivityStreamSubscription, _connectivity, this);
  }

  void showNoInternet() => emit(NoInternet());
  void showInternetAvailable(InternetType internetType) =>
      emit(InternetAvailable(internetType: internetType));
  void showUnknownConnection() => emit(UnknownConnection());
  void showLoadingAnimation() => emit(InternetLoading());

  @override
  Future<void> close() {
    _connectivityStreamSubscription.cancel();
    return super.close();
  }
}
