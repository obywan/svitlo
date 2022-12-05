import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ServerResponse {
  bool success;
  String body;

  ServerResponse(this.success, this.body);
}

class ApiRequestsHelper {
  static const String baseUrl = 'https://svitlo.ternopil.webcam';

  static Future<ServerResponse> requestGET({required String apiMethod}) async {
    // final authHeaders = await _getAuthHeaders();
    return genericRequest(http.get(_composeUri(apiMethod)));
  }

  static Future<ServerResponse> requestPOST({required String apiMethod, String? body}) async {
    // debugPrint(body);
    // final authAndContentTypeHeaders = needAuth ? await _getAuthAndContentTypeHeaders() : _getJsonContentTypeHeaders();
    return genericRequest(http.post(_composeUri(apiMethod), body: body));
  }

  // static Future<ServerResponse> requestPATCHMultipart(String apiMethod, {Map<String, String> info, String filePath}) async {
  //   final result = await _multipartRequest("PATCH", apiMethod, info: info, filePath: filePath);
  //   return result;
  // }

  // static Future<ServerResponse> requestPOSTMultipart(String apiMethod, {Map<String, String> info, String filePath}) async {
  //   final result = await _multipartRequest("POST", apiMethod, info: info, filePath: filePath);
  //   return result;
  // }

  // static Future<ServerResponse> _multipartRequest(String type, String apiMethod, {Map<String, String> info, String filePath}) async {
  //   final authAndContentTypeHeaders = await _getAuthAndContentTypeHeaders();
  //   var uri = _composeUri(apiMethod);
  //   var request = new http.MultipartRequest(type, uri);
  //   request.headers.clear();
  //   request.headers.addAll(authAndContentTypeHeaders);

  //   if (info != null) request.fields.addAll(info);

  //   if (filePath != null)
  //     request.files.add(
  //       await http.MultipartFile.fromPath('image', filePath),
  //     );

  //   // send
  //   try {
  //     var response = await request.send();
  //     if (response.statusCode < 300) {
  //       final b = await response.stream.bytesToString();
  //       return ServerResponse(true, b);
  //     } else {
  //       print(response.statusCode);
  //       print(await response.stream.bytesToString());
  //       return ServerResponse(false, 'Bad response code');
  //     }
  //   } on Exception catch (e) {
  //     return ServerResponse(false, 'Connection failed');
  //   }
  // }

  // static Future<ServerResponse> requestPATCH(String apiMethod, String body) async {
  //   final authHeaders = await _getAuthAndContentTypeHeaders();
  //   return genericRequest(http.patch(_composeUri(apiMethod), body: body, headers: authHeaders));
  // }

  // static Future<ServerResponse> requestDEL(String apiMethod) async {
  //   final authHeaders = await _getAuthHeaders();
  //   return genericRequest(http.delete(_composeUri(apiMethod), headers: authHeaders));
  // }

  static Uri _composeUri(String suffix) => Uri.parse('$baseUrl$suffix');

  static Future<ServerResponse> genericRequest(Future<http.Response> request) async {
    try {
      final response = await request;
      if (response.statusCode < 300) {
        // debugPrint('_genericRequest success for request ${response.request?.url}: ' + response.body);
        return ServerResponse(true, response.body);
      } else {
        debugPrint('_genericRequest failed:' + response.body);
        return ServerResponse(false, response.body);
      }
    } on Exception catch (e) {
      return ServerResponse(false, e.toString());
    }
  }

  // static Future<Map<String, String>> _getAuthHeaders() async {
  //   final accessToken = await AuthProvider.checkTokenExpDate();
  //   final bool tokenIsValid = accessToken != null;
  //   debugPrint('token is valid: $tokenIsValid');
  //   final tokenHeaderValue = 'Bearer $accessToken';
  //   return {'Authorization': tokenHeaderValue};
  // }

  // static Future<Map<String, String>> _getAuthAndContentTypeHeaders() async {
  //   final accessToken = await AuthProvider.checkTokenExpDate();
  //   final bool tokenIsValid = accessToken != null;
  //   debugPrint('token is valid: $tokenIsValid');

  //   final tokenHeaderValue = 'Bearer $accessToken';
  //   return {'Authorization': tokenHeaderValue, 'Content-Type': 'application/json'};
  // }

  // static Map<String, String> _getJsonContentTypeHeaders() => {'Content-Type': 'application/json'};
}
