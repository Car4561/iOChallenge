import React from 'react';
import renderer, { act } from 'react-test-renderer';
import { ActivityIndicator, Text } from 'react-native';
import CardsDashboard from '../src/capabilities/products/cards/ui/screens/CardsDashboard';

jest.mock('../src/capabilities/products/cards/ui/hooks/useListCards', () => ({
  useListCards: jest.fn(),
}));
jest.mock('../src/capabilities/products/cards/ui/hooks/useSecureCardFlow', () => ({
  useSecureCardFlow: jest.fn(),
}));
jest.mock('../src/capabilities/products/cards/ui/components/CardItem', () => {
  const React = require('react');
  const { Pressable, Text } = require('react-native');
  return {
    CardItem: ({ card, onPress }: any) => (
      <Pressable testID={`card-${card.cardId}`} onPress={() => onPress(card.cardId)}>
        <Text>{card.cardId}</Text>
      </Pressable>
    ),
  };
});

const { useListCards } = jest.requireMock('../src/capabilities/products/cards/ui/hooks/useListCards');
const { useSecureCardFlow } = jest.requireMock('../src/capabilities/products/cards/ui/hooks/useSecureCardFlow');

beforeAll(() => {
  jest.useFakeTimers();
});
afterEach(() => {
  // Drena timers pendientes para que no exploten al terminar el test
  act(() => {
    jest.runOnlyPendingTimers();
  });
  jest.clearAllMocks();
});
afterAll(() => {
  jest.useRealTimers();
});

describe('CardsDashboard', () => {
  it('muestra loader cuando loading=true', () => {
    (useListCards as jest.Mock).mockReturnValue({
      cards: [],
      loading: true,
      error: null,
      reload: jest.fn(),
    });
    (useSecureCardFlow as jest.Mock).mockReturnValue({
      state: 'idle',
      error: null,
      open: jest.fn(),
    });

    let tree!: renderer.ReactTestRenderer;
    act(() => {
      tree = renderer.create(<CardsDashboard />);
    });

    expect(tree.root.findAllByType(ActivityIndicator).length).toBeGreaterThan(0);

 
  });

  it('muestra error y llama reload al presionar "Reintentar"', () => {
    const reload = jest.fn();
    (useListCards as jest.Mock).mockReturnValue({
      cards: [],
      loading: false,
      error: 'Falla de red',
      reload,
    });
    (useSecureCardFlow as jest.Mock).mockReturnValue({
      state: 'idle',
      error: null,
      open: jest.fn(),
    });

    let tree!: renderer.ReactTestRenderer;
    act(() => {
      tree = renderer.create(<CardsDashboard />);
    });

    const retryBtnNode = tree.root.findAll(
      (node) =>
        typeof node.props?.onPress === 'function' &&
        node.findAllByType(Text).some((t) => t.props.children === 'Reintentar')
    )[0];

    expect(retryBtnNode).toBeTruthy();

    act(() => {
      retryBtnNode.props.onPress();
    });
    
    expect(reload).toHaveBeenCalledTimes(1);
  });

  it('renderiza lista y ejecuta secure.open al tocar una tarjeta', () => {
    const open = jest.fn();
    (useSecureCardFlow as jest.Mock).mockReturnValue({ state: 'idle', error: null, open });
    (useListCards as jest.Mock).mockReturnValue({
      cards: [{ cardId: 'card-1' }, { cardId: 'card-2' }],
      loading: false,
      error: null,
      reload: jest.fn(),
    });

    let tree!: renderer.ReactTestRenderer;
    act(() => {
      tree = renderer.create(<CardsDashboard />);
    });

    const card1 = tree.root.findByProps({ testID: 'card-card-1' });
    const card2 = tree.root.findByProps({ testID: 'card-card-2' });

    act(() => {
      card1.props.onPress();
      card2.props.onPress();
    });

    expect(open).toHaveBeenCalledWith('card-1');
    expect(open).toHaveBeenCalledWith('card-2');
    expect(open).toHaveBeenCalledTimes(2);
  });
});
