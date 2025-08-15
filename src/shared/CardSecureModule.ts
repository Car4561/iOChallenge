import { NativeModules, NativeEventEmitter, EmitterSubscription } from 'react-native';
import { CardSecureModulePort, SecureEvents } from './CardSecureModulePort';

const { SecureCardModule } = NativeModules as {
  SecureCardModule: {
    openSecureView(cardId: string, token: string): Promise<void>;
  }
};

const emitter = new NativeEventEmitter(NativeModules.SecureCardModule);
export const CardSecureModuleAdapter: CardSecureModulePort = {
  async openSecureView(cardId: string, token: string) {
    SecureCardModule.openSecureView(cardId, token);
  },
  addListener(handler: (e: SecureEvents) => void) {
    const subs: EmitterSubscription[] = [];
    subs.push(emitter.addListener('onSecureViewOpened', (p) => handler({ type: 'opened', ...p })));
    subs.push(emitter.addListener('onCardDataShown', (p) => handler({ type: 'shown', ...p })));
    subs.push(emitter.addListener('onValidationError', (p) => handler({ type: 'validation_error', ...p })));
    subs.push(emitter.addListener('onSecureViewClosed', (p) => handler({ type: 'closed', ...p })));
    return () => subs.forEach(s => s.remove());
  },
};
