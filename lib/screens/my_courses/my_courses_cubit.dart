import 'dart:async';
import 'package:devshouse/data/courses_repository.dart';
import 'package:devshouse/models/user_profile.dart';
import 'package:devshouse/screens/my_courses/my_courses_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyCoursesCubit extends Cubit<MyCoursesState> {

  MyCoursesCubit() : super(MyCoursesLoaded(UserProfile(id: '1',email: 'jomazao@')));

  final CoursesRepository _coursesRepository = CoursesRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late StreamSubscription _profileSubscription;

  void connectStream() {
    final userId = _auth.currentUser?.uid  ?? '1';
    _profileSubscription = _coursesRepository.streamUserProfile(userId).listen((userProfile) async{
        emit(MyCoursesLoading(state.userProfile));
        await Future.delayed(const Duration(seconds: 3));
        emit(MyCoursesLoaded(userProfile));
    });

  }

  @override
  Future<void> close() async {
    await _profileSubscription.cancel();
    return super.close();
  }





}