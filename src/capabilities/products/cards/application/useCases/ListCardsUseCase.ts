import type { Card } from '../../domain/entities/Card';
import type { CardRepositoryPort } from '../ports/CardRepositoryPort';

export class ListCardsUseCase {
  constructor(private readonly cardRepository: CardRepositoryPort) {}

  async execute(): Promise<ReadonlyArray<Card>> {
          console.log('prueba');

    return await this.cardRepository.listCards();
  }
}
