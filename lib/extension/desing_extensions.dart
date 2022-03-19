import 'package:flutter/material.dart';

extension NumberToEspaces on double {
  SizedBox get spaceV => SizedBox(height: this,);
  SizedBox get spaceH => SizedBox(width: this,);
}