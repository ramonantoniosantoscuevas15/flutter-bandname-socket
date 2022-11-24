import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus { online, offline, conneting }

class SocketService with ChangeNotifier {
  final ServerStatus _serverStatus = ServerStatus.conneting;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    Socket socket = io(
        'http://10.0.2.2:3000',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build());

    // ignore: avoid_print
    socket.onConnect((_) => print('conectado'));
    // ignore: avoid_print
    socket.onDisconnect((_) => print('conectado'));
  }
}
