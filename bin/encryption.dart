import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/export.dart';

class Encryption {
  late RSAPrivateKey privateKey;
  late RSAPublicKey publicKey;
  SecureRandom getSecureRandom() {
    var secureRandom = FortunaRandom();
    var random = Random.secure();
    List<int> seeds = [];
    for (int i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }

  void generateKeyPair() {
    var rsaPars = RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 5);
    var params = ParametersWithRandom(rsaPars, getSecureRandom());
    var keyGenerator = RSAKeyGenerator();
    keyGenerator.init(params);
    AsymmetricKeyPair keyPair = keyGenerator.generateKeyPair();
    privateKey = keyPair.privateKey as RSAPrivateKey;
    publicKey = keyPair.publicKey as RSAPublicKey;
  }

  String pemPublicKey() {
    var pem = ASN1Sequence();
    pem.add(ASN1Integer(publicKey.modulus!));
    pem.add(ASN1Integer(publicKey.exponent!));
    var dataBase64 = base64.encode(pem.encodedBytes);
    return """-----BEGIN PUBLIC KEY-----\r\n$dataBase64\r\n-----END PUBLIC KEY-----""";
  }

  String pemPrivateKey() {
    var pem = ASN1Sequence();
    pem.add(ASN1Integer(BigInt.from(0)));
    pem.add(ASN1Integer(privateKey.n!));
    pem.add(ASN1Integer(privateKey.exponent!));
    pem.add(ASN1Integer(privateKey.p!));
    pem.add(ASN1Integer(privateKey.p!));
    pem.add(ASN1Integer(privateKey.q!));
    pem.add(ASN1Integer(
        privateKey.privateExponent! % (privateKey.p! - BigInt.from(1))));
    pem.add(ASN1Integer(
        privateKey.privateExponent! % (privateKey.q! - BigInt.from(1))));
    pem.add(ASN1Integer(privateKey.q!.modInverse(privateKey.p!)));

    var dataBase64 = base64.encode(pem.encodedBytes);

    return """-----BEGIN PRIVATE KEY-----\r\n$dataBase64\r\n-----END PRIVATE KEY-----""";
  }
}
