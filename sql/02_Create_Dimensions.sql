-- =====================================================
-- 02_Create_Dimensions.sql
-- Project : Data Mart Biro Akademik Umum ITERA
-- Purpose : Create Dimension Tables in 'dim' schema
-- Engine  : PostgreSQL
-- Dependencies: 01_Create_Database.sql must be executed first
-- =====================================================

-- 1. DIM WAKTU (Date Dimension)
-- Grain: 1 baris per hari
CREATE TABLE IF NOT EXISTS dim.dim_waktu (
    tanggal_key         INT PRIMARY KEY, -- Format YYYYMMDD (misal: 20241015)
    tanggal             DATE NOT NULL,
    hari                VARCHAR(20),     -- Senin, Selasa...
    bulan               INT,             -- 1-12
    tahun               INT,             -- 2024
    quarter             INT,             -- 1-4
    minggu_tahun        INT,             -- 1-53
    hari_dalam_bulan    INT,             -- 1-31
    hari_kerja          BOOLEAN,         -- TRUE jika Senin-Jumat & bukan libur
    bulan_tahun         VARCHAR(20)      -- 'Oktober 2024'
);

-- 2. DIM UNIT KERJA (Organizational Hierarchy)
-- Grain: 1 baris per unit kerja
CREATE TABLE IF NOT EXISTS dim.dim_unit_kerja (
    unit_key            SERIAL PRIMARY KEY,
    kode_unit           VARCHAR(20) NOT NULL,
    nama_unit           VARCHAR(100) NOT NULL,
    level               INT,             -- 1=Rektorat, 2=Biro, dst.
    parent_unit_key     INT,             -- Self-referencing FK
    kepala_unit_nip     VARCHAR(20),
    email_unit          VARCHAR(100),
    path_hierarchy      TEXT,            -- 'Rektorat > BAU'
    jumlah_sub_unit     INT DEFAULT 0,
    is_active           BOOLEAN DEFAULT TRUE
);
-- Self-Referencing FK untuk Hierarki
ALTER TABLE dim.dim_unit_kerja 
ADD CONSTRAINT fk_dim_unit_parent 
FOREIGN KEY (parent_unit_key) REFERENCES dim.dim_unit_kerja(unit_key);


-- 3. DIM PEGAWAI (SCD Type 2)
-- Grain: 1 baris per versi data pegawai
CREATE TABLE IF NOT EXISTS dim.dim_pegawai (
    pegawai_key         SERIAL PRIMARY KEY,
    nip                 VARCHAR(20) NOT NULL,
    nama                VARCHAR(100),
    jabatan             VARCHAR(100),
    unit_key            INT,             -- FK ke Dim Unit Kerja
    status_kepegawaian  VARCHAR(50),     -- PNS, PPPK, Honorer
    tanggal_masuk       DATE,
    email               VARCHAR(100),
    no_hp               VARCHAR(20),
    -- Kolom SCD Type 2
    effective_date      DATE NOT NULL,
    end_date            DATE NOT NULL DEFAULT '9999-12-31',
    is_current          BOOLEAN DEFAULT TRUE
);
CREATE INDEX ix_dim_pegawai_nip ON dim.dim_pegawai(nip);
CREATE INDEX ix_dim_pegawai_current ON dim.dim_pegawai(is_current);


-- 4. DIM JENIS SURAT
-- Grain: 1 baris per jenis surat
CREATE TABLE IF NOT EXISTS dim.dim_jenis_surat (
    jenis_surat_key     SERIAL PRIMARY KEY,
    kode_jenis_surat    VARCHAR(20),
    nama_jenis_surat    VARCHAR(100),
    kategori            VARCHAR(50),     -- Internal, Eksternal
    sifat               VARCHAR(20),     -- Biasa, Penting, Rahasia
    is_active           BOOLEAN DEFAULT TRUE
);


-- 5. DIM JENIS LAYANAN
-- Grain: 1 baris per jenis layanan
CREATE TABLE IF NOT EXISTS dim.dim_jenis_layanan (
    jenis_layanan_key   SERIAL PRIMARY KEY,
    kode_jenis_layanan  VARCHAR(20),
    nama_jenis_layanan  VARCHAR(100),
    kategori_layanan    VARCHAR(50),     -- Sarpras, Akademik
    sla_target_jam      INT,             -- Target SLA dalam jam
    is_active           BOOLEAN DEFAULT TRUE
);


-- 6. DIM BARANG (Aset/Inventaris)
-- Grain: 1 baris per jenis barang/aset
CREATE TABLE IF NOT EXISTS dim.dim_barang (
    barang_key          SERIAL PRIMARY KEY,
    kode_barang         VARCHAR(30) NOT NULL,
    nama_barang         VARCHAR(200),
    kategori_barang     VARCHAR(50),     -- Elektronik, Furnitur
    subkategori_barang  VARCHAR(50),
    satuan              VARCHAR(20),
    merk                VARCHAR(50),
    spesifikasi         TEXT,
    is_bergerak         BOOLEAN,         -- TRUE/FALSE
    is_tik              BOOLEAN          -- TRUE jika aset IT
);


-- 7. DIM LOKASI
-- Grain: 1 baris per lokasi fisik
CREATE TABLE IF NOT EXISTS dim.dim_lokasi (
    lokasi_key          SERIAL PRIMARY KEY,
    kode_lokasi         VARCHAR(30),
    nama_lokasi         VARCHAR(100),
    jenis_lokasi        VARCHAR(50),     -- Ruang Kerja, Gudang, Kelas
    gedung              VARCHAR(50),
    lantai              VARCHAR(10),
    keterangan          TEXT
);

-- =====================================================
-- NOTICE
-- =====================================================
DO $$
BEGIN
    RAISE NOTICE 'Dimension tables created successfully in schema "dim".';
END $$;
