import 'dart:io';
import 'package:app_auth/features/archives/domain/entities/message.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MessageModel extends Message {
  MessageModel({
    required String userId,
    File? pdfUrl,
    LatLng? location,
    final String? userName,
    required final DateTime timestamp,
  }) : super(
          userId: userId,
          pdfUrl: pdfUrl,
          location: location,
          userName: userName,
          timestamp: timestamp,
        );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      userId: json['userId'],
      pdfUrl: json['pdfUrl'],
      location: json['location'],
      userName: json['userName'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(
          json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  MessageModel copyWith({
    String? userId,
    File? pdfUrl,
    LatLng? location,
    String? userName,
    DateTime? timestamp,
  }) {
    return MessageModel(
      userId: userId ?? this.userId,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      location: location ?? this.location,
      userName: userName ?? this.userName,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      userId: message.userId,
      pdfUrl: message.pdfUrl,
      location: message.location,
      userName: message.userName,
      timestamp: message.timestamp,
    );
  }
}
