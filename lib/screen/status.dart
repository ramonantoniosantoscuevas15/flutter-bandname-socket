import 'package:bandas/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socketservice = Provider.of<SocketService>(context);
    return const Scaffold(
      body: Center(
        child: Text('StatusScreen'),
      ),
    );
  }
}
