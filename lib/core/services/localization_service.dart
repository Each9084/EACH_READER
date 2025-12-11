import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

// 继承 ChangeNotifier，以便在切换语言时通知 UI 刷新
class LocalizationService extends ChangeNotifier {
  Map<String, String> _localizedStrings = {};

  // 当前语言代码 (例如: 'zh_chs', 'en_gb')
  String _currentLocaleCode = "en_gb";

  String get currentLocaleCode => _currentLocaleCode;

  //默认支持的语言列表
  static const List<String> supportedLocales = ["zh_chs", "en_gb"];

  // --------------------------------------------------------------------------
  // 核心方法：加载 JSON 文件
  // --------------------------------------------------------------------------

  //Dart 需要向操作系统（Windows/Android）发出请求：“请给我这个 JSON 文件的内容。”
  //任何IO请求都建议由Future完成
  Future<void> load(String localeCode) async {
    // 构造 JSON 文件的路径
    final path = 'lib/i18n/$localeCode.json';
    try {
      // 从 assets 中加载文件内容 (Future<String>) rootBundle是访问应用打包资源（Assets）
      final jsonString = await rootBundle.loadString(path);

      // 将 JSON 字符串解码为 Map<String, dynamic>
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;

      // 将 Map 转换为 Map<String, String>，确保类型正确
      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });

      _currentLocaleCode = localeCode;

      // 通知所有监听者（UI）语言数据已更新
      notifyListeners();
      print('LocalizationService: Loaded $_currentLocaleCode translation.');
    } catch (e) {
      print('Error loading localization for $localeCode: $e');
      // 如果加载失败，可以尝试加载默认语言
      if (_currentLocaleCode != "en_gb") {
        await load("en_gb");
      }
    }
  }

  // --------------------------------------------------------------------------
  // 翻译方法：供 Widgets 调用
  // --------------------------------------------------------------------------

  /// 根据 key 获取对应的翻译文本
  String translate(String key) {
    //如果前面的表达式 (_localizedStrings[key]) 不为空（即找到了翻译文本），则返回该文本。
    //如果前面的表达式 为空（即在 JSON 文件中找不到这个 key），则返回 ?? 后面的值，也就是**key 本身**。
    //防止程序崩溃。如果找不到翻译文本，程序不会抛出错误，而是安全地继续运行。
    return _localizedStrings[key] ?? key;
  }

  // --------------------------------------------------------------------------
  // 扩展方法：最简洁的调用方式 (静态方法)
  // --------------------------------------------------------------------------
}

// 给 BuildContext 添加一个扩展，让我们可以像 context.translate('key') 一样调用
// 注意：这种方法是简化的，更严谨的是通过 provider 监听
class AppLocalizations{
  final BuildContext context;
  AppLocalizations(this.context);

  static LocalizationService of(BuildContext context){
    // 通过 Provider 获取 LocalizationService 实例
    return Provider.of<LocalizationService>(context,listen:false);
  }

  String translate(String key){
    return context.watch<LocalizationService>().translate(key);
  }

  // 静态方法，用于在非 Widget 地方获取翻译 (例如 Service 内部)
  static String getTranslation(BuildContext context,String key){
    return context.read<LocalizationService>().translate(key);
  }

}