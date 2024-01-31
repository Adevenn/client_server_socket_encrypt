import 'client.dart';
import 'server.dart';

const String version = '0.0.1';

///This project works with 3 packages :
///
/// - pointycastle (to generate RSA keys)
///
/// - asn1lib (to format RSA keys in pem format)
///
/// - encrypt (for RSA and Salsa20)
void main(List<String> arguments) {
  /*final rsa = RSAEncryption();
  final salsa20 = Salsa20Encryption();
  print(salsa20.key.base64);
  final publicKeyEncrypted = rsa.encrypt(salsa20.key.base64);
  print(publicKeyEncrypted);
  final publicKeyDecrypted = rsa.decrypt(publicKeyEncrypted);
  print(publicKeyDecrypted);*/
  final server = ServerIO();
  server.start();
  final client = ClientIO();
  client.connect();
  /*final client2 = ClientIO();
  client2.connect();*/
}
