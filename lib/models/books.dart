class Books {
  final String id;
  final String title;
  final String writer;
  final String description;
  final String image;

  Books({
    required this.id,
    required this.title,
    required this.writer,
    required this.description,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'writer': writer,
      'description': description,
      'image': image,
    };
  }
}