# Anotações de React Native (configurações de emulador)

## Android

### Listar emuladores android disponíveis

`emulator -list-avds`

### Rodar emulador listado acima

`emulator -avd NOME_DO_EMULADOR`
>Trocar **NOME_DO_EMULADOR** por uma das opções listadas no comando acima.

### Listar dispositivos reais android disponíveis

`adb devices`

### Quando for usar o emulador para acessar a api na rota 3333
`adb reverse tcp:3333 tcp:3333`

## IOS

### Listar emuladores iOS disponíveis

`open -a Simulator`
