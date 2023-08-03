import 'package:app_auth/features/archives/data/datasources/message_datasource.dart';
import 'package:app_auth/features/archives/domain/entities/message.dart';
import 'package:app_auth/features/archives/domain/repositories/message_repository.dart';
import '../models/message_model.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageDataSource dataSource;

  MessageRepositoryImpl(this.dataSource);

  @override
  Future<void> saveMessage(Message message) async {
    final messageModel = MessageModel.fromEntity(message);
    await dataSource.saveMessage(messageModel);
  }

  @override
  Future<List<MessageModel>> getMessages() {
    return dataSource.getMessages();
  }
}
