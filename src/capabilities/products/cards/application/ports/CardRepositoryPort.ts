import type { Card } from '../../domain/entities/Card';

export interface CardRepositoryPort {
  listCards(): Promise<ReadonlyArray<Card>>;
}