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
  int _currentPage = 0;
  final PageController _pageController = PageController();

  final List<String> _labels = ['Original', 'Tons de cinza', 'Bordas detectadas'];

  @override
  void initState() {
    super.initState();
    _processImage();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

    setState(() {
      _grayImage = Uint8List.fromList(grayEncoded);
      _processedImage = Uint8List.fromList(img.encodePng(edgeImage));
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isProcessing) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final images = [
      Image.file(File(widget.path), fit: BoxFit.contain),
      Image.memory(_grayImage!, fit: BoxFit.contain),
      Image.memory(_processedImage!, fit: BoxFit.contain),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, index) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: images[index],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            _labels[index],
                            style: const TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 2,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == i ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == i ? Colors.white : Colors.white30,
                  borderRadius: BorderRadius.circular(4),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
