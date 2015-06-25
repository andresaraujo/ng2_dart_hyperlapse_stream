library app;

import 'package:angular2/angular2.dart';
import 'ig_stream.dart';
import 'ig_caption.dart';

@Component(selector: 'app')
@View(templateUrl: 'components/app.html', directives: const [NgFor, IGStream, IGCaption])
class App {
  List<Map> playlist = [];

  AppComponent() {
  }

  update(Map videoObj) {
    playlist.insert(0, videoObj);
  }
}
