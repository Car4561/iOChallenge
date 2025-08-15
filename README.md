# iOChallenge (React Native)

Proyecto React Native con SecureCardView en iOS que incluye un listado de tarjetas (`CardsDashboard`) y un **Secure View** para visualizar los datos de las tarjetas, implementa medidas de seguridad:  
- **Blur** automático cuando la app pasa a background, regresa a la normalidad al volver la app a primer plano.  
- **Campos sensibles ocultos en iOS** durante **capturas de pantalla** o **grabación de pantalla** (por tal motivo en el video adjuntado no se visualizan).

---

## Requisitos

- **macOS** con **Xcode 16+**
- **Node.js** 18+.
- **npm** o **yarn**.
- **CocoaPods**

---

## Instalación

1) **Instalar dependencias JS**  
```bash
npm install
```

2) **Instalar Pods (iOS)**  
```bash
cd ios
pod install
cd ..
```

---

## Ejecutar en iOS
### Terminal 
```bash
npm run ios
```
> Este comando ejecutará la aplicación en el simulador por default

**Elegir un simulador específico**

Lista simuladores:
```bash
xcrun simctl list devices
```
los marcados en **(Booted)** son los simuladores ejecutandose

Ejecutar en uno en particular (ejemplo **iPhone 16 Pro**):
```bash
npx react-native run-ios --simulator="iPhone 16 Pro"
```

**Ejecutar en dispositivo físico**

Solo en dispositivo físico se puede probar el bloqueo de datos sensibles al grabar o tomar capturas de pantalla

```bash
npx react-native run-ios --device "Nombre del dispositivo"
```

### Xcode

- Abrir `ios/iOChallenge.xcworkspace` en Xcode.  
- Elegir ya sea simulador o dispositivo físico 
- Ejecuta (`Run` / ⌘R).

---

## Scripts útiles

`package.json`:
```json
  "scripts": {
    "android": "react-native run-android",
    "ios": "react-native run-ios",
    "lint": "eslint .",
    "start": "react-native start",
    "test": "jest",
    "ios:16pro": "react-native run-ios --simulator='iPhone 16 Pro'"
  },
```

Uso:
```bash
npm run ios:16pro
```

---

## Estructura y Arquitectura

```
src/
  capabilities/
    products/                     #  BIAN - Products como capability
      cards/                      # Vertical Slice (BIAN) — toda la lógica de Cards en un único módulo 
        domain/                   # Hexagonal: Núcleo de dominio
          entities/
            Card.ts      
        application/               # Hexagonal: Casos de uso, lógica del dominio
          ports/                   # Interface Principio de Inversión de Dependencias (SOLID)
            CardRepositoryPort.ts  # Interfaz de repositorio
          useCases/
            ListCardsUseCase.ts.  # Ejecución de repositorio
        infrastructure/           # Hexagonal: implementaciones de puertos
          HttpCardRepository.ts   # Repositorio Remoto HTTP
        ui/                       # Capa de presentación (React Native) — hooks, pantallas, componentes
          screens/
            CardsDashboard.tsx    # Scren del listado de tarjetas con FlatList optimizada, estados loading/error y acción para abrir screen Nativo 
          components/
            CardItem.tsx          # Item de card
          hooks/
            useListCards.ts       # Hook que obtiene tarjetas del servidor
            useSecureCardFlow.ts  # Hook Generación de token + integración con puente nativo (eventos, estados)
shared/
  CardSecureModule.ts             # Bridge RN y iOS (NativeEventEmitter)
  CardSecureModulePort.ts         # Tipos de eventos
  security/secureToken.ts         # Generación y validación de token
```

- **Arquitectura Hexagonal:** separación clara en **dominio** (lógica pura), **aplicación** (casos de uso/puertos) y **adaptadores** (infraestructura/UI).
- **Clean Architecture + SOLID:** capas independientes, dependencias abstractas, files con responsabilidad única
- **Vertical Slicing (BIAN):** cada *capability* (`Products/Cards`) agrupa sus capas dentro de un mismo módulo, evitando un monolito de carpetas por capa global.
- **React Native:** hooks (`useCallback`, `useMemo`), listas optimizadas (`FlatList`), separación de UI y lógica.
- **Performance & Accesibilidad:** render mínimo, uso de `React.memo`.
- **Seguridad (nativo):** blur en background, ocultar datos sensibles en capturas, timeout con cierre automático.

---

## Seguridad & Privacidad

- **Blur en background**: cuando la app pasa a segundo plano (applicationWillResignActive), se coloca un **UIVisualEffectView (blur)** sobre el rootView principal, al regresar a la app (applicationDidBecomeActive) se remueve este blur.
- **Ocultar campos sensibles en capturas/grabación**: Usando la funcionalidad de los UITextField se logró proteger los campos sensibles de las capturas y grabaciones de pantalla  .  
  **Nota**: Por este motivo, en el video adjuntado no se ven esos datos sensibles (comportamiento esperado).

---

## Tests

Se usan **Jest** + **react-test-renderer**  
Cobertura actual:
- Estado **loading** (spinner visible).
- Estado **error** + acción **Reintentar**.
- Render de lista y **tap** en una tarjeta (invoca `secure.open(cardId)`).

Ejecutar:
```bash
npx jest __tests__/CardsDashboard.test.tsx 
```

> Los tests envuelven render/interacciones en `act(...)`

---


## Notas


- Si hay problemas con Pods:  
  ```bash
  cd ios
  pod repo update
  pod install
  cd ..
  ```

---

#
