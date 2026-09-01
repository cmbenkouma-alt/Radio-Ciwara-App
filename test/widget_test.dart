import 'package:flutter_test/flutter_test.dart';
import 'package:radio_ciwara_app/main.dart';

void main(){testWidgets('Radio Ciwara app starts',(tester) async {await tester.pumpWidget(const RadioCiwaraApp());expect(find.text('RADIO CIWARA'),findsWidgets);});}
