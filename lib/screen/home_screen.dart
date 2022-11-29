import 'package:bandas/models/models.dart';

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [
    //Band(id: '1', name: 'Metalica', votes: 5),
    //Band(id: '2', name: 'Linkin Park', votes: 7),
    //Band(id: '3', name: 'ACDC', votes: 8),
    //Band(id: '4', name: 'Queen', votes: 4),
  ];
  @override
  void initState() {
    final socketservice = Provider.of<SocketService>(context, listen: false);
    socketservice.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketservice = Provider.of<SocketService>(context, listen: false);
    socketservice.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketservice = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'BandNames',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketservice.serverStatus == ServiceStatus.Online)
                ? Icon(
                    Icons.check_circle,
                    color: Colors.blue[300],
                  )
                : const Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
          )
        ],
      ),
      body: Column(
        children: [
          if(bands.isNotEmpty)
          _showGraph(),
          Expanded(
            child: ListView.builder(
                itemCount: bands.length,
                itemBuilder: (context, i) => _bandTile(bands[i])),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: () => addNewBand(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketservice = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(band.id ?? ''),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        //print('id: ${band.id}');
        socketservice.emit('delete-band', {'id': band.id});
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Delete band',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name!.substring(0, 2)),
        ),
        title: Text(band.name!),
        trailing: Text(
          '${band.votes}',
          style: const TextStyle(fontSize: 20),
        ),
        onTap: () => socketservice.socket.emit('vote-band', {'id': band.id}),
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('New Band Name'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                elevation: 5,
                onPressed: () => addBandTolist(textController.text),
                textColor: Colors.blue,
                child: const Text('Add'),
              )
            ],
          );
        });
  }

  void addBandTolist(String name) {
    if (name.length > 1) {
      //podemos agregar
      final socketservice = Provider.of<SocketService>(context, listen: false);
      socketservice.socket.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }

  //mostrar grafica
  _showGraph() {
    Map<String, double> dataMap = {};
    bands.forEach((band) {
      dataMap.putIfAbsent(band.name?? '', () => band.votes!.toDouble());
    });

    return Container(
        width: double.infinity, height: 200, child: PieChart(dataMap: dataMap)
        
        
        
        
        );
  }
}
