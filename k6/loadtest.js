import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 10 },
    { duration: '1m', target: 10 },
    { duration: '10s', target: 0 },
  ],
};

export default function () {
  // Mengarahkan request ke Root Nginx Gateway Load Balancer (Port 9000)
  const res = http.get('http://localhost:9000/');
  
  check(res, {
    // Dianggap sukses jika server merespons (status di bawah 500 berarti server hidup & melayani trafik)
    'server is reachable': (r) => r.status < 500,
  });

  sleep(1);
}