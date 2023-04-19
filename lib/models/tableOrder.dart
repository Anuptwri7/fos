class TableOrder {
  int? count;
  Null? next;
  Null? previous;
  List<TableResults>? results;

  TableOrder({this.count, this.next, this.previous, this.results});

  TableOrder.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <TableResults>[];
      json['results'].forEach((v) {
        results!.add(new TableResults.fromJson(v));
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

class TableResults {
  int? id;
  String? createdByUserName;
  String? foodCategoryName;
  String? foodSubCategoryName;
  Food? food;
  String? createdDateAd;
  String? createdDateBs;
  String? qty;
  String? grossAmount;
  bool? cancelled;
  String? remarks;
  int? createdBy;
  int? order;


  TableResults(
      {this.id,
        this.createdByUserName,
        this.foodCategoryName,
        this.foodSubCategoryName,
        this.food,
        this.createdDateAd,
        this.createdDateBs,
        this.qty,
        this.grossAmount,
        this.cancelled,
        this.remarks,
        this.createdBy,
        this.order});

  TableResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdByUserName = json['created_by_user_name'];
    foodCategoryName = json['food_category_name'];
    foodSubCategoryName = json['food_sub_category_name'];
    food = json['food'] != null ? new Food.fromJson(json['food']) : null;
    createdDateAd = json['created_date_ad'];
    createdDateBs = json['created_date_bs'];
    qty = json['qty'];
    grossAmount = json['gross_amount'];
    cancelled = json['cancelled'];
    remarks = json['remarks'];
    createdBy = json['created_by'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by_user_name'] = this.createdByUserName;
    data['food_category_name'] = this.foodCategoryName;
    data['food_sub_category_name'] = this.foodSubCategoryName;
    if (this.food != null) {
      data['food'] = this.food!.toJson();
    }
    data['created_date_ad'] = this.createdDateAd;
    data['created_date_bs'] = this.createdDateBs;
    data['qty'] = this.qty;
    data['gross_amount'] = this.grossAmount;
    data['cancelled'] = this.cancelled;
    data['remarks'] = this.remarks;
    data['created_by'] = this.createdBy;
    data['order'] = this.order;
    return data;
  }
}

class Food {
  int? id;
  String? name;
  int? category;
  int? subCategory;
  String? unitName;

  Food({this.id, this.name, this.category, this.subCategory,this.unitName});

  Food.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    subCategory = json['sub_category'];
    unitName = json['unit_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category'] = this.category;
    data['sub_category'] = this.subCategory;
    data['unit_name'] = this.unitName;
    return data;
  }
}