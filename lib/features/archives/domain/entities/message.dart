import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Message {
  final String userId;

  File? pdfUrl;
  LatLng? location;
  final DateTime timestamp;
  final String? userName;

  Message({
    required this.userId,
    this.pdfUrl,
    this.location,
    required this.timestamp,
    required this.userName,
  });
}
