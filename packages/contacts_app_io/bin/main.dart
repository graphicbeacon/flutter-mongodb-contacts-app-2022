import 'dart:io';

import 'package:contacts_app_io/contacts_app_io.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> arguments) async {
  // Connect and load collection
  final db = await Db.create('mongodb://admin:pass2022@localhost:27018/admin');
  await db.open();
  final coll = db.collection('contacts');
  print('Database opened');

  // Create server
  const port = 8081;
  final app = Router();

  // Create routes
  app.mount('/contacts/', ContactsRestApi(coll).router);

  app.mount('/contacts-ws/', ContactsSocketApi(coll).router);

  // Listen for incoming connections
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(handleCors())
      .addHandler(app);

  withHotreload(() => serve(handler, InternetAddress.anyIPv4, port));
}
