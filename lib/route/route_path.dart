
import 'package:my_background_tool/ui/advanced_setting.dart';
import 'package:my_background_tool/ui/background_change_page.dart';
import 'package:my_background_tool/ui/card_change.dart';
import 'package:my_background_tool/ui/path_choose.dart';

const pathChoosePage = '/path';
const chooseBackground = '/background';
const advancedSetting = '/setting';
const cardChange = '/card';
var routePath = {
  pathChoosePage: (context) => PathChoose(),
  advancedSetting: (context) => AdvancedSetting(),
  cardChange: (context) => CardChangePage(),
  chooseBackground: (context) => BackgroundChangePage()
};