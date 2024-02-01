import 'client.dart';

const String version = '0.0.1';

///This project works with 3 packages :
///
/// - pointycastle (to generate RSA keys)
///
/// - asn1lib (to format RSA keys in pem format)
///
/// - encrypt (for RSA and Salsa20)
void main(List<String> arguments) {
  final client = ClientIO();
  client.connect();
  final client2 = ClientIO();
  client2.connect();
}
