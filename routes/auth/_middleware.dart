import 'package:dart_backend/authdata/mongoConnector.dart';
import 'package:dart_backend/authdata/userAuthJWT.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

Handler middleware(Handler handler) {
  return (context) async {
    final db = await Db.create(
        "mongodb+srv://ansh258:anshd2001@cluster0.meherfg.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");

    if (!db.isConnected) {
      await db.open();
    }

    final response = handler
        .use(
          provider(
            (_) => MongoConnect(db: db),
          ),
        )
        .use(provider(
          (context) => TokenCreatorVerifier(),
        ))
        .call(context);

    await db.close();
    return response;
  };
}
