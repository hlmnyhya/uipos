class Product {
  final String nama;
  final String deskripsi;
  final double harga;
  final int stok;
  final String gambar;

  Product({
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.stok,
    required this.gambar,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      harga: json['harga'].toDouble(),
      stok: json['stok'],
      gambar: json['gambar'],
    );
  }
}
