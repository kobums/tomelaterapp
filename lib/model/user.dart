import 'package:app/config/http.dart';


class User {
  int id;
  String email;
  String nickname;
  String socialtype;
  String socialid;
  String createdat;
  String updatedat;

  Map<String, dynamic> extra;

  User({
    this.id = 0,
    this.email = '',
    this.nickname = '',
    this.socialtype = '',
    this.socialid = '',
    this.createdat = '',
    this.updatedat = '',
    this.extra = const {},
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      socialtype: json['socialtype'] as String,
      socialid: json['socialid'] as String,
      createdat: json['createdat'] as String,
      updatedat: json['updatedat'] as String,
      extra: json['extra'] == null ? <String, dynamic>{} : json['extra'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'nickname': nickname,
    'socialtype': socialtype,
    'socialid': socialid,
    'createdat': createdat,
    'updatedat': updatedat,
  };

  User clone() {
    return User.fromJson(toJson());
  }
}

class UserManager {
  static const baseUrl = '/api/user';

  static Future<List<User>> find({
    int page = 0,
    int pagesize = 20,
    String? params,
  }) async {
    var result = await Http.get(baseUrl, {
      'page': page,
      'pagesize': pagesize,
    }, params);
    if (result == null || result['content'] == null) {
      return List<User>.empty(growable: true);
    }

    return result['content'].map<User>((json) => User.fromJson(json)).toList();
  }

  static Future<int> count({String? params}) async {
    var result = await Http.get('$baseUrl/count', {}, params);
    if (result == null || result['total'] == null) {
      return 0;
    }

    return int.parse(result['total']);
  }

  static Future<User> get(int id) async {
    var result = await Http.get('$baseUrl/$id');
    if (result == null || result['item'] == null) {
      return User();
    }

    return User.fromJson(result);
  }

  static Future<int> insert(User item) async {
    var result = await Http.insert(baseUrl, item.toJson());
    return result;
  }

  static update(User item) async {
    await Http.put(baseUrl, item.toJson());
  }

  static delete(User item) async {
    await Http.delete(baseUrl, item.toJson());
  }
}
