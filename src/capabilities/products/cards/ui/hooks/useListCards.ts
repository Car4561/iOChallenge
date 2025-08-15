import { useCallback, useEffect, useMemo, useState } from 'react';
import type { Card } from '../../domain/entities/Card';
import { ListCardsUseCase } from '../../application/useCases/ListCardsUseCase';
import type { CardRepositoryPort } from '../../application/ports/CardRepositoryPort';
import { HttpCardRepository } from '../../infrastructure/HttpCardRepository';

export function useListCards(repo: CardRepositoryPort) {
  const [cards, setCards] = useState<readonly Card[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async () => {
    setLoading(true); setError(null);
    try {
      const usecase = new ListCardsUseCase(repo);
        console.log("sas");
      const data = await usecase.execute();
      setCards(data);
    } catch (e) {
      setError('No se pudieron cargar las tarjetas');
      console.log(e)
    } finally {
      setLoading(false);
    }
  }, [repo]);

  useEffect(() => {
     void load(); 
  }, [load]);

  return useMemo(() => ({ cards, loading, error, reload: load }), [cards, loading, error, load]);
}