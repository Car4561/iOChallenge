import React, { memo, useCallback } from 'react';
import { View, Text, Pressable, StyleSheet, Platform } from 'react-native';
import type { Card } from '../../domain/entities/Card';

export type CardItemProps = { 
  card: Card;
  onPress?: (cardId: string) => void 
};

export const CardItem = memo(function CardItem({ card, onPress }: CardItemProps) {

  const handlePress = useCallback(() => onPress?.(card.cardId), [card.cardId, onPress]);

  const brandColor: Record<string, string> = {
    VISA: '#1A1F71',
    AMEX: '#2E77BB'
  };

  const backgroundColor = brandColor[card.brand] ?? '#7b1fa2'; 

  return (
    <Pressable
      onPress={handlePress}
      android_ripple={{ color: 'rgba(255,255,255,0.15)' }}
      style={({ pressed }) => [styles.wrapper, pressed && styles.pressed]}
    >
      <View style={[styles.card, { backgroundColor }]}>
        <View style={[styles.vignetteBlob]} pointerEvents="none" />
        <View style={styles.gloss} />

        <View style={styles.row}>
          <Text style={styles.alias}>{card.alias}</Text>

          <View style={styles.brandChip}>
            <Text style={styles.brandText}>{card.brand}</Text>
          </View>
        </View>

        <Text style={styles.masked}>{card.maskedPan}</Text>

        <View style={styles.row}>
          <Text style={styles.expiry}>Vence {card.expiry}</Text>
          <Text style={styles.holder} numberOfLines={1}>{card.holder}</Text>
        </View>
      </View>
    </Pressable>
  );
});

const styles = StyleSheet.create({
  wrapper: {
    paddingHorizontal: 16,
    marginVertical: 12,
    borderRadius: 22,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.12,
    shadowRadius: 16,
    elevation: 6 
  },
  pressed: { 
    transform: [{ scale: 0.985 }],
    opacity: 0.98
  },
  card: {
    borderRadius: 22,
    padding: 20,
    overflow: 'hidden',
    borderWidth: 1,
    borderColor: 'rgba(255,255,255,0.15)',
  },
  vignetteBlob: {
    position: 'absolute',
    top: -90, 
    left: -70,
    width: 260,
    height: 260,
    borderRadius: 130,
    backgroundColor: 'rgba(0,0,0,0.16)', // oscurito suave
  },
  gloss: {
    position: 'absolute',
    top: -40,
    right: -60,
    width: 220,
    height: 220,
    borderRadius: 110,
    backgroundColor: 'rgba(255,255,255,0.16)',
    transform: [{ rotate: '15deg' }],
  },
  row: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  alias: { color: '#fff', fontSize: 18, fontWeight: '800', letterSpacing: 0.2 },
  brandChip: {
    backgroundColor: 'rgba(255,255,255,0.18)',
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: 'rgba(255,255,255,0.25)',
  },
  brandText: { 
    color: '#fff',
    fontSize: 12, 
    fontWeight: '700',
    letterSpacing: 1 
  },
  masked: {
    color: '#fff',
    fontSize: 22,
    letterSpacing: 3,
    marginVertical: 14,
    fontWeight: '700',
    fontVariant: ['tabular-nums'],
  },
  expiry: { color: 'rgba(255,255,255,0.9)', fontWeight: '600' },
  holder: { color: 'rgba(255,255,255,0.9)', maxWidth: '55%', fontWeight: '600' },
});
