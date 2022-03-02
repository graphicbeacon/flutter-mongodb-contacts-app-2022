import 'dart:convert';
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ContactsRestApi {
  ContactsRestApi(this.store);

  DbCollection store;

  Handler get router {
    final app = Router();

    app.get('/', (Request req) async {
      final contacts = await store.find().toList();
      return Response.ok(
        json.encode({'contacts': contacts}),
        headers: {
          'Content-Type': ContentType.json.mimeType,
        },
      );
    });

    app.post('/', (Request req) async {
      final payload = await req.readAsString();
      final data = json.decode(payload);

      await store.insert(data);
      final addedEntry = await store.findOne(where.eq('name', data['name']));

      return Response(
        HttpStatus.created,
        body: json.encode(addedEntry),
        headers: {
          'Content-Type': ContentType.json.mimeType,
        },
      );
    });

    app.delete('/<id|.+>', (Request req, String id) async {
      await store.deleteOne(where.eq('_id', ObjectId.fromHexString(id)));
      return Response.ok('Deleted $id');
    });

    return app;
  }
}
