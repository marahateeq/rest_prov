class HttpExp implements Exception {
  final String message;
  HttpExp(this.message);

  @override
  String toString() {
    return message;
  }
}
