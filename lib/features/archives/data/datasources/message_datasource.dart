import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/message_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MessageDataSource {
  Future<void> saveMessage(MessageModel message);
  Future<List<MessageModel>> getMessages();
}

class FirebaseMessageDataSource implements MessageDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  FirebaseMessageDataSource({
    required this.firestore,
    required this.storage,
  });

  @override
  Future<void> saveMessage(MessageModel message) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('not_logged_in');
    }

    final messageRef = firestore.collection('messages').doc();
    final messageWithId = message.copyWith(
      userId: user.uid,
      pdfUrl: null,
      location: null,
    );

    await messageRef.set(messageWithId.toJson());

    if (message.pdfUrl != null) {
      final pdfRef = storage.ref().child('pdfs/${messageRef.id}');
      await pdfRef.putFile(message.pdfUrl!);
      final pdfUrl = await pdfRef.getDownloadURL();
      await messageRef.update({'pdfUrl': pdfUrl});
    }

    if (message.location != null) {
      await messageRef.update({
        'location': {
          'latitude': message.location!.latitude,
          'longitude': message.location!.longitude,
        }
      });
    }
  }

  @override
  Future<List<MessageModel>> getMessages() async {
    final messagesQuery =
        await firestore.collection('messages').orderBy('timestamp').get();
    final List<MessageModel> messages = [];

    for (final messageDoc in messagesQuery.docs) {
      final messageData = messageDoc.data();
      final messageModel = MessageModel(
        userId: messageData['userId'],
        pdfUrl: null,
        location: messageData['location'] != null
            ? LatLng(
                messageData['location']['latitude'],
                messageData['location']['longitude'],
              )
            : null,
        userName: messageData['userName'],
        timestamp: DateTime.fromMillisecondsSinceEpoch(
            messageData['timestamp'] ?? DateTime.now().millisecondsSinceEpoch),
      );

      if (messageData.containsKey('pdfUrl')) {
        final pdfUrl = messageData['pdfUrl'];
        final pdfFile = await _downloadFile(pdfUrl);
        messageModel.pdfUrl = pdfFile;
      }

      messages.add(messageModel);
    }

    return messages;
  }

  Future<File> _downloadFile(String url) async {
    final uuid = Uuid();
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/${uuid.v4()}';
    final file = File(filePath);
    final response = await storage.refFromURL(url).writeToFile(file);
    if (response.state == TaskState.success) {
      return file;
    } else {
      throw Exception('Error downloading file');
    }
  }
}
