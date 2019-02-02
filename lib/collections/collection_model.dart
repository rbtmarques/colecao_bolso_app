class Collection {
  int _id;
  String _name;
  bool _isFav;
  int _itemCount;

  Collection(this._id, this._name, this._isFav, this._itemCount);

  Collection.fromMap(dynamic data) {
    this._id = data["id"];
    this._name = data["name"];
    this._isFav = data["isFav"];
    this._itemCount = data["itemCount"];
  }

  int get id => _id;
  setId(int id) => this._id = id;

  String get name => _name;
  bool get isFav => _isFav;
  int get itemCount => _itemCount;
}
