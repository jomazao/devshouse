import 'package:devshouse/config/text_styles.dart';
import 'package:devshouse/custom_widgets/loading_widget.dart';
import 'package:devshouse/data/courses_repository.dart';
import 'package:devshouse/extension/desing_extensions.dart';
import 'package:devshouse/models/course.dart';
import 'package:devshouse/screens/my_courses/my_courses_cubit.dart';
import 'package:devshouse/screens/my_courses/my_courses_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '1';
    final cubit = MyCoursesCubit()..connectStream();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<MyCoursesCubit, MyCoursesState>(
              bloc: cubit,
              builder: (ctx, state) {
                switch (state.runtimeType) {
                  case MyCoursesLoading:
                    return const CircularProgressIndicator();
                  case MyCoursesLoaded:
                    final userProfile = state.userProfile;
                    return Text(
                      '${userProfile.id} - ${userProfile.email}',
                      style: kTitleTextStyle,
                    );
                  default:
                    return const Text('estado sin filtro');
                }
              },
            ),
            50.0.spaceV,
            Expanded(
              child: StreamBuilder<List<Course>>(
                stream: CoursesRepository().streamByUserId(userId),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState != ConnectionState.waiting) {
                    final courses = snapshot.data ?? [];
                    if (courses.isEmpty) {
                      return const Text(
                        'Aún no tienes cursos',
                        style: kBasicTextStyle,
                      );
                    }
                    return ListView(
                        children: courses
                            .map((e) => Text(
                                  e.name,
                                  style: kBasicTextStyle,
                                ))
                            .toList());
                  } else {
                    return const LoadingWidget();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
