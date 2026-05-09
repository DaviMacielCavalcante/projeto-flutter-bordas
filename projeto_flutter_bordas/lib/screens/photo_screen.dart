import 'dart:io';
import 'package:flutter/material.dart';

class PhotoScreen extends StatelessWidget {                                                                                                             
  final String path;
                                                                                                                                                        
  const PhotoScreen({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.file(File(path)),
      appBar: AppBar(title: const Text('Foto'),),
    );
  }
}
