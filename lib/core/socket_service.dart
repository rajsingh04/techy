import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:techy/utils/constant.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  io.Socket? _socket;
  final _storage = FlutterSecureStorage();

  SocketService._internal() {
    initSocket();
  }

  initSocket() async {
    String token = await _storage.read(key: 'token') ?? '';
    _socket = io.io(
      uri,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'Authorization': token})
          .build(),
    );

    socket.onError((err) => log('❌ General error: $err'));
    _socket!.onConnect((_) {
      log('Socket connected : ${_socket!.id}');
    });
    _socket!.connect();
    _socket!.onDisconnect((_) {
      log('Socket disconnected');
    });

    socket.io.engine?.on('upgrade', (_) {
      log('⬆️ Transport upgraded to WebSocket');
    });
  }

  io.Socket get socket => _socket!;
}
