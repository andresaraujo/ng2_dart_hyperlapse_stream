library app;

import 'package:angular2/angular2.dart';
import '../simple_component/simple_component.dart' show SimpleComponent;

@Component(
    selector: 'app'
)
@Template(
    url: 'components/app/app.html',
    directives: const [SimpleComponent]
)
class AppComponent {
}