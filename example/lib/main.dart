import 'package:flutter/material.dart';
import 'package:scroll_restore/scroll_restore.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ScrollDemo(),
    );
  }
}

class ScrollDemo extends StatelessWidget {
  const ScrollDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ScrollRestore Demo')),
      //scrollrestore 
      body: ScrollRestore(
        id: 'demo-list',
        builder: (context, controller) {
          return ListView.builder(
            controller: controller,
            itemCount: 100,
            itemBuilder: (_, i) => ListTile(title: Text('Item #$i')),
          );
        },
      ),
    );
  }
}
