class QuoteModel {
  QuoteModel({
    required this.q,
    required this.a,
    required this.h,
  });
  late final String q;
  late final String a;
  late final String h;

  QuoteModel.fromJson(Map<String, dynamic> json){
    q = json['q'];
    a = json['a'];
    h = json['h'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['q'] = q;
    _data['a'] = a;
    _data['h'] = h;
    return _data;
  }
}