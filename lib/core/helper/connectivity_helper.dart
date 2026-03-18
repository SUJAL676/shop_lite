import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> isConnected() async {
  final results = await Connectivity().checkConnectivity();
  return !results.contains(ConnectivityResult.none);
}
