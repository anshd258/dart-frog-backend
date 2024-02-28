import 'package:dart_backend/models/user.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class TokenCreatorVerifier {
  String secrate = "powerPuff";

  String generateToken(Map<String, dynamic> data) {
    final jwt = JWT(
      data,
    );
    return jwt.sign(
      SecretKey(secrate),
      expiresIn: Duration(days: 1),
    );
  }

  User? verifyToken(String token) {
    try {
      final payload = JWT.verify(
        token,
        SecretKey(secrate),
      );

      final payloadData = payload.payload as Map<String, dynamic>;

      
      return User.fromJson(payloadData);
    } catch (e) {
      return null;
    }
  }
}
