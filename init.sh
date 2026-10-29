#!/bin/sh
# Pemakaian:
#   sh init.sh              -> inisialisasi cluster (container minio1)
#   sh init.sh minio-single -> inisialisasi baseline single-node
set -e
. ./.env
TARGET="${1:-minio1}"
MC="docker exec $TARGET mc"

$MC alias set local http://localhost:9000 "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD"
$MC mb --ignore-existing local/pacs-images

for u in radiolog dokter admin k6-tester; do
  VAR="PASS_$(echo $u | tr -d '-' | tr a-z A-Z)"
  $MC admin user add local "$u" "$(printenv $VAR)"
done

$MC admin policy attach local readwrite  --user radiolog
$MC admin policy attach local readonly   --user dokter
$MC admin policy attach local consoleAdmin --user admin
$MC admin policy attach local readwrite  --user k6-tester

echo "Selesai. Bucket pacs-images dan 4 akun dibuat di $TARGET."
