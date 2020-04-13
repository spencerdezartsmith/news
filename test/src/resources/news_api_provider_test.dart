import 'package:news/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  test('fetchTopIds returns a list of ids', () async {
    final newsApi = NewsApiProvider();
    // MockClient is invoked whnenver a http request is called from our code
    newsApi.client = MockClient((request) async {
      return Response(json.encode([1, 2, 3, 4]), 200);
    });
    
    final ids = await newsApi.fetchTopIds();

    expect(ids, [1, 2, 3, 4]);
  });

  test('fetchItem returns single item', () async {
    final newsApi = NewsApiProvider();
    final jsonMap = { 'id': 123 };

    newsApi.client = MockClient((request) async {
      return Response(json.encode(jsonMap), 200);
    });

    final item = await newsApi.fetchItem(999);

    expect(item.id, 123);
  });
}