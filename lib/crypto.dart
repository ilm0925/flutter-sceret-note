import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart'; // for the utf8.encode method

class Crypto {
  var _key;
  IV _iv = IV.fromLength(16);

  Crypto(
    String hash,
  ) {
    _key = Key.fromUtf8(hash);
  }
  String encryptBase64(String plainText) {
    final encrypter = Encrypter(AES(_key));
    return encrypter.encrypt(plainText, iv: _iv).base64.toString();
  }

  String decryptBase64(String encrypted) {
    final decrypter = Encrypter(AES(_key));
    return decrypter.decrypt64(encrypted, iv: _iv);
  }

  String encryptSHA256(String plainText) {
    List<int> bytes = utf8.encode(plainText);
    return sha256.convert(bytes).toString();
  }
}
