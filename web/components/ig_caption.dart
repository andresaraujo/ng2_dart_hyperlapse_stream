library igcaption;

import 'package:angular2/angular2.dart';

@Component(
  selector: "ig-caption",
  properties: const ["avatar", "caption"]
)
@View(
  template: """
<div class="card-panel grey lighten-5 z-depth-1">
  <div class="row valign-wrapper">
    <div class="col s2">
      <img [src]="avatar" alt="" class="circle responsive-img">
    </div>
    <div class="col s10">
      <span class="black-text">
        {{ caption }}
      </span>
    </div>
  </div>
</div>
  """
)
class IGCaption {
  String caption;
  String avatar;
}