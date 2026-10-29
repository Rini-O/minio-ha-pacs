#!/bin/sh
# Pemakaian: sh scripts/run-stages.sh <label> <endpoints>
#   Cluster : sh scripts/run-stages.sh cluster http://localhost:9000,http://localhost:9100
#   Baseline: sh scripts/run-stages.sh baseline http://localhost:9200
set -e
. ./.env
LABEL="${1:?label: cluster atau baseline}"
EP="${2:?endpoints dipisah koma}"
CONTAINERS="${3:-$( [ "$LABEL" = baseline ] && echo minio-single || echo 'minio1 minio2 minio3 minio4 nginx1 nginx2')}"
mkdir -p results

for VU in 10 100 500 1000; do
  echo "=== $LABEL: $VU VU ==="
  STATS="results/${LABEL}_stats_vu${VU}.csv"
  echo "time,name,cpu,mem" > "$STATS"
  ( while true; do
      docker stats --no-stream --format "$(date +%T),{{.Name}},{{.CPUPerc}},{{.MemUsage}}" $CONTAINERS >> "$STATS"
    done ) &
  STATS_PID=$!
  K6_ACCESS_KEY=k6-tester K6_SECRET_KEY="$PASS_K6TESTER" \
    k6 run -e VU=$VU -e DURATION=40s -e ENDPOINTS="$EP" \
    --summary-export="results/${LABEL}_vu${VU}.json" k6/loadtest.js || true
  kill $STATS_PID 2>/dev/null || true
  wait $STATS_PID 2>/dev/null || true
  sleep 10   # jeda pendinginan antar tahap
done
echo "Selesai. Jalankan: python3 scripts/plot.py"
