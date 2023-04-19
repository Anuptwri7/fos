import 'dart:convert';

getTableList getTableListFromJson(String str) =>
    getTableList.fromJson(json.decode(str));

class getTableList {
  int? count;
  Null? next;
  Null? previous;
  List<Results>? results;

  getTableList({this.count, this.next, this.previous, this.results});

  getTableList.fromJson(Map<String, dynamic> json) {
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
  int? capacity;
  int? noOfAttendant;
  int? status;
  bool? active;
  int? createdBy;

  Results(
      {this.id,
        this.createdDateAd,
        this.createdDateBs,
        this.name,
        this.capacity,
        this.noOfAttendant,
        this.status,
        this.active,
        this.createdBy});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdDateAd = json['createdDateAd'];
    createdDateBs = json['createdDateBs'];
    name = json['name'];
    capacity = json['capacity'];
    noOfAttendant = json['noOfAttendant'];
    status = json['status'];
    active = json['active'];
    createdBy = json['createdBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdDateAd'] = this.createdDateAd;
    data['createdDateBs'] = this.createdDateBs;
    data['name'] = this.name;
    data['capacity'] = this.capacity;
    data['noOfAttendant'] = this.noOfAttendant;
    data['status'] = this.status;
    data['active'] = this.active;
    data['createdBy'] = this.createdBy;
    return data;
  }
}