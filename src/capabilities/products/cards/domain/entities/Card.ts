export interface Card {
  cardId: string;
  alias: string;         
  maskedPan: string;
  brand: 'VISA' | 'MASTERCARD' | 'AMEX' | 'OTHER';
  holder: string;        
  expiry: string;
  accountId: string;
}