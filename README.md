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
