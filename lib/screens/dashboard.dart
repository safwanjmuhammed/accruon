import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  CameraController? controller;
  late List<CameraDescription> cameras;
  double latitude = 0.0;
  double longitude = 0.0;

  void liveLocation() async {
    final permission = await Geolocator.checkPermission();
    final locationService = await Geolocator.isLocationServiceEnabled();
    try {
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      } else {
        Geolocator.getPositionStream(
                locationSettings:
                    const LocationSettings(accuracy: LocationAccuracy.high))
            .listen((position) {
          setState(() {
            latitude = position.latitude;
            longitude = position.longitude;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('LAT  $latitude   LON  $longitude')));
            print(latitude);
            print(longitude);
          });
        });
      }
    } catch (e) {
      print(e);
    }
  }

  getCamera() async {
    cameras = await availableCameras();
    controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
    );
    await controller!.initialize().then((value) {
      setState(() {});
    }).catchError((e) {
      print(e);
    });
  }

  takePicture() async {
    try {
      final image = await controller!.takePicture();
      print(image.path);
      final storageDirectory = await getExternalStorageDirectories();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCamera();
    liveLocation();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller!.value.isInitialized) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.camera_alt_sharp),
            onPressed: () {
              takePicture();
            }),
        body: CameraPreview(controller!),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
}
