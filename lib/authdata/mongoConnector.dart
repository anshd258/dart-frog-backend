import 'package:dart_backend/models/user.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoConnect {
  Db db;
  MongoConnect({required this.db});

  Future<WriteResult> createUser(User data) async {
    if (!db.isConnected) {
      await db.open();
    }
    var bost = db.isConnected;
    var coll = db.collection('user');
    var result = await coll.insertOne(data.toJson());
    return result;
  }

  Future<Map<String, dynamic>?> findOne(String email) async {
    var coll = db.collection('user');
    var result = await coll.findOne(where.eq("email", email));
    return result;
  }

  void deleteuser(String id) async {
    var coll = db.collection('user');
    await coll.deleteOne({"_id": id});
  }
}
