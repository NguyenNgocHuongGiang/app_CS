class MetaData {
  String level;
  int totalTime;
  List<String> overview;
  List<String> willLearn;
  String layout;

  MetaData({
    required this.level,
    required this.totalTime,
    required this.overview,
    required this.willLearn,
    required this.layout,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      level: json['level'],
      totalTime: json['totalTime'],
      overview: List<String>.from(json['overview'] ?? []),
      willLearn: List<String>.from(json['willLearn'] ?? []),
      layout: json['layout'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'totalTime': totalTime,
      'overview': overview,
      'willLearn': willLearn,
      'layout': layout,
    };
  }
}

class Course {
  int id;
  String tenKhoaHoc;
  String biDanh;
  String hinhAnh;
  String moTa;
  List<int> danhSachChuongHoc;
  double price;
  List<int> danhSachPhuongThucThanhToan;
  bool isOnline;
  bool isPublic;
  String donViTienTe;
  MetaData metaData;
  List<String> maSkill;
  String maPhanLoai;

  Course({
    required this.id,
    required this.tenKhoaHoc,
    required this.biDanh,
    required this.hinhAnh,
    required this.moTa,
    required this.danhSachChuongHoc,
    required this.price,
    required this.danhSachPhuongThucThanhToan,
    required this.isOnline,
    required this.isPublic,
    required this.donViTienTe,
    required this.metaData,
    required this.maSkill,
    required this.maPhanLoai,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      tenKhoaHoc: json['tenKhoaHoc'],
      biDanh: json['biDanh'],
      hinhAnh: json['hinhAnh'],
      moTa: json['moTa'],
      danhSachChuongHoc: List<int>.from(json['danhSachChuongHoc']),
      price: json['price'],
      danhSachPhuongThucThanhToan:
          List<int>.from(json['danhSachPhuongThucThanhToan']),
      isOnline: json['isOnline'],
      isPublic: json['isPublic'],
      donViTienTe: json['donViTienTe'],
      metaData: MetaData.fromJson(json['metaData']),
      maSkill: List<String>.from(json['maSkill']),
      maPhanLoai: json['maPhanLoai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenKhoaHoc': tenKhoaHoc,
      'biDanh': biDanh,
      'hinhAnh': hinhAnh,
      'moTa': moTa,
      'danhSachChuongHoc': danhSachChuongHoc,
      'price': price,
      'danhSachPhuongThucThanhToan': danhSachPhuongThucThanhToan,
      'isOnline': isOnline,
      'isPublic': isPublic,
      'donViTienTe': donViTienTe,
      'metaData': metaData.toJson(),
      'maSkill': maSkill,
      'maPhanLoai': maPhanLoai,
    };
  }
}

class ListSkillCourse {
  String tieuDe;
  String id;
  List<Course> danhSachKhoaHoc;

  ListSkillCourse({
    required this.tieuDe,
    required this.id,
    required this.danhSachKhoaHoc,
  });

  factory ListSkillCourse.fromJson(Map<String, dynamic> json) {
    return ListSkillCourse(
      tieuDe: json['tieuDe'],
      id: json['id'],
      danhSachKhoaHoc: List<Course>.from(
          json['danhSachKhoaHoc'].map((x) => Course.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tieuDe': tieuDe,
      'id': id,
      'danhSachKhoaHoc': danhSachKhoaHoc.map((x) => x.toJson()).toList(),
    };
  }
}


// hien o trang chu
class KhoaHoc {
  final int id;
  final String tenKhoaHoc;
  final String biDanh;
  final String hinhAnh;
  final String moTa;
  final List<int> danhSachChuongHoc;
  final double price;
  final List<int> danhSachPhuongThucThanhToan;
  final bool isOnline;
  final bool isPublic;
  final String donViTienTe;
  final Map<String, dynamic> metaData;

  KhoaHoc({
    required this.id,
    required this.tenKhoaHoc,
    required this.biDanh,
    required this.hinhAnh,
    required this.moTa,
    required this.danhSachChuongHoc,
    required this.price,
    required this.danhSachPhuongThucThanhToan,
    required this.isOnline,
    required this.isPublic,
    required this.donViTienTe,
    required this.metaData,
  });

  factory KhoaHoc.fromJson(Map<String, dynamic> json) {
    return KhoaHoc(
      id: json['id'],
      tenKhoaHoc: json['tenKhoaHoc'],
      biDanh: json['biDanh'],
      hinhAnh: json['hinhAnh'],
      moTa: json['moTa'],
      danhSachChuongHoc: List<int>.from(json['danhSachChuongHoc']),
      price: json['price'],
      danhSachPhuongThucThanhToan: List<int>.from(json['danhSachPhuongThucThanhToan']),
      isOnline: json['isOnline'],
      isPublic: json['isPublic'],
      donViTienTe: json['donViTienTe'],
      metaData: json['metaData'],
    );
  }
}