import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devshouse/models/course.dart';

import '../models/user_profile.dart';

class CoursesRepository {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<Course>> streamByUserId(String userId) {
    return _firestore
        .collection('users/$userId/courses')
        .snapshots()
        .map((event) {
      return event.docs.map((doc) {
        return Course.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Stream<UserProfile> streamUserProfile(String userId) {
    return _firestore
        .doc('users/$userId')
        .snapshots()
        .map((event) => UserProfile.fromJson(event.data() ?? {}, event.id));
  }
}
