import 'package:devshouse/models/user_profile.dart';

abstract class MyCoursesState{
  final UserProfile userProfile;

  MyCoursesState(this.userProfile);
}

class MyCoursesLoading  extends MyCoursesState {
  MyCoursesLoading(UserProfile userProfile) : super(userProfile);

}

class MyCoursesLoaded extends MyCoursesState {
  MyCoursesLoaded(UserProfile userProfile) : super(userProfile);

}