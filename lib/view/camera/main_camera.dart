import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:object_recognition/view/camera/components/picture_items.dart';
import 'package:object_recognition/view/camera/components/zoom_view.dart';
import 'package:object_recognition/view/header/main_header.dart';
import 'package:object_recognition/view/stack_on_camera/components/pick_image_gallery.dart';
import 'package:object_recognition/view/stack_on_camera/main_stackOnCamera.dart';
import 'package:object_recognition/res/colors.dart';
import 'package:object_recognition/res/constante.dart';

class MainCamera extends ConsumerStatefulWidget {
  const MainCamera({super.key});

  @override
  _MainCameraState createState() => _MainCameraState();
}

class _MainCameraState extends ConsumerState<MainCamera> {
  late CameraController cameraController;
  late FlutterVision vision;
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;
  double confidenceThreshold = 0.5;
  late List<CameraDescription> camerass;
  bool isDoubleTap = false;

  late Future<void> _initCameraController;

  @override
  void initState() {
    super.initState();
    _initCameraController = camera();
    vision = FlutterVision();
    loadYoloModel();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void affichageIsDT() {
    print("Double tap: $isDoubleTap");
  }

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });
    if (cameraController.value.isStreamingImages) return;

    await cameraController.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        await yoloOnFrame(image);
      }
    });
  }

  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
  }

  Future<void> camera() async {
    camerass = await availableCameras();
    cameraController = CameraController(camerass[0], ResolutionPreset.high);
    await cameraController.initialize();
    await loadYoloModel();
    setState(() {
      isLoaded = true;
      isDetecting = false;
      yoloResults = [];
    });
  }

  Future<void> loadYoloModel() async {
    await vision.loadYoloModel(
      labels: 'assets/labels/labels_objectDetection_Coco.txt',
      modelPath: 'assets/models/yolov5.tflite',
      modelVersion: "yolov5",
      numThreads: 1,
      useGpu: true,
    );
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    if (isDetecting) {
      final result = await vision.yoloOnFrame(
        bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        iouThreshold: 0.4,
        confThreshold: confidenceThreshold,
        classThreshold: 0.5,
      );
      if (result.isNotEmpty) {
        setState(() {
          yoloResults = result;
        });
      }
    }
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];

    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);
    Color colorPick = secondarytColor;

    return yoloResults.map((result) {
      double objectX = result["box"][0] * factorX;
      double objectY = result["box"][1] * factorY;
      double objectWidth = (result["box"][2] - result["box"][0]) * factorX;
      double objectHeight = (result["box"][3] - result["box"][1]) * factorY;

      return Positioned(
        left: objectX,
        top: objectY - 120,
        width: objectWidth,
        height: objectHeight,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(0.0)),
              border: Border.all(
                color: Colors.red,
              )),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(1)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: fourthColor,
              fontSize: 12.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    double _currentZoom = 1.0;
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: _initCameraController,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!cameraController.value.isInitialized) {
                return const Center(
                    child: Text("Erreur : Caméra non initialisée"));
              }

              return GestureDetector(
                onTap: null,
                onPanUpdate: null,
                child: Container(
                  decoration: BoxDecoration(color: blackColor),
                  padding:
                      EdgeInsets.symmetric(horizontal: deffaultPadding / 3),
                  height: size.height,
                  width: size.width,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: MainHeader(cameraController: cameraController),
                      ),
                      Expanded(
                        flex: 36,
                        child: Stack(
                          children: [
                            ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.overlay,
                              ),
                              child: CameraPreview(cameraController),
                            ),
                            MainStackoncamera(),
                            PickImageGallery(),
                            ...displayBoxesAroundRecognizedObjects(size),
                            Positioned(
                              bottom: 15,
                              right: 5,
                              child: ElevatedButton(
                                onPressed: startDetection,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: primaryColor,
                                ),
                                child: Text(
                                  "Start",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: secondarytColor,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 15,
                              right: 90,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: primaryColor,
                                ),
                                onPressed: stopDetection,
                                child: Text(
                                  "Stop",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                flex: 5,
                                child: PictureItems(
                                  cameraController: cameraController,
                                  isDoubleTap: isDoubleTap,
                                  activateBtn: affichageIsDT,
                                ),
                              ),
                              const Spacer(flex: 2),
                              Expanded(
                                flex: 5,
                                child: ZoomView(
                                  minZoom: 1.0,
                                  maxZoom: 4.0,
                                  onZoomChanged: (zoom) {
                                    setState(() {
                                      _currentZoom = zoom;
                                    });
                                    cameraController.setZoomLevel(_currentZoom);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Erreur snapshot : ${snapshot.error}"));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
