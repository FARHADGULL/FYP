// ignore_for_file: library_private_types_in_public_api

class ApiEndPoints {
  static const String baseUrl = 'http://restapi.adequateshop.com/api/';
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String registerEmail = 'authaccount/registration';
  final String loginEmail = 'authaccount/login';
}
