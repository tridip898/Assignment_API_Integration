//create model for API data
class ProductModel{
  final String CategoryName;
  final String UnitName;
  final String Name;
  final String BrandName;
  final String ModelName;
  final double oldPrice;
  final double price;

  ProductModel(this.CategoryName, this.UnitName, this.Name, this.BrandName,
      this.ModelName, this.oldPrice, this.price);
}