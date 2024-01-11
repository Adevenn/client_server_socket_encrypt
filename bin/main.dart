import 'encryption.dart';

const String version = '0.0.1';

///This project works with 3 packages :
///
/// - pointycastle
///
/// - asn1lib
///
/// - encrypt
void main(List<String> arguments) {
  var encryption = Encryption.demo();
  /*var server = ServerIO();
  server.start();
  var client = ClientIO();
  client.connect();*/
}
