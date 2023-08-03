import 'dart:io';
import '../entities/message.dart';
import '../repositories/message_repository.dart';

class GetMessagesUseCase {
  final MessageRepository repository;

  GetMessagesUseCase(this.repository);

  Future<List<Message>> call() {
    return repository.getMessages();
  }
}

class SaveMessageUseCase {
  final MessageRepository repository;

  SaveMessageUseCase(this.repository);

  Future<void> call(Message message) async {
    await repository.saveMessage(message);
  }
}
