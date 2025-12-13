//管理启动流程相关的状态。
import 'package:flutter/foundation.dart';

enum ServerRegion{
 international,
  mainlandChina
}

enum AuthStatus{
  loading,
  loggedOut,// 随便看看 / 游客
  loggedIn// 已登录
}


class AppStateService extends ChangeNotifier{

  //服务器选择状态
  ServerRegion ? _selectedRegion;
  ServerRegion ? get selectedRegion => _selectedRegion;

  // 授权状态
  AuthStatus _authStatus = AuthStatus.loggedOut;// 默认为游客模式
  AuthStatus get authStatus => _authStatus;

  //设置服务器地区
  void setRegion(ServerRegion region){
    if(_selectedRegion != region){
      _selectedRegion = region;
      // 🚨 TODO: 未来在这里初始化对应的 CloudService (国际/国内)
      print('App State: Server region set to $_selectedRegion');
      notifyListeners();
    }
  }

  /// 模拟登录/退出
  void setAuthStatus(AuthStatus status){
    _authStatus = status;
    //TODO 未来实现
    print("App State: Auth status set to $_authStatus");
    notifyListeners();
  }

// 可以在这里添加一些初始化的检查，例如检查本地是否有已选择的服务器地区


}