#!/bin/sh
# Checklist verifikasi Pertemuan 2 (Tabel 10)
. ./.env
echo "--- 1. docker compose ps"; docker compose ps
echo "--- 2. docker stats (limit 0.25 CPU / 256MiB)"; docker stats --no-stream
echo "--- 3/4. Uji hak akses lewat mc"
M="docker exec minio1 mc"
echo test > /tmp/t.txt; docker cp /tmp/t.txt minio1:/tmp/t.txt
$M alias set rad http://lb.pacs:9000 radiolog "$PASS_RADIOLOG" >/dev/null 2>&1 || \
$M alias set rad http://localhost:9000 radiolog "$PASS_RADIOLOG"
$M alias set dok http://localhost:9000 dokter "$PASS_DOKTER"
echo "radiolog upload (harus berhasil):"; $M cp /tmp/t.txt rad/pacs-images/t.txt
echo "dokter download (harus berhasil):"; $M cat dok/pacs-images/t.txt
echo "dokter upload (harus DITOLAK):";    $M cp /tmp/t.txt dok/pacs-images/t2.txt || echo "ditolak -> OK"
echo "--- 5. Akses langsung node dari host (harus gagal)"
curl -s -m 3 http://localhost:9002/minio/health/live || echo "tidak terjangkau -> OK"
echo "--- 6. Port 9000 dan 9100"
curl -s -o /dev/null -w "9000: %{http_code}\n" http://localhost:9000/minio/health/live
curl -s -o /dev/null -w "9100: %{http_code}\n" http://localhost:9100/minio/health/live
