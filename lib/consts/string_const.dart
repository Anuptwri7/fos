  class StringConst {
    /*HomePage*/
      // static String name = " SOORI";
      static String name = " FOS";
      static String account = "";


    /*Network */
    // static String mainUrl = 'https://api-fos.poojanpradhan.com.np/';
    // static String protocol = 'http://';
    static String mainUrl = 'http://192.168.101.10:8081/';
    static String login = 'api/v1/user-app/login';
    static String getTableList = 'api/v1/core-app/table';
    static String getCategoryList = 'api/v1/food-app/category';
    static String getSubCategoryList = 'api/v1/food-app/sub-category-list?category=';
    static String foodList = 'api/v1/order-app/food-list';
    static String placeOrder = 'api/v1/order-app/order-master';
    static String orderSummary = 'api/v1/order-app/order-master-summary/';
    static String tableOrder = 'api/v1/order-app/order-detail?cancelled=false&active=true&table=';
    static String cancelDetail = 'api/v1/order-app/cancel-order-detail/';
    static String updateOrder = 'api/v1/order-app/update-order/';
    static String completeOrder = 'api/v1/order-app/complete-order/';
    static String cancelOrder = 'api/v1/order-app/cancel-order-master/';

  }
