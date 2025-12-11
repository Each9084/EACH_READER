// Windows 主界面
import 'package:each_reader/core/services/BookLibraryService.dart';
import 'package:each_reader/core/services/localization_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/book_cover_card.dart';

class WindowsMainScreen extends StatelessWidget {
  const WindowsMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildSider(context),
          const Expanded(child: _MainContentArea()),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 侧边栏构建方法
  // --------------------------------------------------------------------------

  Widget _buildSider(BuildContext context) {
    final localizations = AppLocalizations(context);

    return Container(
      width: 250,
      color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              localizations.translate("appName"),
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          // 选项列表 (使用 ListTile 模拟导航项)
          _SidebarItem(
            icon: Icons.login,
            title: localizations.translate('login'),
          ),
          // 替换: '登录'
          _SidebarItem(
            icon: Icons.add_box,
            title: localizations.translate('addBook'),
          ),
          // 替换: '添加书籍'
          _SidebarItem(
            icon: Icons.menu_book,
            title: localizations.translate('allCategories'),
          ),
          // 替换: '全部分类'
          const Divider(),
          _SidebarItem(
            icon: Icons.settings,
            title: localizations.translate('settings'),
          ),
          // 替换: '设置'
          _SidebarItem(
            icon: Icons.info_outline,
            title: localizations.translate('about'),
          ),
          // 替换: '关于'
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SidebarItem({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: title == '全部分类', // 模拟选中状态
      onTap: () {
        // TODO: 未来实现导航逻辑
      },
    );
  }
}

class _MainContentArea extends StatelessWidget {
  const _MainContentArea();

  @override
  Widget build(BuildContext context) {
    // 核心：使用 Consumer 监听 BookLibraryService 的变化
    // Consumer 接收两个泛型：context 和 要监听的服务类型
    final localization = AppLocalizations(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: localization.translate("searchHint"),
              prefixIcon: const Icon(Icons.search),
              // 针对 Windows 风格优化边框
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ), // 书籍陈列核心区域
        const Expanded(child: _BookDisplayGrid()),
      ],
    );
  }
}

// --------------------------------------------------------------------------
// 书籍网格展示 (监听 BookLibraryService)
// --------------------------------------------------------------------------

class _BookDisplayGrid extends StatelessWidget {
  const _BookDisplayGrid();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations(context);

    // TODO: implement build
    return Consumer<Booklibraryservice>(
      builder: (context, libraryService, child) {
        final books = libraryService.books;

        if (books.isEmpty) {
          return Center(child: Text(localizations.translate("emptyShelf")));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: books.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            // 每本书最大宽度
            maxCrossAxisExtent: 200,
            // 调整封面比例 (高比宽大约 1.67)
            childAspectRatio: 0.6,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final book = books[index];
            // 稍后实现 BookCoverCard 来显示封面、书名和进度
            return BookCoverCard(book: book);
          },
        );
      },
    );
  }
}
