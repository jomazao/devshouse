import 'package:devshouse/config/text_styles.dart';
import 'package:devshouse/custom_widgets/loading_widget.dart';
import 'package:devshouse/data/courses_repository.dart';
import 'package:devshouse/extension/desing_extensions.dart';
import 'package:devshouse/models/course.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_profile.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '1';
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder<UserProfile>(
              stream: CoursesRepository().streamUserProfile(userId),
              builder: (ctx, snapshot) {
                print('---------------');
                final userProfile = snapshot.hasData ? snapshot.data! : UserProfile(id: '!"#&#"&/!"', email: 'cargando@email.com')    ;
                return Text('${userProfile.id} - ${userProfile.email}',style: kTitleTextStyle,);
              },
            ),
            50.0.spaceV,
            Expanded(
              child: StreamBuilder<List<Course>>(
                stream: CoursesRepository().streamByUserId(userId),
                builder: (ctx, snapshot) {
                  print('******************');
                  if (snapshot.connectionState != ConnectionState.waiting) {
                    final courses = snapshot.data ?? [];

                    if (courses.isEmpty) {
                      return const Text('Aún no tienes cursos',  style: kBasicTextStyle,);
                    }
                    return ListView(
                        children: courses.map((e) => Text(e.name , style: kBasicTextStyle,)).toList());
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
