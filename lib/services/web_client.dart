import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:http/http.dart' as http;
import 'http_interceptor.dart';

class WebClient {
  static const String _url = "http://192.168.0.108:3000/";

  geturl() {
    return _url;
  }

  static http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);
}
