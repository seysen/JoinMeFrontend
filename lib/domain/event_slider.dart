class EventSlider {
  int id;
  String name;
  String description;
  String date;
  String ava;
  int users;
  int likes;

  EventSlider(
      {this.id,
      this.name,
      this.description,
      this.date,
      this.ava,
      this.users,
      this.likes});

  factory EventSlider.fromJson(Map<String, dynamic> responseData) {
    return EventSlider(
        id: responseData['id'] as int,
        name: responseData['name'] as String,
        description: responseData['description'] as String,
        date: responseData['date'] as String,
        ava: responseData['link_ava'] as String,
        users: responseData['users'] as int,
        likes: responseData['likeEvents'] as int);
  }
}
