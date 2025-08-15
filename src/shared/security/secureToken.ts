// src/shared/security/secureToken.ts
type TokenPayload = {
  cardId: string;
  iat: number; // ms
  exp: number; // ms
  nonce: string;
};

export function simpleHash(str: string): string {
  let h = 0;
  for (let i = 0; i < str.length; i++) h = (h * 31 + str.charCodeAt(i)) | 0;
  return Math.abs(h).toString(36);
}

function encodePayload(obj: any): string {
  return encodeURIComponent(JSON.stringify(obj));
}

export function generateSecureToken(cardId: string, ttlSeconds = 60) {
  const now = Date.now();
  const payload: TokenPayload = {
    cardId,
    iat: now,
    exp: now + ttlSeconds * 1000,
    nonce: Math.random().toString(36).slice(2),
  };
  const secret = 'iO';
  const encodable = encodePayload(payload);
  const signature = simpleHash(`${encodable}.${secret}`);
  const token = `${encodable}.${signature}`;
  return { token, payload };
}
