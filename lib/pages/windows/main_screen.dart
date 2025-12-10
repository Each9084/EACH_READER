// Windows 主界面
import 'package:each_reader/core/services/BookLibraryService.dart';
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
    return Container(
      width: 250,
      color: Theme
          .of(context)
          .appBarTheme
          .backgroundColor ?? Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              "Each Reader",
              style: Theme
                  .of(
                context,
              )
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          // 选项列表 (使用 ListTile 模拟导航项)
          _SidebarItem(icon: Icons.login, title: '登录'),
          _SidebarItem(icon: Icons.add_box, title: '添加书籍'),
          _SidebarItem(icon: Icons.menu_book, title: '全部分类'),
          const Divider(),
          _SidebarItem(icon: Icons.settings, title: '设置'),
          _SidebarItem(icon: Icons.info_outline, title: '关于'),
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
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "搜索书籍...",
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
    // TODO: implement build
    return Consumer<Booklibraryservice>(
        builder: (context, libraryService, child) {
          final books = libraryService.books;

          if (books.isEmpty) {
            return const Center(child: Text('书架空空如也，请导入书籍。'),);
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
                  mainAxisSpacing: 16),
              itemBuilder: (context,index){
              final book = books[index];
              // 稍后实现 BookCoverCard 来显示封面、书名和进度
              return BookCoverCard(book: book);
              });
        }

    );
  }


}
