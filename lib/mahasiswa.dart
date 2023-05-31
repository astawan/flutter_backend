class Mahasiswa {
  final int id;
  final String nama;

  const Mahasiswa({
    required this.id,
    required this.nama,
  });

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    return Mahasiswa(
      id: json['id'],
      nama: json['nama'],
    );
  }
}
