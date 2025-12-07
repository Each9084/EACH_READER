//这个类将扮演应用数据层的“图书馆馆长”角色
// 负责管理所有书籍、添加书籍、更新进度，并在数据发生变化时通知 UI 刷新。
import 'package:each_reader/core/models/book.dart';
import 'package:flutter/foundation.dart';

class Booklibraryservice extends ChangeNotifier{
  // 核心数据属性：一个存储所有书籍的列表
  final List<Book> _books = [];

  // Getter：提供给外界访问书籍列表的“只读”视图
  // 为什么要返回 List<Book> 而不是 _books 呢？
  // 答：这是面向对象“封装”原则的应用。外界只能读取，不能直接修改 _books 列表
  // 保证了数据的安全性，所有修改操作都必须通过 Service 内部的方法

  //这个列表不允许任何修改操作
  List<Book> get books => List.unmodifiable(_books);

  // --------------------------------------------------------------------------
  // 行为/方法 (Methods)
  // --------------------------------------------------------------------------

  void addBook(Book newBook){
    _books.add(newBook);

    // 关键步骤：通知所有正在使用 `books` 列表的 Widgets 进行刷新
    notifyListeners();
    
    print('Service: New book added: ${newBook.title}');
  }

  void updateBookProgress(String bookId,double newProgress){
    try{
      //查找对应的 Book 对象
      //firstWhere:在集合中查找并返回第一个满足你给定条件的元素。
      final bookToUpdate = _books.firstWhere((book)=>book.id == bookId);

      // 调用 Book 对象自己的方法来更新进度 (OO思想：让对象自己处理自己的数据)
      bookToUpdate.updateProgress(newProgress);

      //数据变化了，通知 UI 刷新
      notifyListeners();
      // 未来: 调用 CloudService 来同步进度
    }catch(e){
      print('Error updating progress: Book with ID $bookId not found.');
    }
  }

  /// 模拟加载一些测试书籍数据 (为了方便开发)
  void loadInitialBook(){
    //避免重复加载
    if(_books.isNotEmpty) return;

    _books.addAll([
      Book(
        id: '1',
        title: '设计模式：可复用面向对象软件的基础',
        author: 'Erich Gamma et al.',
        filePath: '/path/to/design_patterns.epub',
        readProgress: 0.25,
      ),
      Book(
        id: '2',
        title: '计算机程序的构造与解释',
        author: 'Gerald Jay Sussman',
        filePath: '/path/to/sicp.pdf',
        readProgress: 0.80,
      ),
    ]);

    notifyListeners();
    print('Service: Loaded initial test books.');


    // 未来可以添加 removeBook, searchBooks 等方法...
  }



}