import 'dart:async';
import 'dart:convert';

import 'package:web_socket_client/web_socket_client.dart';

class ChatWebService {
  // Ensures that only one instance of ChatWebService exists (Singleton pattern)
  static final _instance = ChatWebService.internal();
  
  static const String _baseUrl = 'wss://shinkaai-backend.onrender.com/ws/chat';
  // Use 10.0.2.2 if testing on Android Emulator
  // static const String _baseUrl = 'ws://10.0.2.2:8000/ws/chat';
  // Use the one below for local development
  // static const String _baseUrl = 'ws://localhost:8000/ws/chat';

  WebSocket? _socket;
  bool _isConnected = false;
  Completer<void>? _connectionCompleter;

  factory ChatWebService() => _instance;

  // privatized the constructor to prevent multiple instances
  ChatWebService.internal();
  
  final _searchResultController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _contentController = StreamController<Map<String, dynamic>>.broadcast();

  // Storage for the last results to prevent race conditions during navigation
  Map<String, dynamic>? _lastSearchResults;
  final List<String> _contentChunks = [];

  Stream<Map<String, dynamic>> get searchResultsStream =>
      _searchResultController.stream;
  Stream<Map<String, dynamic>> get contentStream => _contentController.stream;

  Map<String, dynamic>? get lastSearchResults => _lastSearchResults;
  List<String> get contentChunks => List.unmodifiable(_contentChunks);

  void connect() {
    if (_isConnected && _socket != null) {
      print('Already connected to WebSocket.');
      return;
    }

    // Reset completer if needed
    if (_connectionCompleter == null || _connectionCompleter!.isCompleted) {
      _connectionCompleter = Completer<void>();
    }

    print('Connecting to WebSocket at $_baseUrl...');
    
    try {
      _socket = WebSocket(Uri.parse(_baseUrl));
      
      _socket!.connection.listen((state) {
        if (state is Connected || state is Reconnected) {
          _isConnected = true;
          if (!_connectionCompleter!.isCompleted) {
            _connectionCompleter!.complete();
          }
          print('WebSocket connection established ✅');
        } else if (state is Disconnected) {
          _isConnected = false;
          _connectionCompleter = Completer<void>(); // Ready for next attempt
          print('WebSocket disconnected ❌');
        }
      });

      _socket!.messages.listen((message) {
        try {
          final data = json.decode(message);
          if (data['type'] == 'search_results') {
            _lastSearchResults = data;
            _searchResultController.add(data);
          } else if (data['type'] == 'content') {
            _contentChunks.add(data['data']?.toString() ?? '');
            _contentController.add(data);
          }
        } catch (e) {
          print('Error decoding WebSocket message: $e');
        }
      }, onError: (error) {
        print('WebSocket message error: $error');
        _isConnected = false;
      });
    } catch (e) {
      print('Error during WebSocket connection: $e');
      _isConnected = false;
    }
  }

  Future<void> chat(String query) async {
    // Reset state for new chat
    _lastSearchResults = null;
    _contentChunks.clear();

    if (_socket == null || !_isConnected) {
      print('WebSocket is not connected. Attempting to connect first...');
      connect();
      
      // Wait for connection with timeout
      try {
        await _connectionCompleter?.future.timeout(const Duration(seconds: 5));
      } catch (e) {
        print('Connection timed out: $e');
      }
    }

    if (_isConnected && _socket != null) {
      print('Sending query: $query');
      _socket!.send(json.encode({'query': query}));
    } else {
      print('Failed to send message: WebSocket connection could not be established.');
    }
  }
}
