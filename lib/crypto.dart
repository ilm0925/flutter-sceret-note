import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart'; // for the utf8.encode method

class Crypto {
  var key;
  var iv;

  Crypto(String hash, int ivLength) {
    key = Key.fromUtf8(hash.substring(16));
    iv = IV.fromLength(ivLength);
  }
  String encryptBase64(String plainText) {
    final encrypter = Encrypter(AES(key));
    return encrypter.encrypt(plainText, iv: iv).base64.toString();
  }

  String decryptBase64(String encrypted) {
    final decrypter = Encrypter(AES(key));
    return decrypter.decrypt64(encrypted, iv: iv);
  }

  String encryptSHA256(String plainText) {
    List<int> bytes = utf8.encode(plainText);
    return sha256.convert(bytes).toString();
  }
}
