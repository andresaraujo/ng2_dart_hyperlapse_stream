library app;

import 'package:angular2/angular2.dart';
import '../../services/todo_store.dart' show Store, Todo, TodoFactory;
import 'dart:html';

@Component(selector: 'app', injectables: const [Store, TodoFactory])
@View(templateUrl: 'components/app/app.html', directives: const [For])
class AppComponent {
  Store todoStore;
  Todo todoEdit = null;
  TodoFactory todoFactory;

  AppComponent(this.todoStore, this.todoFactory);

  enterTodo(KeyboardEvent event, NgElement ngElement) {
    InputElement input = (ngElement as InputElement);
    if (event.which == 13) {
      this.addTodo(input.value);
      input.value = "";
    }
  }

  editTodo(Todo todo) {
    this.todoEdit = todo;
  }

  doneEditing(KeyboardEvent event, Todo todo) {
    var which = event.which;
    InputElement target = event.currentTarget;
    if (which == 13) {
      todo.title = target.value;
      //todoStore.save(todo);
      todoEdit = null;
    } else if (which == 27) {
      todoEdit = null;
      target.value = todo.title;
    }
  }

  addTodo(String title) {
    todoStore.add(todoFactory.create(title, false));
  }

  completeMe(Todo todo) {
    todo.completed = !todo.completed;
  }

  deleteMe(Todo todo) {
    todoStore.remove(todo);
  }

  toggleAll(event) {
    var isComplete = event.target.checked;

    todoStore.list.forEach((Todo todo) {
      todo.completed = isComplete;
      //todoStore.save(todo);
    });
  }

  clearCompleted() {
    todoStore.removeBy((Todo todo) => todo.completed);
  }
}
