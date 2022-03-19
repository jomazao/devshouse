class Course {

  final String id;
  final String name;
  final double progress;

  Course({required this.name, required this.progress,required this.id});

  factory Course.fromMap(Map json, String id) => Course(name: json['name'], progress: double.parse('${json['progress']}'), id: id);

}