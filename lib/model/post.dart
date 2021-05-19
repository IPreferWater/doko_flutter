
class Post {
  final int id;
  final String title;
  final String text;
  final double latitude;
  final double longitude;

  Post({this.id, this.title, this.text, this.latitude, this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'title': this.title,
      'text': this.text,
      'latitude': this.latitude,
      'longitude': this.longitude,
    };
  }

  factory Post.fromMap(int id, Map<String, dynamic> map) {
    return Post(
      id: id,
      title: map['title'],
      text: map['text'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

}