import 'package:exye_app/Data/data_manager.dart';
import 'package:exye_app/Manager/app_manager.dart';
import 'package:exye_app/Overlay/overlay_manager.dart';
import 'package:exye_app/Pages/page_manager.dart';
import 'package:exye_app/Resources/resource_manager.dart';

class SystemManager {
  AppManager mApp = AppManager();
  DataManager mData = DataManager();
  PageManager mPage = PageManager();
  OverlayManager mOverlay = OverlayManager();
  ResourceManager mResource = ResourceManager();
}

SystemManager app = SystemManager();