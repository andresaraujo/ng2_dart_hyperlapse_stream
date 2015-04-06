library app;

import 'package:angular2/angular2.dart';
import '../../services/todo_store.dart' show Store, Todo, TodoFactory;
import '../simple_component/simple_component.dart' show SimpleComponent;

@Component(selector: 'app', services: const [Store, TodoFactory])
@Template(
    url: 'components/app/app.html', directives: const [SimpleComponent, For])
class AppComponent {
  Store todoStore;
  Todo todoEdit = null;
  TodoFactory todoFactory;

  AppComponent(this.todoStore, this.todoFactory);

  enterTodo(event, inputElement) {
    if (event.which == 13) {
      this.addTodo(inputElement.value);
      event.target.value = "";
    }
  }

  editTodo(Todo todo) {
    this.todoEdit = todo;
  }

  doneEditing(event, Todo todo) {
    var which = event.which;
    var target = event.target;
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
