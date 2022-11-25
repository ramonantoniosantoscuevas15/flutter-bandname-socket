// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

enum ServiceStatus { Conneting, Offline, Online }

class SocketService with ChangeNotifier {
  ServiceStatus _serviceStatus = ServiceStatus.Conneting;

  get serverStatus => _serviceStatus;

  SocketService() {
    _initConfig();
  }
  void _initConfig() {
    Socket socket = io(
        'http://10.0.0.15:3000',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build());
    socket.connect();
    socket.onConnect((_) {
      print('conectado');
      _serviceStatus = ServiceStatus.Online;
      notifyListeners();
    });
    socket.onDisconnect((_) {
      print('desconectado');
      _serviceStatus = ServiceStatus.Offline;
      notifyListeners();
    });
    socket.on('Nuevo-mensaje', (payload) {
      print('Nuevo-mensaje $payload' );
    });
  }
}
