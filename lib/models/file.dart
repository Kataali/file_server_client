class File {
  final int id;
  final String title;
  final String type;
  final String description;
  final String uploadedOn;
  final String path;

  File( 
      {required this.id,
      required this.path,
      required this.title,
      required this.type,
      required this.description,
      required this.uploadedOn});

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      id: json['id'],
        title: json['title'],
        type: json['type'],
        description: json['description'],
      uploadedOn: json['uploadedon'],
      path: json['file'],
    );
        
  }
}
