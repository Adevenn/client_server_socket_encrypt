import 'client.dart';

const String version = '0.0.2';

///This project works with 3 packages :
///
/// - pointycastle (to generate RSA keys)
///
/// - asn1lib (to format RSA keys in pem format)
///
/// - encrypt (for RSA and Salsa20)
void main(List<String> arguments) async {
  final client = ClientIO();
  final client2 = ClientIO();
  await client.getSalsaKey();
  await client2.getSalsaKey();
  client.start();
  client2.start();
}
