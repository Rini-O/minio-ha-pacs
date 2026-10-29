"""Membuat grafik RPS & latency p95 vs VU (cluster vs baseline) + tabel hasil (Tabel 12)."""
import json, csv, os, re
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

VUS = [10, 100, 500, 1000]

def metric(d, name, key):
    m = d["metrics"].get(name, {})
    m = m.get("values", m)
    return m.get(key)

def load(label):
    rows = {}
    for vu in VUS:
        p = f"results/{label}_vu{vu}.json"
        if not os.path.exists(p):
            continue
        d = json.load(open(p))
        rps = metric(d, "http_reqs", "rate")
        p95 = metric(d, "http_req_duration", "p(95)")
        err = metric(d, "http_req_failed", "value")
        if err is None:
            err = metric(d, "http_req_failed", "rate")
        cpu = mem = None
        sp = f"results/{label}_stats_vu{vu}.csv"
        if os.path.exists(sp):
            cpus, mems = [], []
            for r in csv.DictReader(open(sp)):
                try:
                    cpus.append(float(r["cpu"].strip("%")))
                    m = re.match(r"([\d.]+)\s*(MiB|GiB|KiB)", r["mem"])
                    v = float(m.group(1)) * {"KiB": 1/1024, "MiB": 1, "GiB": 1024}[m.group(2)]
                    mems.append(v)
                except Exception:
                    pass
            cpu = max(cpus) if cpus else None
            mem = max(mems) if mems else None
        rows[vu] = dict(rps=rps, p95=p95, err=(err or 0) * 100, cpu=cpu, mem=mem)
    return rows

data = {l: load(l) for l in ("cluster", "baseline")}

with open("results/tabel12.csv", "w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["sistem", "VU", "RPS", "p95_ms", "error_%", "CPU_maks_%", "Mem_maks_MiB", "SLA"])
    for label, rows in data.items():
        for vu, r in rows.items():
            ok = r["p95"] is not None and r["p95"] < 200 and r["err"] < 1
            w.writerow([label, vu] + [None if r[k] is None else round(r[k], 2)
                       for k in ("rps", "p95", "err", "cpu", "mem")] + ["Ya" if ok else "Tidak"])

for key, title, ylabel, fn in [
    ("rps", "Throughput (RPS) vs Jumlah VU", "Request per detik", "grafik_rps.png"),
    ("p95", "Latency p95 vs Jumlah VU", "p95 (ms)", "grafik_latency_p95.png"),
]:
    plt.figure(figsize=(7, 4.5))
    for label, rows in data.items():
        xs = [v for v in VUS if v in rows and rows[v][key] is not None]
        if xs:
            plt.plot(xs, [rows[v][key] for v in xs], marker="o",
                     label="Cluster 4 node + 2 Nginx" if label == "cluster" else "Baseline single-node")
    if key == "p95":
        plt.axhline(200, color="red", ls="--", label="SLA 200 ms")
    plt.xlabel("Virtual User"); plt.ylabel(ylabel); plt.title(title)
    plt.xscale("log"); plt.xticks(VUS, VUS); plt.grid(alpha=.3); plt.legend()
    plt.tight_layout(); plt.savefig(f"results/{fn}", dpi=150); plt.close()

print("Tersimpan: results/tabel12.csv, grafik_rps.png, grafik_latency_p95.png")
