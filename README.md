# 🏥 MinIO Distributed Cluster & High-Availability File System for PACS Storage

[![Docker](https://img.shields.io/badge/Docker-20.10+-2496ED?style=flat&logo=docker&logoColor=white)](https://www.docker.com/)
[![MinIO](https://img.shields.io/badge/MinIO-RELEASE.2025--04--22-C72C48?style=flat&logo=minio&logoColor=white)](https://min.io/)
[![Nginx](https://img.shields.io/badge/Nginx-1.27--alpine-009639?style=flat&logo=nginx&logoColor=white)](https://nginx.org/)

Proyek Simulasi *Cloud Computing* (3 SKS) – **Kelompok 4 (Pertemuan 1: Planning & Architecture Design)**.

---

## 👥 Anggota Kelompok 4
- Rini Fatmawati
- Anisa Tanti Meliany
- Karimatuzzahrah Firdausi
- Nadifah Meidina Margo Setyo

---

## 📌 Deskripsi Studi Kasus & Struktur File
Proyek ini mengimplementasikan **Penyimpanan Objek Terdistribusi berbasis MinIO Cluster** yang terintegrasi dengan **Nginx Load Balancer** untuk sistem arsip berkas medis rumah sakit (*Picture Archiving and Communication System* / PACS Storage).

- `docker-compose.yml`          : Kluster utama (4 node MinIO + 2 Nginx, limit `0.25 CPU` / `256MB` per kontainer)
- `docker-compose.baseline.yml` : MinIO *single-node* pembanding untuk uji performa
- `nginx/nginx.conf`            : Konfigurasi *load balancer* dengan metode *least_conn*
- `init.sh`                     : Skrip otomatisasi pembuatan *bucket*, *user*, dan *policy*
- `k6/loadtest.js`              : Skrip uji beban (*load test*) menggunakan k6
- `k6/sample-100kb.jpg`         : Berkas sampel uji unggah (*payload*)
- `scripts/verify.sh`           : Skrip verifikasi kesehatan kluster
- `scripts/run-stages.sh`       : Skrip otomatisasi tahapan uji beban
- `scripts/plot.py`             : Skrip Python untuk menghasilkan grafik performa dari hasil pengujian
- `results/`                    : Direktori penyimpanan keluaran data uji (*json*, *csv*, grafik)

---

## 🚀 Cara Menjalankan Seluruh Proyek

Ikuti langkah-langkah berikut secara berurutan di terminal (PowerShell / Bash):

### 1. Persiapan Konfigurasi
Salin file templat environment:
```bash
cp .env.example .env