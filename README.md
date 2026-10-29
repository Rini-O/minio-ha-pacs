<<<<<<< HEAD
# MinIO HA - PACS Storage (Kelompok 4, H7A.7) - Versi 3
Distributed Object Storage & HA File System dengan MinIO Cluster (4 node MinIO + 2 Nginx).

## Struktur
- docker-compose.yml          : cluster 4 MinIO + 2 Nginx (limit 0.25 CPU / 256MB)
- docker-compose.baseline.yml : MinIO single-node pembanding (Pertemuan 3)
- nginx/nginx.conf            : konfigurasi load balancer
- init.sh                     : bucket, user, policy
- k6/loadtest.js, sample-100kb.jpg : uji beban
- scripts/verify.sh, run-stages.sh, plot.py
- docs/architecture.png       : taruh diagram Gambar 1 di sini
- results/                    : keluaran uji (json, csv, grafik)

## Menjalankan
    cp .env.example .env     # isi kredensial
    docker compose up -d
    sh init.sh
    sh scripts/verify.sh

## Load test
    sh scripts/run-stages.sh cluster http://localhost:9000,http://localhost:9100
    docker compose down
    docker compose -f docker-compose.baseline.yml up -d && sh init.sh minio-single
    sh scripts/run-stages.sh baseline http://localhost:9200
    python3 scripts/plot.py

## Pembagian tugas & progres
(isi)
=======
# 🏥 MinIO Distributed Cluster & High-Availability File System for PACS Storage

[![Docker](https://img.shields.io/badge/Docker-20.10+-2496ED?style=flat&logo=docker&logoColor=white)](https://www.docker.com/)
[![MinIO](https://img.shields.io/badge/MinIO-RELEASE.2025--04--22-C72C48?style=flat&logo=minio&logoColor=white)](https://min.io/)
[![Nginx](https://img.shields.io/badge/Nginx-1.27--alpine-009639?style=flat&logo=nginx&logoColor=white)](https://nginx.org/)

Proyek Simulasi *Cloud Computing* (3 SKS) – **Kelompok 4 (Pertemuan 1: Planning & Architecture Design)**.

---

## 📌 Deskripsi Studi Kasus
Proyek ini mengimplementasikan **Penyimpanan Objek Terdistribusi berbasis MinIO Cluster** yang terintegrasi dengan **Nginx Load Balancer** untuk sistem arsip berkas medis rumah sakit (*Picture Archiving and Communication System* / PACS Storage).

## 👥 Anggota Kelompok 4
* Rini Fatmawati
* Anisa Tanti Meliany
* Karimatuzzahrah Firdausi
* Nadifah Meidina Margo Setyo

## ⚙️ Komponen Utama & Batasan Sumber Daya
* **Nginx Reverse Proxy & Load Balancer**: Mengatur *least_conn* routing, *failover* cepat, dan pembatasan ukuran file arsip (`client_max_body_size 0`).
* **MinIO Cluster (4 Nodes)**: Berjalan secara terdistribusi dalam 1 file `docker-compose.yml` dengan batasan sumber daya ketat (`cpus: 0.25`, `memory: 256M` per kontainer).

## 🚀 Cara Menjalankan
1. Clone repository ini:
   ```bash
   git clone [https://github.com/Rini-O/minio-ha-pacs.git](https://github.com/Rini-O/minio-ha-pacs.git)
   cd minio-ha-pacs
>>>>>>> 3c89dfbe26adfe611e227293febb3f41c3a09be0
