import 'package:each_reader/core/models/book.dart';
import 'package:flutter/material.dart';

class BookCoverCard extends StatelessWidget {
  const BookCoverCard({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    // 获取主题的文本样式
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        // TODO: 未来实现：点击打开阅读窗口
        print('Clicked book: ${book.title}');
      },
      // 整体使用 Card 或 Container 来提供卡片效果
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 封面图片区 (使用占位符模拟)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    // 优化：显示标题的前 5 个字符，如果标题为空，则显示 'no title'
                    book.title.isNotEmpty
                        ? book.title.substring(
                            0,
                            book.title.length < 5 ? book.title.length : 5,
                          )
                        : "no title",
                    textAlign: TextAlign.center,
                    // 允许两行显示
                    maxLines: 2,
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          // 书名
          Text(
            book.title,
            // 只显示一行书名
            maxLines: 1,
            // 溢出显示省略号
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
          ),

          // 2. 作者 (新增)
          if (book.author.isNotEmpty)
            Text(
              book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall!.copyWith(
                color: textTheme.bodySmall!.color!.withOpacity(0.7), // 灰色显示
              ),
            ),
          const SizedBox(height: 4),

          // 3. 阅读进度条 (单独优化)
          _ProgressIndicatorBar(book: book),

          // 最后阅读时间 (新增)
          if (book.lastReadAt != null)
            Text(
              // 使用简单的格式显示时间 (例如: 12-10 22:30)
              '上次: ${book.lastReadAt!.month.toString().padLeft(2, '0')}-${book.lastReadAt!.day.toString().padLeft(2, '0')} ${book.lastReadAt!.hour.toString().padLeft(2, '0')}:${book.lastReadAt!.minute.toString().padLeft(2, '0')}',
              style: textTheme.labelSmall!.copyWith(fontSize: 9),
            ),
        ],
      ),
    );
  }
}

//进度条
class _ProgressIndicatorBar extends StatelessWidget {
  final Book book;

  const _ProgressIndicatorBar({required this.book});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 美观化的进度条
          Expanded(
            child: ClipRRect(
              // 用于圆角处理
              borderRadius: BorderRadius.circular(5.0),
              child: LinearProgressIndicator(
                value: book.readProgress,
                minHeight: 6,
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withOpacity(0.1),
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(book.readProgress * 100).toStringAsFixed(0)}%',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
