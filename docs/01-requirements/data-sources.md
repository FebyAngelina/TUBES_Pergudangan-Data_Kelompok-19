# Data Source Inventory - Biro Akademik Umum ITERA

## 1. Sistem Persuratan (SIMASTER/E-Office)

**Deskripsi:** Aplikasi web untuk mengelola surat masuk dan keluar institusi

**Detail Teknis:**
- Platform: Diasumsikan berbasis web dengan database SQL Server
- Database: SIMASTER_DB
- Tabel utama: 
  - tbl_surat_masuk
  - tbl_surat_keluar
  - tbl_disposisi
  - tbl_tracking_surat

**Data Available:**
- Periode: Januari 2021 - Present (4 tahun data)
- Volume estimasi: ~18,000 surat (rata-rata 400 surat/bulan)
- Update frequency: Real-time (setiap ada surat baru)
- Growth rate: 400-450 surat/bulan

**Struktur Data (tbl_surat_masuk):**
| Kolom                 | Tipe Data    | Contoh                    |
|-----------------------|--------------|---------------------------|
| id_surat              | VARCHAR(30)  | SRT/IN/2024/001           |
| nomor_surat           | VARCHAR(50)  | 123/UN31/AK/2024          |
| tanggal_surat         | DATE         | 2024-10-15                |
| tanggal_diterima      | DATE         | 2024-10-16                |
| jenis_surat_id        | INT          | 1                         |
| perihal               | TEXT         | Undangan Rapat Koordinasi |
| pengirim_eksternal    | VARCHAR(200) | Kemendikbud               |
| unit_tujuan_id        | INT          | 5 (Fakultas Sains)        |
| tingkat_prioritas     | VARCHAR(20)  | Sedang                    |
| status_id             | INT          | 3 (Selesai)               |
| pic_penerima_id       | INT          | 12345                     |
| file_attachment       | VARCHAR(255) | /uploads/2024/file.pdf    |
| keterangan            | TEXT         | Disposisi ke Dekan        |
| created_date          | DATETIME     | 2024-10-15 08:30:00       |
| updated_date          | DATETIME     | 2024-10-16 14:20:00       |

**Struktur Data (tbl_surat_keluar):**
| Kolom                 | Tipe Data    | Contoh                    |
|-----------------------|--------------|---------------------------|
| id_surat              | VARCHAR(30)  | SRT/OUT/2024/050          |
| nomor_surat           | VARCHAR(50)  | 050/UN31.2/AK/2024        |
| tanggal_surat         | DATE         | 2024-10-20                |
| jenis_surat_id        | INT          | 2                         |
| perihal               | TEXT         | Pemberitahuan Jadwal      |
| unit_pengirim_id      | INT          | 10 (Biro Akademik)        |
| tujuan_eksternal      | VARCHAR(200) | Semua Fakultas            |
| tingkat_prioritas     | VARCHAR(20)  | Tinggi                    |
| status_id             | INT          | 2 (Dalam Proses)          |
| pic_pembuat_id        | INT          | 12350                     |
| waktu_proses_mulai    | DATETIME     | 2024-10-18 09:00:00       |
| waktu_proses_selesai  | DATETIME     | 2024-10-20 11:00:00       |
| file_attachment       | VARCHAR(255) | /uploads/2024/file2.pdf   |
| created_date          | DATETIME     | 2024-10-18 09:00:00       |

**Data Quality:**
- Completeness: 93%
- Known issues: 
  - 7% surat tidak ada unit_tujuan (untuk surat umum)
  - Duplikasi nomor surat ~1% (human error)
  - File attachment kadang broken link (5%)

**Akses:**
- Method: Database export atau API (untuk tugas: generate synthetic data)
- Contact: Tim IT ITERA / Asumsi struktur standar

---

## 2. Database Inventaris Aset

**Deskripsi:** Database untuk tracking aset dan barang inventaris kantor

**Detail Teknis:**
- Platform: Excel/Google Sheets (belum ada sistem terintegrasi)
- Location: Shared Drive - /BiroAkademik/DataAset2024.xlsx
- Maintained by: Staff Umum

**Data Available:**
- Periode: 2018 - Present
- Volume estimasi: ~1,200 aset items
- Update frequency: Monthly (update kondisi & lokasi)
- Growth rate: 30-50 aset baru/tahun (pengadaan)

**Struktur Data:**
| Kolom                    | Tipe Data     | Contoh                    |
|--------------------------|---------------|---------------------------|
| kode_aset                | VARCHAR(30)   | AST-2024-FUR-001          |
| nama_aset                | VARCHAR(200)  | Meja Kerja Kayu Jati      |
| kategori_id              | INT           | 1 (Furnitur)              |
| merk                     | VARCHAR(100)  | Olympic                   |
| spesifikasi              | TEXT          | 120x60x75cm, Kayu Jati    |
| tahun_pengadaan          | INT           | 2022                      |
| tanggal_pengadaan        | DATE          | 2022-03-15                |
| nilai_perolehan          | DECIMAL(15,2) | 2500000.00                |
| kondisi_id               | INT           | 1 (Baik)                  |
| lokasi_id                | INT           | 5 (Gedung Rektorat Lt.2)  |
| ruangan                  | VARCHAR(100)  | R.201 - Biro Akademik     |
| pic_pengelola_id         | INT           | 12348                     |
| status_kepemilikan       | VARCHAR(50)   | Milik ITERA               |
| tanggal_terakhir_maintenance | DATE      | 2024-09-20                |
| keterangan               | TEXT          | Kondisi baik, rutin dipelihara |

**Tabel Relasi: tbl_maintenance_history**
| Kolom                    | Tipe Data     | Contoh                    |
|--------------------------|---------------|---------------------------|
| id_maintenance           | INT           | 1                         |
| kode_aset                | VARCHAR(30)   | AST-2024-FUR-001          |
| tanggal_maintenance      | DATE          | 2024-09-20                |
| jenis_maintenance        | VARCHAR(50)   | Perbaikan                 |
| deskripsi                | TEXT          | Perbaikan kaki meja       |
| biaya                    | DECIMAL(12,2) | 150000.00                 |
| teknisi                  | VARCHAR(100)  | Pak Budi                  |
| kondisi_sebelum_id       | INT           | 2 (Rusak Ringan)          |
| kondisi_sesudah_id       | INT           | 1 (Baik)                  |

**Data Quality:**
- Completeness: 88%
- Known issues:
  - 12% aset tidak ada tanggal maintenance terakhir
  - Kategori tidak standar (ada "PC", "Komputer", "Computer")
  - Nilai perolehan lama (pre-2020) banyak yang NULL
  - Lokasi kadang tidak update saat aset dipindah

**Akses:**
- Method: Manual export to CSV
- Contact: Staff Umum (Bu Siti)

---

## 3. Log Permintaan Layanan

**Deskripsi:** Sistem ticketing untuk permintaan layanan dari civitas akademika

**Detail Teknis:**
- Platform: Google Forms → Google Sheets (simple system)
- Alternative: Diasumsikan ada database sederhana
- Sheet: "Permintaan Layanan 2024"

**Data Available:**
- Periode: Januari 2023 - Present (2 tahun)
- Volume estimasi: ~3,000 permintaan
- Update frequency: Real-time (setiap ada submission)
- Growth rate: 120-150 permintaan/bulan

**Struktur Data:**
| Kolom                    | Tipe Data     | Contoh                         |
|--------------------------|---------------|--------------------------------|
| id_permintaan            | VARCHAR(30)   | REQ-2024-10-001                |
| timestamp_submit         | DATETIME      | 2024-10-15 10:30:00            |
| nama_pemohon             | VARCHAR(100)  | Dr. Ahmad Fauzi                |
| email_pemohon            | VARCHAR(100)  | ahmad.fauzi@itera.ac.id        |
| unit_pemohon_id          | INT           | 5 (Fakultas Sains)             |
| jabatan                  | VARCHAR(100)  | Dosen                          |
| jenis_layanan_id         | INT           | 1 (Peminjaman Ruangan)         |
| detail_permintaan        | TEXT          | Peminjaman Aula untuk seminar  |
| tanggal_dibutuhkan       | DATE          | 2024-10-20                     |
| waktu_mulai              | TIME          | 09:00                          |
| waktu_selesai            | TIME          | 12:00                          |
| jumlah_peserta           | INT           | 100                            |
| prioritas                | VARCHAR(20)   | Sedang                         |
| status_id                | INT           | 3 (Selesai)                    |
| pic_handler_id           | INT           | 12349                          |
| tanggal_respon           | DATETIME      | 2024-10-15 14:00:00            |
| tanggal_selesai          | DATETIME      | 2024-10-20 13:00:00            |
| catatan_admin            | TEXT          | Disetujui, koordinasi dengan cleaning service |
| rating_kepuasan          | INT           | 5                              |
| feedback                 | TEXT          | Pelayanan cepat dan responsif  |

**Jenis Layanan:**
- Peminjaman ruangan/aula
- Perbaikan fasilitas
- Permintaan surat keterangan
- Legalisir dokumen
- Pengadaan ATK
- Lainnya

**Data Quality:**
- Completeness: 95%
- Known issues:
  - Email format kadang salah (typo)
  - Rating kepuasan hanya 60% yang diisi
  - Jenis layanan kadang input manual (tidak pilih dropdown)

**Akses:**
- Method: Google Sheets API atau Export CSV
- Contact: Admin layanan

---

## 4. Database Kepegawaian (SIMPEG)

**Deskripsi:** Master data pegawai ITERA (untuk dimension pegawai)

**Detail Teknis:**
- Platform: MySQL 8.0 (sistem kepegawaian)
- Host: Internal server
- Database: SIMPEG

**Data Available:**
- Volume: ~600 pegawai (dosen + tendik)
- Update frequency: Monthly (untuk mutasi/promosi)
- Static data kecuali ada perubahan jabatan

**Struktur Data (vw_pegawai_aktif - view only):**
| Kolom                 | Tipe Data    | Contoh                    |
|-----------------------|--------------|---------------------------|
| nip                   | VARCHAR(20)  | 198501012010011001        |
| nidn                  | VARCHAR(20)  | 0101018501 (untuk dosen)  |
| nama_lengkap          | VARCHAR(150) | Dr. Ahmad Fauzi, M.Sc     |
| gelar_depan           | VARCHAR(50)  | Dr.                       |
| gelar_belakang        | VARCHAR(50)  | M.Sc                      |
| unit_kerja_id         | INT          | 5 (Fakultas Sains)        |
| jabatan_id            | INT          | 10 (Dosen)                |
| jabatan_fungsional    | VARCHAR(100) | Lektor                    |
| status_kepegawaian    | VARCHAR(50)  | ASN                       |
| email                 | VARCHAR(100) | ahmad.fauzi@itera.ac.id   |
| telepon               | VARCHAR(20)  | 081234567890              |
| status_aktif          | BIT          | 1                         |

**Data Quality:**
- Completeness: 99%
- Well-maintained oleh Biro Kepegawaian

**Akses:**
- Method: Read-only view (sensitive data)
- Contact: Biro Kepegawaian
- Note: Hanya ambil data yang diperlukan (NIP, Nama, Unit, Jabatan)

---

## 5. Master Data Unit Organisasi

**Deskripsi:** Referensi struktur organisasi ITERA

**Detail Teknis:**
- Platform: Static table / Excel
- Source: Statuta ITERA / Struktur Organisasi resmi

**Data Available:**
- Volume: ~60 unit (fakultas, jurusan, prodi, biro, UPT)
- Update frequency: Yearly (jarang berubah kecuali restrukturisasi)

**Struktur Data:**
| Kolom                 | Tipe Data    | Contoh                    |
|-----------------------|--------------|---------------------------|
| id_unit               | INT          | 1                         |
| kode_unit             | VARCHAR(20)  | FS                        |
| nama_unit             | VARCHAR(200) | Fakultas Sains            |
| nama_singkat          | VARCHAR(50)  | F. Sains                  |
| jenis_unit            | VARCHAR(50)  | Fakultas                  |
| parent_unit_id        | INT          | NULL (level tertinggi)    |
| level_unit            | INT          | 1                         |
| alamat                | TEXT         | Gedung A, Kampus ITERA    |
| telepon               | VARCHAR(20)  | 0721-8030188              |
| email                 | VARCHAR(100) | sains@itera.ac.id         |
| pimpinan_nip          | VARCHAR(20)  | 198001012005011001        |
| status_aktif          | BIT          | 1                         |

**Hierarki Unit:**
ITERA
├── Fakultas Sains (FS)
│   ├── Prodi Matematika
│   ├── Prodi Fisika
│   ├── Prodi Kimia
│   ├── Prodi Sains Data
│   ├── Prodi Sains Akutaria
│   ├── Prodi Biologi
│   ├── Prodi Sains Atmosfer dan Keplanetan
│   ├── Prodi Farmasi
│   ├── Prodi Sains Lingkungan Kelautan
│   └── Magister Fisika
├── Fakultas Teknologi Industri (FTI)
│   ├── Prodi Teknik Elektro
│   ├── Prodi Teknik Informatika
│   ├── Prodi Teknik Geofisika
│   ├── Prodi Teknik Mesin
│   ├── Prodi Teknik Industri
│   ├── Prodi Teknik Kimia
│   ├── Prodi Teknik Fisika
│   ├── Prodi Teknik Biosistem
│   ├── Prodi Teknik Sistem Energi
│   ├── Prodi Teknologi Industri Pertanian
│   ├── Prodi Teknologi Pangan
│   ├── Prodi Teknik Material
│   ├── Prodi Teknik Pertambangan
│   ├── Prodi Teknik Telekomunikasi
│   ├── Prodi Rekayasa Kehutanan
│   ├── Prodi Teknik Biomedis
│   ├── Prodi Rekayasa Minyak dan Gas
│   ├── Prodi Rekayasa Instrumentasi dan Automasi
│   ├── Prodi Rekayasa Kosmetik
│   └── Prodi Rekayasa Olahraga
├── Fakultas Teknologi Insftastruktur dan Kewilayahan (FTIK)
│   ├── Prodi Teknik Sipil
│   ├── Prodi Perencanaan Wilayah dan Kota
│   ├── Prodi Teknik Geomatika
│   ├── Prodi Arsitektur
│   ├── Prodi Teknik Lingkungan
│   ├── Prodi Teknik Kelautan
│   ├── Prodi Desain Komunikasi Visual
│   ├── Prodi Arsitektur Lanskap
│   ├── Prodi Teknik Perkeretaapian
│   ├── Prodi Rekayasa Tata Kelola Air Terpadu
│   └── Prodi Pariwisata
├── Biro Akademik (BA)
│   ├── Sub Bagian Akademik
│   ├── Sub Bagian Perencanaan
│   └── Sub Bagian Umum ← (Scope kita)
└── ...

**Data Quality:**
- Completeness: 100%
- Official data dari struktur organisasi

**Akses:**
- Method: Manual entry / One-time load
- Source: Website ITERA / Dokumen resmi

---

## 6. Master Data Referensi (Lookup Tables)

**Deskripsi:** Tabel referensi untuk standardisasi kategori
**Tabel-tabel:**

### ref_jenis_surat
| id | kode | nama_jenis            | kategori  |
|----|------|-----------------------|-----------|
| 1  | UND  | Undangan              | Masuk     |
| 2  | PEM  | Pemberitahuan         | Keluar    |
| 3  | SKP  | Surat Keputusan       | Keluar    |
| 4  | TUG  | Surat Tugas           | Keluar    |
| 5  | KET  | Surat Keterangan      | Keluar    |

### ref_status
| id | nama_status     | kategori        |
|----|-----------------|-----------------|
| 1  | Draf            | Surat           |
| 2  | Dalam Proses    | Surat/Layanan   |
| 3  | Selesai         | Surat/Layanan   |
| 4  | Dibatalkan      | Surat/Layanan   |

### ref_kondisi_aset
| id | nama_kondisi    | keterangan                      |
|----|-----------------|---------------------------------|
| 1  | Baik            | Berfungsi normal                |
| 2  | Rusak Ringan    | Perlu perbaikan minor           |
| 3  | Rusak Berat     | Perlu perbaikan major/penggantian |
| 4  | Hilang          | Tidak ditemukan                 |

### ref_kategori_aset
| id | kode | nama_kategori  | keterangan          |
|----|------|----------------|---------------------|
| 1  | FUR  | Furnitur       | Meja, kursi, lemari |
| 2  | ELK  | Elektronik     | Komputer, printer   |
| 3  | KND  | Kendaraan      | Motor, mobil dinas  |
| 4  | ATK  | ATK            | Alat tulis kantor   |

---

## 📋 Summary Tabel Data Sources
| No | Source Name | Type | Main Tables | Volume | Update Freq | Relevance |
|----|-------------|------|-------------|--------|-------------|-----------|
| 1 | SIMASTER | Database | surat_masuk, surat_keluar | 18K rows | Daily | ⭐⭐⭐ Critical |
| 2 | Inventaris Aset | Excel/DB | aset, maintenance_history | 1.2K rows | Monthly | ⭐⭐⭐ Critical |
| 3 | Permintaan Layanan | Google Sheets | permintaan_layanan | 3K rows | Real-time | ⭐⭐ Important |
| 4 | SIMPEG | Database (view) | pegawai | 600 rows | Monthly | ⭐⭐ Important |
| 5 | Unit Organisasi | Static | unit_organisasi | 60 rows | Yearly | ⭐⭐ Important |
| 6 | Referensi | Static | lookup tables | <100 rows | Rarely | ⭐ Supporting |

---
