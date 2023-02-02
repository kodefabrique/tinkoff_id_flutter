///Object that stores tokens, [idToken] and [expiresIn] time
class TokenPayload {
  final String accessToken;
  final int expiresIn;
  final String? idToken;
  final String refreshToken;

  TokenPayload({
    required this.accessToken,
    required this.expiresIn,
    this.idToken,
    required this.refreshToken,
  });

  factory TokenPayload.fromJson(Map<String, dynamic> map) {
    return TokenPayload(
      accessToken: map['accessToken'] as String,
      expiresIn: map['expiresIn'] as int,
      idToken: map['idToken'] as String,
      refreshToken: map['refreshToken'] as String,
    );
  }
}
