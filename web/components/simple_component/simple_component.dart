library simple_component;

import 'package:angular2/angular2.dart';

@Component(selector: 'simple-component')
@View(templateUrl: 'components/simple_component/simple_component.html')
class SimpleComponent {
  String name = 'AngularNG2';

  update(String value) {
    name = value;
  }
}
