# Radio Ciwara App 📻

Application mobile Flutter de Radio Ciwara 105.5 FM — Bamako.

## Lecteur

Le projet contient deux méthodes :

1. **Lecteur natif Flutter** : utilise directement le flux audio déjà présent dans le site.
2. **Lecteur Caster.fm** : le code `cstrEmbed` du site est conservé dans `assets/caster_player.html` et affiché dans une WebView.

Le lecteur natif est recommandé pour l'application mobile car le widget Caster.fm est un composant HTML/JavaScript destiné au Web.

## Source du flux

URL actuellement présente dans `index.html` du site Radio Ciwara :

`https://uk5freenew.listen2myradio.com/live.mp3?typeportmount=s1_35628_stream_416941156`

Si le serveur de streaming change, modifier uniquement :

`lib/config/radio_config.dart`

## Installation

```bash
flutter pub get
flutter run
```

Si les dossiers Android/iOS ne sont pas encore présents :

```bash
flutter create --platforms=android,ios .
flutter pub get
```

Puis :

```bash
flutter run
```

## Android APK

```bash
flutter build apk --release
```

L'APK sera généré dans :

`build/app/outputs/flutter-apk/app-release.apk`
