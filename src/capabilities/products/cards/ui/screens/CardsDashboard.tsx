import { useCallback, useEffect, useMemo, useState } from 'react';
import { View, Text, FlatList, ActivityIndicator, StyleSheet, Pressable } from 'react-native';
import { CardItem } from '../components/CardItem';
import { useListCards } from '../hooks/useListCards';
import { HttpCardRepository } from '../../infrastructure/HttpCardRepository';
import { CardSecureModuleAdapter } from '../../../../../shared/CardSecureModule';
import { useSecureCardFlow } from '../hooks/useSecureCardFlow';

const repo = new HttpCardRepository();

export default function CardsDashboard() {
  const { cards, loading, error, reload } = useListCards(repo);
  const secure = useSecureCardFlow();

  const handlePress = useCallback((cardId: string) => {
    secure.open(cardId)
  }, [secure]);


  const renderItem = useCallback(({ item }: any) => (
    <CardItem
      card={item}
      onPress={handlePress}
    />
  ), []);

  if (loading) {
    return (
      <View style={styles.center}>
        <ActivityIndicator/>
      </View>
    );
  }
if (error) {
  return (
    <View style={styles.center}>
      <Text style={styles.errorTitle}>Ocurrió un problema</Text>
      <Text style={styles.errorMessage}>
        {error || 'No pudimos cargar tus tarjetas en este momento.'}
      </Text>
      <Pressable onPress={reload} style={({ pressed }) => [
        styles.retryButton,
        pressed && { opacity: 0.8 }
      ]}>
        <Text style={styles.retryText}>Reintentar</Text>
      </Pressable>
    </View>
  );
}

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Tus tarjetas</Text>
      <FlatList
        data={cards}
        renderItem={renderItem}
        keyExtractor={(item) => item.cardId}
        initialNumToRender={6}
        windowSize={3}
        removeClippedSubviews
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1, 
    paddingVertical: 16
  },
  list: { paddingBottom: 48 },
  title: { 
     paddingHorizontal: 16,
     fontSize: 20,
     fontWeight: '700',
     marginBottom: 12
  },
  center: { 
    flex: 1, 
    alignItems: 'center',
    justifyContent: 'center'
  },
  link: { 
    color: '#69f', 
    marginTop: 8,
    textDecorationLine: 'underline'
  },
  errorTitle: {
    fontSize: 20,
    fontWeight: '700',
    marginBottom: 8,
    color: '#333'
  },
  errorMessage: {
    fontSize: 16,
    color: '#555',
    textAlign: 'center',
    marginBottom: 20
  },
  retryButton: {
    backgroundColor: '#1A73E8',
    paddingHorizontal: 20,
    paddingVertical: 10,
    borderRadius: 8
  },
  retryText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: '600'
  },
});