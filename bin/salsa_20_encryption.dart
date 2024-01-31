import 'package:encrypt/encrypt.dart';

class Salsa20Encryption {
  final key = Key.fromLength(32);
  final iv = IV.fromLength(8);
  late final Encrypter encrypter;

  Salsa20Encryption() {
    encrypter = Encrypter(Salsa20(key));
  }

  String encrypt(String plainText) =>
      encrypter.encrypt(plainText, iv: iv).base64;

  String decrypt(String encrypted) => encrypter.decrypt64(encrypted, iv: iv);
}
