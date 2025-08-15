export type SecureEvents =
  | { type: 'opened'; cardId: string }
  | { type: 'shown'; cardId: string }
  | { type: 'validation_error'; code: 'TOKEN_EXPIRED' | 'TOKEN_INVALID'; message?: string }
  | { type: 'closed'; cardId: string; reason: 'USER_DISMISS' | 'TIMEOUT' };

export interface CardSecureModulePort {
  addListener(cb: (e: SecureEvents) => void): () => void;
  openSecureView(cardId: string, token: string): Promise<void>
}