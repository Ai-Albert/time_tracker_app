import 'package:meta/meta.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/services/api_path.dart';
import 'package:time_tracker/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);
  Stream<List<Job>> jobsStream();
}

// So we can have a unique document id generated every time we generate a new job
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  // Using job.id instead of documentIdFromCurrentDate so we can set existing jobs and not just new ones
  @override
  Future<void> setJob(Job job) => FirestoreService.instance.setData(
    path: APIPath.job(uid, job.id),
    data: job.toMap(),
  );

  @override
  Future<void> deleteJob(Job job) async => FirestoreService.instance.deleteData(
    path: APIPath.job(uid, job.id),
  );

  @override
  Stream<List<Job>> jobsStream() => FirestoreService.instance.collectionStream(
    path: APIPath.jobs(uid),
    builder: (data, documentId) => Job.fromMap(data, documentId),
  );
}