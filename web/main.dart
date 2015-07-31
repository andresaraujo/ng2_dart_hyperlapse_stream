// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular2/bootstrap.dart';
import 'package:angular2/di.dart';
import 'package:angular2/http.dart';
import 'package:angular2/router.dart';

// These imports will go away soon:
import 'package:angular2/src/reflection/reflection.dart' show reflector;
import 'package:angular2/src/reflection/reflection_capabilities.dart'
    show ReflectionCapabilities;

import 'package:ng2_playground/components/app.dart' show App;

void main() {
  // Temporarily needed.
  reflector.reflectionCapabilities = new ReflectionCapabilities();

  bootstrap(App, [jsonpInjectables, routerInjectables ]);
}