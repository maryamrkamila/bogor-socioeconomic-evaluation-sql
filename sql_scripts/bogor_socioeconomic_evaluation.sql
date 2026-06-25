-- Evaluasi Daerah Prioritas untuk Pendampingan Program dan Fasilitas Sosial-Ekonomi di Kota Bogor RTLH dan Pencari Kerja per Kecamatan
-- Author: Maryam Rahma Kusuma Kamila
-- Date: 2026-06-21
-- Description: Query ini mengsgunakan CTE untuk mengklasifikasikan wilayah ke dalam 4 kuadran performa.

WITH Data_Gabungan AS (
    -- Tahap 1: Menyatukan 9 tabel menjadi satu baris data per kecamatan
    SELECT 
        p.kecamatan,
        p.jumlah_penduduk,
        l.luas_daerah,
        pk.jumlah_pencari_kerja,
        -- Menjumlahkan semua fasilitas sarana kesehatan
        (sk.rs_umum + sk.rs_khusus + sk.klinik + sk.puskesmas) AS total_sarana_kesehatan,
        -- Menggabungkan semua fasilitas pendidikan dari tingkat dasar hingga tinggi
        (sd.jumlah_sd + smp.jumlah_smp + sma.jumlah_sma + pt.jumlah_perguruan_tinggi) AS total_sarana_pendidikan,
        r.berkurangnya_jumlah_unit_rtlh
    FROM tabel_penduduk p
    JOIN tabel_luas_daerah l ON p.kecamatan = l.kecamatan
    JOIN tabel_pencari_kerja pk ON p.kecamatan = pk.kecamatan
    JOIN tabel_sarana_kesehatan sk ON p.kecamatan = sk.kecamatan
    JOIN tabel_sd sd ON p.kecamatan = sd.kecamatan
    JOIN tabel_smp smp ON p.kecamatan = smp.kecamatan
    JOIN tabel_sma sma ON p.kecamatan = sma.kecamatan
    JOIN tabel_pt pt ON p.kecamatan = pt.kecamatan
    JOIN tabel_berkurangnya_rtlh r ON p.kecamatan = r.kecamatan
),
Kalkulasi_Metrik AS (
    -- Tahap 2: Feature Engineering & Penentuan Baseline menggunakan Window Functions
    SELECT 
        kecamatan,
        (jumlah_penduduk / luas_daerah) AS kepadatan_penduduk,
        (jumlah_pencari_kerja / jumlah_penduduk) * 1000.0 AS indeks_beban_pencari_kerja,
        (berkurangnya_jumlah_unit_rtlh / jumlah_penduduk) * 1000.0 AS indeks_performa_rtlh,
        ((total_sarana_kesehatan + total_sarana_pendidikan) / jumlah_penduduk) * 1000.0 AS rasio_fasilitas_publik,
        -- WINDOW FUNCTIONS: Menghitung rata-rata kota secara dinamis sebagai threshold
        AVG((jumlah_pencari_kerja / jumlah_penduduk) * 1000.0) OVER () AS avg_beban_kota,
        AVG((berkurangnya_jumlah_unit_rtlh / jumlah_penduduk) * 1000.0) OVER () AS avg_performa_kota
    FROM Data_Gabungan
)
-- Tahap 3: Klasifikasi Evaluasi Kebijakan Berdasarkan Matriks 4 Kuadran
SELECT 
    kecamatan,
    ROUND(kepadatan_penduduk, 2) AS kepadatan_jiwa,
    ROUND(rasio_fasilitas_publik, 2) AS rasio_fasilitas,
    ROUND(indeks_beban_pencari_kerja, 2) AS indeks_pencari_kerja,
    ROUND(indeks_performa_rtlh, 2) AS indeks_rtlh,
    CASE 
        WHEN indeks_beban_pencari_kerja > avg_beban_kota AND indeks_performa_rtlh <= avg_performa_kota 
             THEN 'Q1: Bottleneck'
        WHEN indeks_beban_pencari_kerja > avg_beban_kota AND indeks_performa_rtlh > avg_performa_kota 
             THEN 'Q2: Highly Effective'
        WHEN indeks_beban_pencari_kerja <= avg_beban_kota AND indeks_performa_rtlh > avg_performa_kota 
             THEN 'Q3: Over-Allocated'
        ELSE 'Q4: Stable Area'
    END AS status_kuadran
FROM Kalkulasi_Metrik
ORDER BY indeks_pencari_kerja DESC;