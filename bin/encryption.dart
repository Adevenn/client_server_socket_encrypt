import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:encrypt/encrypt.dart' as e;
import 'package:pointycastle/export.dart';

class Encryption {
  late RSAPrivateKey privateKey;
  late RSAPublicKey publicKey;
  late e.Encrypter encrypter;

  Encryption() {
    _generateKeyPair();
  }

  Encryption.demo() {
    print('${DateTime.now()} : generating keys');
    _generateKeyPair();
    print('${DateTime.now()} : keys generation done');
    print(pemPublicKey());
    print(pemPrivateKey());
    final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
    final encrypted = encrypt(plainText);
    final decrypted = decrypt(encrypted);
    print(
        'Plain text : $plainText\nEncrypted : $encrypted\nDecrypted : $decrypted');
  }

  SecureRandom _secureRandom() {
    final secureRandom = FortunaRandom();
    final random = Random.secure();
    final seeds = <int>[];
    for (int i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }

  String encrypt(String p) => encrypter.encrypt(p).base64;

  String decrypt(String e) => encrypter.decrypt64(e);

  void _generateKeyPair() {
    final rsaPars = RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 5);
    final params = ParametersWithRandom(rsaPars, _secureRandom());
    final keyGenerator = RSAKeyGenerator();
    keyGenerator.init(params);
    AsymmetricKeyPair keyPair = keyGenerator.generateKeyPair();
    privateKey = keyPair.privateKey as RSAPrivateKey;
    publicKey = keyPair.publicKey as RSAPublicKey;
    encrypter =
        e.Encrypter(e.RSA(publicKey: publicKey, privateKey: privateKey));
  }

  String pemPublicKey() {
    final pem = ASN1Sequence()
      ..add(ASN1Integer(publicKey.modulus!))
      ..add(ASN1Integer(publicKey.exponent!));
    final dataBase64 = base64.encode(pem.encodedBytes);
    return """-----BEGIN PUBLIC KEY-----\r\n$dataBase64\r\n-----END PUBLIC KEY-----""";
  }

  String pemPrivateKey() {
    final pem = ASN1Sequence()
      ..add(ASN1Integer(BigInt.from(0)))
      ..add(ASN1Integer(privateKey.n!))
      ..add(ASN1Integer(privateKey.exponent!))
      ..add(ASN1Integer(privateKey.p!))
      ..add(ASN1Integer(privateKey.p!))
      ..add(ASN1Integer(privateKey.q!))
      ..add(ASN1Integer(
          privateKey.privateExponent! % (privateKey.p! - BigInt.from(1))))
      ..add(ASN1Integer(
          privateKey.privateExponent! % (privateKey.q! - BigInt.from(1))))
      ..add(ASN1Integer(privateKey.q!.modInverse(privateKey.p!)));
    final dataBase64 = base64.encode(pem.encodedBytes);
    return """-----BEGIN PRIVATE KEY-----\r\n$dataBase64\r\n-----END PRIVATE KEY-----""";
  }
}
