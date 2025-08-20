class DeliveryPart{
  int id;
  String name;
//Constructor with initializing formal parameters
  DeliveryPart(this.id, this.name);
  int get deliveryPartID => id;
  String get deliveryPartName => name;
  @override
  String toString() {
    return '$id: $name';


  }
}