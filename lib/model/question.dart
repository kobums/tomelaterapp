import 'package:app/config/http.dart';


class Question {
  int id;
  String content;
  int month;
  int day;
  String createdat;
  String updatedat;

  Map<String, dynamic> extra;

  Question({
    this.id = 0,
    this.content = '',
    this.month = 0,
    this.day = 0,
    this.createdat = '',
    this.updatedat = '',
    this.extra = const {},
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      content: json['content'] as String,
      month: json['month'] as int,
      day: json['day'] as int,
      createdat: json['createdat'] as String,
      updatedat: json['updatedat'] as String,
      extra: json['extra'] == null ? <String, dynamic>{} : json['extra'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'month': month,
    'day': day,
    'createdat': createdat,
    'updatedat': updatedat,
  };

  Question clone() {
    return Question.fromJson(toJson());
  }
}

class QuestionManager {
  static const baseUrl = '/api/question';

  static Future<List<Question>> find({
    int page = 0,
    int pagesize = 20,
    String? params,
  }) async {
    var result = await Http.get(baseUrl, {
      'page': page,
      'pagesize': pagesize,
    }, params);
    if (result == null || result['content'] == null) {
      return List<Question>.empty(growable: true);
    }

    return result['content'].map<Question>((json) => Question.fromJson(json)).toList();
  }

  static Future<int> count({String? params}) async {
    var result = await Http.get('$baseUrl/count', {}, params);
    if (result == null || result['total'] == null) {
      return 0;
    }

    return int.parse(result['total']);
  }

  static Future<Question> get(int id) async {
    var result = await Http.get('$baseUrl/$id');
    if (result == null || result['item'] == null) {
      return Question();
    }

    return Question.fromJson(result);
  }

  static Future<int> insert(Question item) async {
    var result = await Http.insert(baseUrl, item.toJson());
    return result;
  }

  static update(Question item) async {
    await Http.put(baseUrl, item.toJson());
  }

  static delete(Question item) async {
    await Http.delete(baseUrl, item.toJson());
  }
}
