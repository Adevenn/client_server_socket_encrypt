import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:encrypt/encrypt.dart' as e;
import 'package:pointycastle/export.dart';

class RSAEncryption {
  late RSAPrivateKey privateKey;
  late RSAPublicKey publicKey;
  late e.Encrypter encrypter;

  RSAEncryption() {
    _generateKeyPair();
  }

  RSAEncryption.fromClient(String pemPublic) {
    final keyParser = e.RSAKeyParser();
    final RSAAsymmetricKey rsaPublicKey = keyParser.parse(pemPublic);
    publicKey = RSAPublicKey(rsaPublicKey.modulus!, rsaPublicKey.exponent!);
    encrypter = e.Encrypter(e.RSA(publicKey: publicKey));
  }

  RSAEncryption.demo() {
    print('${DateTime.now()} : generating keys');
    _generateKeyPair();
    print('${DateTime.now()} : keys generation done');
    print(pemPublicKey());
    print(pemPrivateKey());

    ///File size is limited with RSA
    ///(Not really in fact, but RSA is very slow.
    ///=> Limited to small files for speed)
    final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
    print('Plain text : $plainText}');
    print('${DateTime.now()} : encrypting text ...');
    final encrypted = encrypt(plainText);
    print('${DateTime.now()} : encryption done.');
    print('Encrypted : $encrypted');
    print('${DateTime.now()} : decrypting text ...');
    final decrypted = decrypt(encrypted);
    print('${DateTime.now()} : decryption done.');
    print('Decrypted : $decrypted');
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
    var algorithmAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList(
        [0x6, 0x9, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0xd, 0x1, 0x1, 0x1]));
    var paramsAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
    var algorithmSeq = ASN1Sequence()
      ..add(algorithmAsn1Obj)
      ..add(paramsAsn1Obj);

    var publicKeySeq = ASN1Sequence()
      ..add(ASN1Integer(publicKey.modulus!))
      ..add(ASN1Integer(publicKey.exponent!));
    var publicKeySeqBitString =
        ASN1BitString(Uint8List.fromList(publicKeySeq.encodedBytes));

    var topLevelSeq = ASN1Sequence()
      ..add(algorithmSeq)
      ..add(publicKeySeqBitString);
    var dataBase64 = base64.encode(topLevelSeq.encodedBytes);

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
