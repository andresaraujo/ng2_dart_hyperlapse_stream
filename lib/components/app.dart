library app;

import 'package:angular2/angular2.dart' show Component, NgFor;
import 'package:json_object/json_object.dart' show JsonObject;
import 'ig_stream.dart' show IGStream;
import 'ig_caption.dart' show IGCaption;

@Component(
    selector: 'app',
    templateUrl: 'package:ng2_hyperlapse_stream/components/app.html',
    directives: const [NgFor, IGStream, IGCaption])
class App {
  List<JsonObject> playlist = [];

  AppComponent() {}

  update(Map videoObj) {
    playlist.insert(0, new JsonObject.fromMap(videoObj));
  }
}
