import 'package:meta/meta.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/services/api_path.dart';
import 'package:time_tracker/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  Future<void> createJob(Job job) => FirestoreService.instance.setData(
    path: APIPath.job(uid, documentIdFromCurrentDate()),
    data: job.toMap(),
  );

  Stream<List<Job>> jobsStream() => FirestoreService.instance.collectionStream(
    path: APIPath.jobs(uid),
    builder: (data) => Job.fromMap(data),
  );
}