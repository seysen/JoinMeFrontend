class Event {
  int id;
  String name;
  int creatorID;
  String description;
  String linkAva;

    Event({this.id, this.name, this.creatorID, this.description, this.linkAva});

  factory Event.fromJson(Map<String, dynamic> responseData) {
    return Event(
      id: responseData['id'] as int,
      name: responseData['name'] as String,
      creatorID: responseData['creator_id'] as int,
      description: responseData['description'] as String,
      linkAva: responseData['link_ava'] as String,
    );
  }
}