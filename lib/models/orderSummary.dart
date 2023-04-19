class OrderSummary {
  int? id;
  List<OrderDetails>? orderDetails;
  String? createdByUserName;
  String? statusDisplay;
  String? tableName;
  String? createdDateAd;
  String? createdDateBs;
  int? status;
  String? orderNo;
  String? grandTotal;
  String? remarks;
  bool? active;
  int? createdBy;
  int? table;

  OrderSummary(
      {this.id,
        this.orderDetails,
        this.createdByUserName,
        this.statusDisplay,
        this.tableName,
        this.createdDateAd,
        this.createdDateBs,
        this.status,
        this.orderNo,
        this.grandTotal,
        this.remarks,
        this.active,
        this.createdBy,
        this.table});

  OrderSummary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['order_details'] != null) {
      orderDetails = <OrderDetails>[];
      json['order_details'].forEach((v) {
        orderDetails!.add(new OrderDetails.fromJson(v));
      });
    }
    createdByUserName = json['created_by_user_name'];
    statusDisplay = json['status_display'];
    tableName = json['table_name'];
    createdDateAd = json['created_date_ad'];
    createdDateBs = json['created_date_bs'];
    status = json['status'];
    orderNo = json['order_no'];
    grandTotal = json['grand_total'];
    remarks = json['remarks'];
    active = json['active'];
    createdBy = json['created_by'];
    table = json['table'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.orderDetails != null) {
      data['order_details'] =
          this.orderDetails!.map((v) => v.toJson()).toList();
    }
    data['created_by_user_name'] = this.createdByUserName;
    data['status_display'] = this.statusDisplay;
    data['table_name'] = this.tableName;
    data['created_date_ad'] = this.createdDateAd;
    data['created_date_bs'] = this.createdDateBs;
    data['status'] = this.status;
    data['order_no'] = this.orderNo;
    data['grand_total'] = this.grandTotal;
    data['remarks'] = this.remarks;
    data['active'] = this.active;
    data['created_by'] = this.createdBy;
    data['table'] = this.table;
    return data;
  }
}

class OrderDetails {
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

  OrderDetails(
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

  OrderDetails.fromJson(Map<String, dynamic> json) {
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

  Food({this.id, this.name, this.category, this.subCategory});

  Food.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    subCategory = json['sub_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category'] = this.category;
    data['sub_category'] = this.subCategory;
    return data;
  }
}