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
  var encryption = Encryption();
  print('${DateTime.now()} : generating keys');
  encryption.generateKeyPair();
  print('${DateTime.now()} : keys generation done');
  print(encryption.pemPublicKey());
  print(encryption.pemPrivateKey());
  /*var server = ServerIO();
  server.start();
  var client = ClientIO();
  client.connect();*/
}
