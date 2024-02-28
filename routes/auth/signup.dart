import 'dart:io';

import 'package:dart_backend/authdata/mongoConnector.dart';
import 'package:dart_backend/authdata/userAuthJWT.dart';
import 'package:dart_backend/models/user.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.post => _onPost(context),
    HttpMethod.get => _onGet(context),
    _ => Future.value(
        Response.json(
            statusCode: HttpStatus.methodNotAllowed, body: {'bad': 'sad'}),
      ),
  };
}

Future<Response> _onGet(RequestContext context) async {
  final header = context.request.headers;
  var result =
      context.read<TokenCreatorVerifier>().verifyToken(header['token']!);
  if (result != null) {
    return Response.json(
        statusCode: HttpStatus.ok,
        body: {'status': 'accepted', 'data': result.toJson()});
  } else {
    return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {'status': 'unverified', 'token': header['token']});
  }
}

Future<Response> _onPost(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final mongo = context.read<MongoConnect>();

  final result = await mongo.createUser(User.fromJson(body));
  if (result.isSuccess) {
    final jwt = context.read<TokenCreatorVerifier>();
    final token = jwt.generateToken(result.document!);
    return Response.json(
        statusCode: HttpStatus.accepted, body: {'token': token});
  } else {
    return Response.json(
        statusCode: HttpStatus.badRequest, body: {'data': 'bad request'});
  }
}
