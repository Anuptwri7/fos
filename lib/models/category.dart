class Category {
  int? count;
  Null? next;
  Null? previous;
  List<Results>? results;

  Category({this.count, this.next, this.previous, this.results});

  Category.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int? id;
  String? createdDateAd;
  String? createdDateBs;
  String? name;
  bool? active;
  int? createdBy;

  Results(
      {this.id,
        this.createdDateAd,
        this.createdDateBs,
        this.name,
        this.active,
        this.createdBy});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdDateAd = json['created_date_ad'];
    createdDateBs = json['created_date_bs'];
    name = json['name'];
    active = json['active'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_date_ad'] = this.createdDateAd;
    data['created_date_bs'] = this.createdDateBs;
    data['name'] = this.name;
    data['active'] = this.active;
    data['created_by'] = this.createdBy;
    return data;
  }
}