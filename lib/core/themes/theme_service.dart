// 主题切换和状态管理服务

// 使用 ChangeNotifier 来管理当前主题，并提供切换主题的方法。

import 'package:each_reader/core/themes/app_font_styles.dart';
import 'package:each_reader/core/themes/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  ThemeType _currentThemeType = ThemeType.light;
  AppFont _currentFont = AppFont.system; // 新增：默认字体

  //为外部世界提供了一个“安全、只读”的通道，来获取服务内部的私有数据。
  ThemeType get currentThemeType => _currentThemeType;

  //切换主题
  void setTheme(ThemeType newTheme) {
    if (newTheme != _currentThemeType) {
      _currentThemeType = newTheme;
      // 通知所有监听者（即 MaterialApp）主题已经变化
      notifyListeners();
    }
  }

  //切换字体
  AppFont get currentFont => _currentFont;

  void setFont(AppFont newFont) {
    if (_currentFont != newFont) {
      _currentFont = newFont;
      notifyListeners();
      // 注意：更改字体后，可能需要更新 currentThemeData
      // 确保 MaterialApp 刷新字体
    }
  }

  // 优化：当字体改变时，需要让 MaterialApp 重新构建
  // 我们可以创建一个新的 getter 来获取带有字体信息的 ThemeData
  ThemeData get themeWithFont {
    ThemeData baseTheme = AppTheme.getThemeData(_currentThemeType);
    String fontFamily = getFontFamily(_currentFont);

    if(fontFamily.isNotEmpty){
      // 1. 创建一个新的 ThemeData 副本
      // 2. 使用 applyFontFamily 方法，对基础主题中的所有文本样式应用新的字体家族
      return baseTheme.copyWith(textTheme: baseTheme.textTheme.apply(fontFamily: fontFamily),
        // 也可以同时修改 primaryTextTheme(负责在应用主题色背景上的文本外观)
        primaryTextTheme: baseTheme.primaryTextTheme.apply(fontFamily: fontFamily),
      );
    }
    return baseTheme;// 可以在这里配置阅读器专用的 TextTheme)
    }

// 未来: 可以添加从本地存储加载主题设置的方法 (例如 SharedPreferences)
}