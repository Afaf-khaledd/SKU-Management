class SKUModel {
  final String? id;
  final String? image;
  final String name;
  final bool isActive;
  final String skuCode;
  final Category category;
  final SubCategory subCategory;
  final String brand;

  SKUModel({
    this.id,
    this.image,
    this.isActive = true,
    required this.name,
    required this.skuCode,
    required this.category,
    required this.subCategory,
    required this.brand,
  });

  factory SKUModel.fromJson(Map<String, dynamic> json, String docId) {
    return SKUModel(
      id: docId,
      name: json['name'] ?? '',
      isActive: json['isActive'] is bool ? json['isActive'] as bool : true,
      image: json['image'] ?? '',
      skuCode: json['skuCode'] ?? '',
      category: Category.values.firstWhere(
            (e) => e.name == json['category'],
        orElse: () => Category.electronics,
      ),
      subCategory: SubCategory.values.firstWhere(
            (e) => e.name == json['subCategory'],
        orElse: () => SubCategory.phones,
      ),
      brand: json['brand'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isActive': isActive,
      'skuCode': skuCode,
      'category': category.name,
      'subCategory': subCategory.name,
      'brand': brand,
      'image': image ?? 'https://eyxkovzsyebbysipriyt.supabase.co/storage/v1/object/public/sku-images//istockphoto-1452662817-612x612.jpg',
    };
  }

  static List<SubCategory> getSubCategories(Category category) {
    switch (category) {
      case Category.electronics:
        return [
          SubCategory.phones,
          SubCategory.laptops,
          SubCategory.accessories,
          SubCategory.tvs,
          SubCategory.headphones,
        ];
      case Category.fashion:
        return [
          SubCategory.bags,
          SubCategory.shoes,
          SubCategory.clothing,
        ];
      case Category.food:
        return [
          SubCategory.fruits,
          SubCategory.vegetables,
          SubCategory.snacks,
        ];
      case Category.books:
        return [
          SubCategory.children,
          SubCategory.literature,
          SubCategory.novel,
        ];
      case Category.personal:
        return [
          SubCategory.makeup,
          SubCategory.skincare,
          SubCategory.haircare,
        ];
      case Category.furniture:
        return [
          SubCategory.chairs,
          SubCategory.tables,
          SubCategory.beds,
        ];
    }
  }
}
enum Category {
  electronics,
  fashion,
  food,
  books,
  personal,
  furniture,
}

enum SubCategory {
  phones,
  laptops,
  accessories,
  tvs,
  headphones,

  // fashion
  bags,
  shoes,
  clothing,

  // Food
  fruits,
  vegetables,
  snacks,

  // Books
  children,
  literature,
  novel,

  // skincare
  makeup,
  skincare,
  haircare,

  // Furniture
  chairs,
  tables,
  beds,
}