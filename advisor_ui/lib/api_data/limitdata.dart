class categorydata {
  final String month;
  final String category_name;
  final double category_limit;
  final double category_total;
  final double limit_diff;
  final String budget_status;
  final double percent;


  categorydata({required this.month, required this.category_limit, required this.category_total,required this.category_name, required this.budget_status, required this.limit_diff, required this.percent});

  factory categorydata.fromJson(Map<String, dynamic> json) {
    return categorydata(
      month: json['Month'],
      category_name: json['category_name'],
      category_limit: json['category_limit'],
      category_total: json['expenses_total'],
      limit_diff: json['limit_diff'],
      budget_status: json['budget_status'],
      percent: json['limit_exceeded_percent'],
      
  
    );
  }
}
// // "Month": "July",
//     "overall_limit": 20000.0,
//     "expenses_total": 18170.0,
//     "limit_diff": -1830.0,
//     "limit_exceeded_percent": 9.15,
//     "budget_status": "Under the budget"

class overalldata {
  final String month;
  final double overall_limit;
  final double overall_total;
  final double limit_diff;
   final double percent;
  final String budget_status;
 
  overalldata({required this.month, required this.overall_limit, required this.overall_total, required this.budget_status, required this.limit_diff, required this.percent});

  factory overalldata.fromJson(Map<String, dynamic> json) {
    return overalldata(
      month: json['Month'],
      overall_limit: json['overall_limit'],
      overall_total: json['expenses_total'],
      limit_diff: json['limit_diff'],
       percent: json['limit_exceeded_percent'],
      budget_status: json['budget_status'],
     
      
  
    );
  }
}

class categorylimit {
  final int cat_id;
  final int user_id;
  final int? category_id;
  final String category_name;
  final double category_limit;


  categorylimit({required this.cat_id, required this.category_limit, required this.category_name,required this.user_id, required this.category_id });

  factory categorylimit.fromJson(Map<String, dynamic> json) {
    return categorylimit(
      cat_id: json['id'],
      user_id: json['user'],
      category_id: json['expenses_category'],
      category_name: json['exCategory_name'],
      category_limit: json['category_limit'], 
    );
  }
}

class overalllimit {
  final int cat_id;
  final int user_id;
  final double overall_limit;


  overalllimit({required this.cat_id, required this.user_id, required this.overall_limit });

  factory overalllimit.fromJson(Map<String, dynamic> json) {
    return overalllimit(
      cat_id: json['id'],
      user_id: json['user'],
      overall_limit: json['overall_limit'], 
    );
  }
}
