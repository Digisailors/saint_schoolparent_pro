// ignore_for_file: non_constant_identifier_names

class Area {
  String area_code;
  String area_name;
  String? parent_area;

  Area({
    required this.area_code,
    required this.area_name,
    this.parent_area,
  });
}
