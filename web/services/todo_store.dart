library todo_store;

class KeyModel {
  int key;
  KeyModel(this.key);
}

class Todo extends KeyModel {
  String title;
  bool completed;

  Todo(int key, this.title, this.completed) : super(key);
}

class TodoFactory {
  num uid = 1;

  nextUid() {
    this.uid = this.uid + 1;
  }

  create(String title, bool complete) {
    return new Todo(nextUid(), title, complete);
  }
}

class Store {
  List<KeyModel> list = [new Todo(0, "zero", false)];

  add(KeyModel record) {
    list.add(record);
  }

  remove(KeyModel record) {
    list.remove(record);
  }

  removeBy(Function callback) {
    list.removeWhere(callback);
  }
}
