import 'package:encrypt/encrypt.dart';

class Salsa20Encryption {
  late final Key key;
  late final IV iv;
  late final Encrypter _encrypter;

  Salsa20Encryption([String? k, String? i]) {
    key = k == null ? Key.fromLength(32) : Key.fromBase64(k);
    iv = i == null ? IV.fromLength(8) : IV.fromBase64(i);
    _encrypter = Encrypter(Salsa20(key));
  }

  Salsa20Encryption.demo([String? k]) {
    key = k == null ? Key.fromLength(32) : Key.fromBase64(k);
    _encrypter = Encrypter(Salsa20(key));
    print('Salsa key : ${key.base64}, Salsa IV : ${iv.base64}');
  }

  String encrypt(String plainText) =>
      _encrypter.encrypt(plainText, iv: iv).base64;

  String decrypt(String encrypted) => _encrypter.decrypt64(encrypted, iv: iv);
}
