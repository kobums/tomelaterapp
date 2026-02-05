import 'package:app/config/http.dart';


enum AnswerIspublic {
  none(0, ''),
  private(1, '비공개'),
  public(2, '공개'),
;

  const AnswerIspublic(this.code, this.label);

  final int code;
  final String label;

  @override
  String toString() => label;

  static AnswerIspublic fromCode(int code) {
    return AnswerIspublic.values.firstWhere((e) => e.code == code, orElse: () => AnswerIspublic.none);
  }
}

class Answer {
  int id;
  int uid;
  int qid;
  String content;
  AnswerIspublic ispublic;
  String createdat;
  String updatedat;

  Map<String, dynamic> extra;

  Answer({
    this.id = 0,
    this.uid = 0,
    this.qid = 0,
    this.content = '',
    this.ispublic = AnswerIspublic.none,
    this.createdat = '',
    this.updatedat = '',
    this.extra = const {},
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'] as int,
      uid: json['uid'] as int,
      qid: json['qid'] as int,
      content: json['content'] as String,
      ispublic: AnswerIspublic.fromCode(json['ispublic'] as int),
      createdat: json['createdat'] as String,
      updatedat: json['updatedat'] as String,
      extra: json['extra'] == null ? <String, dynamic>{} : json['extra'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'uid': uid,
    'qid': qid,
    'content': content,
    'ispublic': ispublic.code,
    'createdat': createdat,
    'updatedat': updatedat,
  };

  Answer clone() {
    return Answer.fromJson(toJson());
  }
}

class AnswerManager {
  static const baseUrl = '/api/answer';

  static Future<List<Answer>> find({
    int page = 0,
    int pagesize = 20,
    String? params,
  }) async {
    var result = await Http.get(baseUrl, {
      'page': page,
      'pagesize': pagesize,
    }, params);
    if (result == null || result['content'] == null) {
      return List<Answer>.empty(growable: true);
    }

    return result['content'].map<Answer>((json) => Answer.fromJson(json)).toList();
  }

  static Future<int> count({String? params}) async {
    var result = await Http.get('$baseUrl/count', {}, params);
    if (result == null || result['total'] == null) {
      return 0;
    }

    return int.parse(result['total']);
  }

  static Future<Answer> get(int id) async {
    var result = await Http.get('$baseUrl/$id');
    if (result == null || result['item'] == null) {
      return Answer();
    }

    return Answer.fromJson(result);
  }

  static Future<int> insert(Answer item) async {
    var result = await Http.insert(baseUrl, item.toJson());
    return result;
  }

  static update(Answer item) async {
    await Http.put(baseUrl, item.toJson());
  }

  static delete(Answer item) async {
    await Http.delete(baseUrl, item.toJson());
  }
}
