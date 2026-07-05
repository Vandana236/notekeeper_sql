class NoteModel {

  int? _id;
  String? _title;
  String? _description;
  String? _date;
  int? _priority;
  int? _isSynced;

  /// Constructor
  NoteModel(
      this._title,
      this._date,
      this._priority,
      [
        this._description,
      ]
      );

  /// Constructor with ID
  NoteModel.withId(
      this._id,
      this._title,
      this._date,
      this._priority,
      [
        this._description,
      ]
      );

  /// GETTERS

  int? get id => _id;

  String? get title => _title;

  String? get description => _description;

  String? get date => _date;

  int? get priority => _priority;
  int? get isSynced => _isSynced;
  /// SETTERS
  set isSynced(int? value) {
    _isSynced = value;
  }
  set title(String? newTitle) {

    if (newTitle != null &&
        newTitle.length <= 255) {

      _title = newTitle;
    }
  }

  set description(String? newDescription) {

    if (newDescription != null &&
        newDescription.length <= 255) {

      _description = newDescription;
    }
  }

  set priority(int? newPriority) {

    if (newPriority != null &&
        newPriority >= 1 &&
        newPriority <= 2) {

      _priority = newPriority;
    }
  }

  set date(String? newDate) {

    _date = newDate;
  }

  /// Convert Object to Map
  Map<String, dynamic> toMap() {

    var map = <String, dynamic>{};

    if (_id != null) {
      map['id'] = _id;
    }

    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['isSynced'] = _isSynced;
    map['date'] = _date;

    return map;
  }

  /// Convert Map to Object
  NoteModel.fromMapObject(
      Map<String, dynamic> map,
      ) {

    _id = map['id'];
    _title = map['title'];
    _description = map['description'];
    _priority = map['priority'];
    _isSynced = map['isSynced'];
    _date = map['date'];
  }
}