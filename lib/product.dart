class Product{
  int id;
  String name;
  String launchedAt;
  String launchSite;
  String popularity;
  Product([this.id, this.name, this.launchedAt, this.launchSite, this.popularity]);

  Map<String, dynamic> toMap()
  {
    var map = <String, dynamic>{'id':id, 'name':name,
      'launchedAt':launchedAt, 'popularity':popularity,
      'launchSite': launchSite };
    return map;
  }

  Product.fromMap(Map<String, dynamic> map)
  {
    id = map['id'];
    name = map['name'];
    launchedAt = map['launchedAt'];
    launchSite = map['launchSite'];
    popularity = map['popularity'];
  }

}