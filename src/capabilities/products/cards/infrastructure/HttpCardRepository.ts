import type { Card } from '../domain/entities/Card';
import type { CardRepositoryPort } from '../application/ports/CardRepositoryPort';

const BASE_URL = 'https://mocki.io/v1/45d30dba-6c41-4f17-990b-7a0db79cf703';

export class HttpCardRepository implements CardRepositoryPort {
  async listCards(): Promise<ReadonlyArray<Card>> {
    try {
      const controller = new AbortController();
      const timeout = setTimeout(() => controller.abort(), 8000); // 8s timeout
      console.log(`${BASE_URL}/cards`)
      const res = await fetch(`${BASE_URL}`, {
        method: 'GET',
        headers: { 'Accept': 'application/json' },
        signal: controller.signal,
      });
      clearTimeout(timeout);
      console.log('prueba{}');
      console.log(res)
      if (!res.ok) {
        throw new Error(`HTTP ${res.status}`);
      }

      const cards: Card[] = await res.json();

      return cards;
    } catch (e) {
      throw e;
    }
  }
}