import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { CardSecureModuleAdapter } from '../../../../../shared/CardSecureModule';
import { generateSecureToken } from '../../../../../shared/security/secureToken';
import { SecureEvents } from '../../../../../shared/CardSecureModulePort';

type SecureState = 'idle' | 'opening' | 'shown' | 'error' | 'closed';

export function useSecureCardFlow() {
  const [state, setState] = useState<SecureState>('idle');
  const [lastError, setLastError] = useState<string | null>(null);

  useEffect(() => {
    CardSecureModuleAdapter.addListener((e: SecureEvents) => {
      console.log('Native event:', e);
      if (e.type === 'shown') {
        setState('shown');
      } else if (e.type === 'validation_error') {
        setState('error');
        setLastError(e.message ?? e.code);
      } else if (e.type === 'closed') {
        setState('closed');
      }
    });
  }, []);

  useEffect(() => {
    console.log(`state: ${state}, lastError: ${lastError}`);
  }, [state, lastError]);
  
  const open = useCallback(async (cardId: string) => {
    try {
      setState('opening');
      setLastError(null);

      const { token } = generateSecureToken(cardId, 25);

      await CardSecureModuleAdapter.openSecureView(cardId, token);
    } catch (e: any) {
      setState('error');
      setLastError(e?.message ?? 'Error al abrir vista segura');
    }
  }, [state]);

  return useMemo(() => ({
    state,
    error: lastError,
    open,
  }), [state, lastError, open]);
}
