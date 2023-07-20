import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor implements InterceptorContract {
  Logger logger = Logger(printer: PrettyPrinter(methodCount: 0));
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    // logger.v(
    //     'Cabeçalhos:${data.headers}\nStatus Code:${data.baseUrl}\nCorpo:${data.body}');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {

    // if(data.statusCode ~/ 100 == 2){
    //   logger.i(
    //     'Cabeçalhos:${data.headers}\nStatus Code:${data.statusCode}\nCorpo:${data.body}');
    // } else {
    //   logger.e(
    //     'Cabeçalhos:${data.headers}\nStatus Code:${data.statusCode}\nCorpo:${data.body}');
    // }
    

    return data;
  }
}
