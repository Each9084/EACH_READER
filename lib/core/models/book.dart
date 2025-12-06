//核心 OOP 模型的完善
//创建Book类
//原则：封装数据和行为。

class Book {
  final String id;
  final String title;
  final String author;
  final String filePath; //本地文件路径

  double readProgress; //阅读进度 (0.0 到 1.0)
  DateTime? lastReadAt; // 最后阅读时间 (使用可空类型 DateTime?)

  //构造函数
  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.filePath,
    this.readProgress = 0.0,
    this.lastReadAt,
  });

  //方法 行为
  void updateProgress(double newProgress) {
    //确保进度在合理范围内
    if (newProgress >= 0.0 && newProgress <= 1.0) {
      readProgress = newProgress;
      lastReadAt = DateTime.now();
      //toStringAsFixed(x) x是保留的位数例如(3.1415926).toStringAsFixed(2) 就是3.14
      print(
        "Book: $title progress updated to ${(newProgress * 100).toStringAsFixed(0)}%",
        //未来:在这里调用 CloudService 或 LocalStorageService 来保存数据
      );
    }
  }

  //将 Book 对象转换为 JSON Map，方便存储到本地或云端
  Map<String,dynamic> toJson(){
    return{
      "id":id,
      "title":title,
      "author":author,
      "filePath":filePath,
      "readProgress":readProgress,
      "lastReadAt":lastReadAt?.toIso8601String(),// 转换为标准时间字符串
    };
}

// 3. 从 JSON Map 创建一个 Book 对象 (工厂构造函数 Factory Constructor)



}//最外侧
