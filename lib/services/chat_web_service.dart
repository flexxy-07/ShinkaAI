import 'dart:async';
import 'dart:convert';

import 'package:web_socket_client/web_socket_client.dart';

class ChatWebService {
  // Ensures that only one instance of ChatWebService exists (Singleton pattern)
  static final _instance = ChatWebService.internal();
  WebSocket? _socket;

  factory ChatWebService() => _instance;

  // privatized the constructor to prevent multiple instances
  ChatWebService.internal();
  final _searchResultController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _contentController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get searchResultsStream =>
      _searchResultController.stream;
  Stream<Map<String, dynamic>> get contentStream => _contentController.stream;

  void connect() {
    // establish WebSocket connection
    // Connecting to the deployed Render backend WS endpoint
    _socket = WebSocket(
      Uri.parse('wss://shinkaai-backend.onrender.com/ws/chat'),
    );

    _socket!.messages.listen((message) {
      final data = json.decode(message);
      if (data['type'] == 'search_results') {
        _searchResultController.add(data);
      } else if (data['type'] == 'content') {
        _contentController.add(data);
      }
    });
  }

  void chat(String query) {
    _socket!.send(json.encode({'query': query}));
    print(_socket);
  }
}
