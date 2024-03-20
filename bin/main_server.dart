import 'Encryption/salsa_20_encryption.dart';
import 'server.dart';
import 'server_salsa_key.dart';

const String version = '0.0.2';

///This project works with 3 packages :
///
/// - pointycastle (to generate RSA keys)
///
/// - asn1lib (to format RSA keys in pem format)
///
/// - encrypt (for RSA and Salsa20)
void main(List<String> arguments) {
  final salsa20 = Salsa20Encryption();
  final serverSalsa = ServerSalsaKey(salsa20);
  serverSalsa.start();
  final serverIO = ServerIO(salsa20);
  serverIO.start();
}
