import 'package:encrypt/encrypt.dart';

class Salsa20Encryption {
  late final Key key;
  final iv = IV.fromLength(8);
  late final Encrypter encrypter;

  Salsa20Encryption([String? k]) {
    key = k == null ? Key.fromLength(32) : Key.fromBase64(k);
    encrypter = Encrypter(Salsa20(key));
  }

  Salsa20Encryption.demo([String? k]) {
    key = k == null ? Key.fromLength(32) : Key.fromBase64(k);
    encrypter = Encrypter(Salsa20(key));
    print('Salsa key : ${key.base64}');
  }

  String encrypt(String plainText) =>
      encrypter.encrypt(plainText, iv: iv).base64;

  String decrypt(String encrypted) => encrypter.decrypt64(encrypted, iv: iv);
}
