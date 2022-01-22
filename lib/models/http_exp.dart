class HttpExp implements Exception {
  final String msg;
  HttpExp(this.msg);

  @override
  String toString() {
    return msg;
  }
}
