class FoodListings {
  int? count;
  Null? next;
  Null? previous;
  List<FoodResults>? results;

  FoodListings({this.count, this.next, this.previous, this.results});

  FoodListings.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <FoodResults>[];
      json['results'].forEach((v) {
        results!.add(new FoodResults.fromJson(v));
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

class FoodResults {
  int? id;
  String? name;
  String? unitName;

  FoodResults({this.id, this.name,this.unitName});

  FoodResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    unitName = json['unit_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['unit_name'] = this.unitName;
    return data;
  }
}