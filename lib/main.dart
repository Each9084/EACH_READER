import 'dart:io';

import 'package:each_reader/core/services/BookLibraryService.dart';
import 'package:each_reader/core/services/localization_service.dart';
import 'package:each_reader/core/themes/theme_service.dart';
import 'package:each_reader/pages/windows/main_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  runApp(const EachReaderApp());
  // 确保 Flutter 绑定初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 仅在桌面平台进行设置
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    // 定义窗口配置
    WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(1000, 650), // 最小宽度 1000, 最小高度 650
      center: true,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    // 应用配置
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  runApp(const EachReaderApp());
}

class EachReaderApp extends StatelessWidget {
  const EachReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 1. 注入书籍管理服务
        ChangeNotifierProvider(
          create: (context) {
            //create是必须的,这样才能通过ChangeNotifierProvider管理实例的的生命周期
            final service = Booklibraryservice();
            service.loadInitialBook(); // 在服务创建时加载一些测试数据
            return service;
          },
        ),
        // 2. 注入主题管理服务 我们不需要其他参数所以采用"_"
        ChangeNotifierProvider(create: (_) => ThemeService()),
        // 3. 注入多语言服务
        ChangeNotifierProvider(
          create: (_) {
            final service = LocalizationService();
            service.load("en_gb");
            return service;
          },
        ),
      ],
      //使用 Consumer<ThemeService> 的目的是为了监听 (Listen) ThemeService 的变化
      child:
          //themeService继承自 ChangeNotifier，当用户点击“白天模式”或“夜晚模式”时，它内部会调用 notifyListeners()
          // Consumer<ThemeService> 的作用就像一个“收音机”，它专门收听来自 ThemeService 的广播。
          //一旦收到广播（即 notifyListeners() 被调用），Consumer 就会执行它的 builder 方法，重新构建其内部的 Widget。
          Consumer<ThemeService>(
            //FutureBuilder 监听的异步任务
            builder: (context, themeService, child) {
              return FutureBuilder(
                future: context.read<LocalizationService>().load("zh_chs"),

                builder: (context, snapshot) {
                  //snapshot 包含异步任务的当前状态和结果
                  if (snapshot.connectionState == ConnectionState.done) {
                    return MaterialApp(
                      title: "Each Reader",
                      debugShowCheckedModeBanner: false,
                      // 使用 themeService 提供的当前主题和字体配置
                      theme: themeService.themeWithFont,
                      home: _PlatformEntryPoint(), // 跳转到平台入口判断
                    );
                  }else{
                    // 语言加载中，显示加载指示器
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            },
          ),
    );
  }
}

// 平台入口判断
class _PlatformEntryPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Web 平台假设使用 Windows 风格布局
      return WindowsMainScreen();
    } else if (Platform.isWindows) {
      return WindowsMainScreen();
    } else if (Platform.isAndroid) {
      return WindowsMainScreen(); //AndroidMainScreen();
    } else {
      return Scaffold(body: Center(child: Text("Unsupported Platform")));
    }
  }
}
