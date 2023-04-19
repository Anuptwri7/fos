class SubCategory {
  int? count;
  Null? next;
  Null? previous;
  List<SubCategoryResults>? results;

  SubCategory({this.count, this.next, this.previous, this.results});

  SubCategory.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <SubCategoryResults>[];
      json['results'].forEach((v) {
        results!.add(new SubCategoryResults.fromJson(v));
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

class SubCategoryResults {
  int? id;
  String? name;

  SubCategoryResults({this.id, this.name});

  SubCategoryResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}