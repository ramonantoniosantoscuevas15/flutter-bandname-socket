// ignore_for_file: constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

enum ServiceStatus { Conneting, Offline, Online }

class SocketService with ChangeNotifier {
  ServiceStatus _serviceStatus = ServiceStatus.Conneting;
  late Socket _socket;

  ServiceStatus get serverStatus => _serviceStatus;
  Socket get socket => _socket;
  Function get emit => _socket.emit;

  SocketService() {
    _initConfig();
  }
  void _initConfig() {
    _socket = io(
        'http://10.0.0.15:3000',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build());
    _socket.connect();
    _socket.onConnect((_) {
      _serviceStatus = ServiceStatus.Online;
      notifyListeners();
    });
    _socket.onDisconnect((_) {
      _serviceStatus = ServiceStatus.Offline;
      notifyListeners();
    });
    //socket.on('Nuevo-mensaje', (payload) {
    // print('Nuevo-mesaje');
    // ignore: avoid_print
    // print('nombre:' + payload['nombre']);
    // ignore: avoid_print
    //print('mensaje:' + payload['mensaje']);
    // ignore: avoid_print
    //print(payload.containsKey('mensaje2')
    //? payload['mensaje2']
    //: 'no hay mensaje');
    //});
  }
}
