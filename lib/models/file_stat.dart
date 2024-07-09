class FileStat {
  final String title;
  final String type;
  final String description;
  final String uploadedOn;
  final int downloadCount;
  final int emailCount;

  FileStat(
      {required this.title,
      required this.type,
      required this.description,
      required this.uploadedOn,
      required this.downloadCount,
      required this.emailCount});

  factory FileStat.fromJson(Map<String, dynamic> json) {
    return FileStat(
      title: json['title'],
      type: json['type'],
      description: json['description'],
      uploadedOn: json["uploaded_on"],
      downloadCount: json['download_count'],
      emailCount: json['email_count'],
    );
  }
}
