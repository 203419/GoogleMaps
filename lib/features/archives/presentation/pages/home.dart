import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_auth/features/archives/domain/entities/message.dart';
import 'package:app_auth/features/archives/domain/usecases/message_usecases.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './pdf_screen.dart';

import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  static const routeName = '/Home';

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final String? userName = FirebaseAuth.instance.currentUser!.displayName;
  final String? userId = FirebaseAuth.instance.currentUser!.uid;

  File? _pdfFile;
  LatLng? _locationData;

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      _pdfFile = File(result.files.single.path!);
    }
  }

  Future<void> _pickLocation() async {
    Location location = Location();

    LocationData? currentLocation = await location.getLocation();

    _locationData =
        LatLng(currentLocation.latitude!, currentLocation.longitude!);
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _sendMessage() async {
      final Message message = Message(
        userId: userId ?? '',
        userName: userName,
        pdfUrl: _pdfFile,
        location: _locationData,
        timestamp: DateTime.now(),
      );
      await Provider.of<SaveMessageUseCase>(context, listen: false)
          .call(message);
      setState(() {
        _pdfFile = null;
        _locationData = null;
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
        backgroundColor: const Color(0xFF6CBEED),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream:
                  Provider.of<GetMessagesUseCase>(context).call().asStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 16.0),
                        child: Column(
                          children: [
                            Text(
                              'user: ${message.userName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (message.pdfUrl != null)
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PDFViewPage(
                                                file: message.pdfUrl!),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 70,
                                        decoration: BoxDecoration(
                                          // color #7C7A7A
                                          color: const Color(0xFF7C7A7A),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.picture_as_pdf,
                                              color: Colors.white,
                                              // tamaño del icono
                                              size: 35),
                                        ),
                                      ),
                                    ),
                                  if (message.location != null)
                                    Container(
                                      height: 200, // Define the height
                                      child: GoogleMap(
                                        initialCameraPosition: CameraPosition(
                                          target: message.location!,
                                          zoom: 15,
                                        ),
                                        markers: {
                                          Marker(
                                            markerId: MarkerId(
                                                message.location.toString()),
                                            position: message.location!,
                                          ),
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // centra los elementos en el Row
              children: [
                IconButton(
                  onPressed: () async {
                    await _pickPdf();
                  },
                  icon: Icon(Icons.picture_as_pdf,
                      color: Color(0xFF6CBEED), size: 28),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                IconButton(
                  onPressed: () async {
                    await _pickLocation();
                  },
                  icon: Icon(Icons.location_on,
                      color: Color(0xFF6CBEED), size: 28),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                IconButton(
                  onPressed: () async {
                    await _sendMessage();
                  },
                  icon: Icon(Icons.send, color: Color(0xFF6CBEED), size: 28),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
