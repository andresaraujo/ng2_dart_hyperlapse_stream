library app;

import 'package:angular2/angular2.dart';
import 'package:json_object/json_object.dart';
import 'ig_stream.dart';
import 'ig_caption.dart';

@Component(selector: 'app')
@View(
    templateUrl: 'package:ng2_playground/components/app.html',
    directives: const [NgFor, IGStream, IGCaption])
class App {
  List<JsonObject> playlist = [];

  AppComponent() {}

  update(Map videoObj) {
    playlist.insert(0, new JsonObject.fromMap(videoObj));
  }
}
