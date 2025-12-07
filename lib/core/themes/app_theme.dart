//主题配置的抽象类或基类
//Flutter 的主题基于 ThemeData 类。需要为每种主题创建一个 ThemeData 实例。
import 'package:flutter/material.dart';

enum ThemeType{
  light,
  dark,
  frosted,// 毛玻璃模式 (需要背景透明和 BackdropFilter)
  liquidGlass// 液态玻璃 (进阶效果，暂时配置为深色变体)
}

class AppTheme{
  static ThemeData getThemeData(ThemeType type){
    switch(type){
      case ThemeType.light:
        return ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF5F5F7),// 接近 Apple 的浅灰
          ),
          // ... 其他白天配置
        );

      case ThemeType.dark:
        return ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1C1C1E), // 接近 Apple 的深灰
          ),
          //... 其他夜晚配置
        );

      case ThemeType.frosted:
        return getThemeData(ThemeType.light).copyWith(
          // 例如，毛玻璃模式可以有略微不同的 primaryColor
          primaryColor: Colors.grey.shade200,
        );

      case ThemeType.liquidGlass:
        return getThemeData(ThemeType.dark).copyWith(
          // 例如，液态玻璃模式可以有更深的背景色
          scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        );
    }
  }
}