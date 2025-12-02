import 'package:flutter/widgets.dart';

double rh(BuildContext context, double percent) =>
    MediaQuery.of(context).size.height * percent;

double rw(BuildContext context, double percent) =>
    MediaQuery.of(context).size.width * percent;
