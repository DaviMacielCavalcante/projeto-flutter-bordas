import 'package:flutter/material.dart';
import 'package:projet_flutter_bordas/screens/camera_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Text(
              'Projeto Bordas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => CameraScreen()));
                  },
                  child: const Text('Abrir Câmera'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
