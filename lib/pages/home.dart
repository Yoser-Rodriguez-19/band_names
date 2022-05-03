import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_name/models/band.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 3),
    Band(id: '3', name: 'Iron Maiden', votes: 2),
    Band(id: '4', name: 'Rammstein', votes: 1),
    Band(id: '5', name: 'AC/DC', votes: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('BandNames', style: TextStyle( color: Colors.black87 ),),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index) => _bandTile(bands[index])
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
   );
  }

  Widget _bandTile( Band band ) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        print('$direction');
        print('name: ${band.name}');
        //TODO: llamar el borrado en el servidor
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete band', style: TextStyle( color: Colors.white ),),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20),),
        onTap: () {
         
        },
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();
    if ( !Platform.isAndroid ) {
      return showDialog(
        context: context, 
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('New band name'),
            content: TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Enter the name of the band'
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                child: const Text('Add'),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => addBandToList(textController.text),
              )
            ],
          );
        }
      );
    }

    showCupertinoDialog(
      context: context, 
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('New band name'),
          content: CupertinoTextField(
            controller: textController,
            placeholder: 'Enter the name of the band',
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Add'),
              isDefaultAction: true,
              onPressed: () => addBandToList(textController.text),
            ),
            CupertinoDialogAction(
              child: const Text('Dismiss'),
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      }
    );

  }


  void addBandToList(String name) {

    if ( name.length > 1 ) {
      final newBand = Band(
      id: DateTime.now().toString(), 
      name: name, 
      votes: 0
      );
      setState(() {
        bands.add(newBand);
      });
    } 
    
    Navigator.pop(context);
  
  }


}