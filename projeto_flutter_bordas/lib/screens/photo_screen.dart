import 'dart:typed_data';
import 'dart:io';
import 'package:image/image.dart' as img;

import 'package:flutter/material.dart';

class PhotoScreen extends StatefulWidget {                                                                                                              
  final String path;
                                                                                                                                                        
  const PhotoScreen({super.key, required this.path});

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {

  Uint8List? _processedImage; 
  Uint8List? _grayImage;                                                                                                                            
  bool _isProcessing = true;      

  @override                                                                                                                                               
  void initState() {                                                                                                                                      
    super.initState();                                                                                                                                    
    _processImage();                                                                                                                                      
  }               

  Future<void> _processImage() async {
    
    final bytes = await File(widget.path).readAsBytes();

    final original = img.decodeImage(bytes)!;

    final gray = img.grayscale(original);

    final grayEncoded = img.encodePng(gray);

    final edgeImage = img.Image(width: gray.width, height: gray.height);   

    for (int y = 1; y < gray.height - 1; y++) {                                                                                                             
      for (int x = 1; x < gray.width - 1; x++) {                                                                                                            
        final p = gray.getPixel(x, y).r.toInt();
        final right = gray.getPixel(x + 1, y).r.toInt();
        final bottom = gray.getPixel(x, y + 1).r.toInt();
        final diff = ((p - right).abs() + (p - bottom).abs()).clamp(0, 255);
        edgeImage.setPixelRgb(x, y, diff, diff, diff);
      }
    }

      final encoded = img.encodePng(edgeImage);
      setState(() {
        _grayImage = grayEncoded;
        _processedImage = encoded;
        _isProcessing = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    if (_isProcessing) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );

    } else { 
    return Scaffold(                                                                                                                                        
        appBar: AppBar(title: const Text('Resultado')),                                                                                                       
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: Text('Original', style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 12, letterSpacing: 1.5)),
              ),
              Image.file(File(widget.path), width: double.infinity, fit: BoxFit.cover),
              const SizedBox(height: 32),
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: Text('Tons de cinza', style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 12, letterSpacing: 1.5)),
              ),
              Image.memory(_grayImage!, width: double.infinity, fit: BoxFit.cover),
              const SizedBox(height: 32),
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: Text('Bordas detectadas', style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 12, letterSpacing: 1.5)),
              ),
              Image.memory(_processedImage!, width: double.infinity, fit: BoxFit.cover),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    }
  }
}