import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
enum ServerStatus{
  Online,
  Offline,
  Connecting,
}
 
class SocketService with ChangeNotifier {
  final ServerStatus _serverStatus = ServerStatus.Connecting;
 
  SocketService(){
    _initConfig();
  }
 
  void _initConfig(){  
    Socket socket = io(
      "http://10.0.2.2:3000",
      OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect() 
        .build()
    );
 
    socket.onConnect((_) {
      socket.emit('mensaje', 'conectado desde app Flutter');
      print('connect');
    });
 
    socket.onDisconnect((_) => print('disconnect'));
  }
}