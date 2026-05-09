import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:projet_flutter_bordas/screens/photo_screen.dart';

class CameraScreen extends StatefulWidget {                                                                                                             
    const CameraScreen({super.key});
                                                                                                                                                          
    @override                                               
    State<CameraScreen> createState() => _CameraScreenState();
  }

class _CameraScreenState extends State<CameraScreen> {

  CameraController? _controller;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller!.initialize();
    setState(() {
      
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return (
        Scaffold(body: Center(
          child: CircularProgressIndicator(),
        ),)
      );
    } 
    return Scaffold(
      appBar: AppBar(title: const Text("Câmera"),),
      body: Stack(
          children: [
            CameraPreview(_controller!),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child:  Center(
                child: ElevatedButton(onPressed: () async {

                  final photo_path = await _controller!.takePicture();

                  Navigator.push(context, MaterialPageRoute(builder: (_) => PhotoScreen(path: photo_path.path)));

                }, child: const Text("Tirar foto")),
              ),
            )
          ],
        ),
    );
  }
}