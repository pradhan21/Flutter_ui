class BudgetCategory {
  final String name;
  final String icon;
  
  BudgetCategory({required this.name, required this.icon});
}

List<Map<String, dynamic>> categories = [
  {"name": "Auto", "icon": "assets/images/auto.png"},
  {"name": "Bank", "icon": "assets/images/bank.png"},
  {"name": "Cash", "icon": "assets/images/cash.png"},
  {"name": "Charity", "icon": "assets/images/charity.png"},
  {"name": "Eating", "icon": "assets/images/eating.png"},
  {"name": "Gift", "icon": "assets/images/gift.png"},
];
