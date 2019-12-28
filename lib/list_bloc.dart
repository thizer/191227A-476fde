import 'dart:async';

import 'package:dio/dio.dart';

class ListBloc {
  StreamController<List<dynamic>> _streamController = StreamController<List<dynamic>>();

  Stream<List<dynamic>> get output => _streamController.stream;

  StreamSink<List<dynamic>> get _input => _streamController.sink;

  Dio _dio = Dio();

  String endpoint = 'https://5e0674dd8983960014ebefac.mockapi.io';

  ListBloc() {
    getList();
  }

  void getList() async {
    Response resp = await _dio.get('$endpoint/aulas/');

    _input.add(resp.data);
  }

  void create() async {
    await _dio.post('$endpoint/aulas/', data: {
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'name': 'Um novo registro',
      'desc': 'Este registro foi gerado automaticamente',
    });
    getList();
  }

  void update(String id) async {
    await _dio.put('$endpoint/aulas/$id', data: {
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'name': 'Registro modificado',
      'desc': 'Este registro foi modificado dentro do sistema',
    });
    getList();
  }

  void delete(String id) async {
    await _dio.delete('$endpoint/aulas/$id');
    getList();
  }

  void dispose() {
    _streamController.close();
  }
}
