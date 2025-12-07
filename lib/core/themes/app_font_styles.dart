//主题结构中预留好字体的选择和应用机制。

// 定义可供用户选择的字体
// 注意：如果使用自定义字体，需要将字体文件放入 assets/fonts 目录
// 并在 pubspec.yaml 中声明

enum AppFont{
  system,
  serif,// 衬线体
  sansSerif,// 无衬线体
  // ... 未来添加的自定义字体:
}

String getFontFamily(AppFont font){
  switch(font){
    case AppFont.system:
      return "";// 使用空字符串或 null 默认使用系统字体
    case AppFont.serif:
      return 'RobotoSerif'; //  假设导入了
    case AppFont.sansSerif:
      return 'NotoSansSC';//  假设导入了
  }

  // 3. 在 ThemeService 中引入字体选择
// (这一步我们在下一步整合到 ThemeService 中)
}