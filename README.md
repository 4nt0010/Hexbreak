# Hexbreak 🧙‍♀️

Una strega che vive nella Dynamic Island e ti costringe a fare pause, con mini-giochi per riposare.

## Cosa c'è dentro

- **Dynamic Island / Live Activity**: timer della sessione, umore della strega (contenta, sospettosa, furiosa, addormentata) e pulsanti *Pausa*, *+10 min* e *Torno al lavoro*.
- **Schermata di blocco**: stessa scheda con barra di avanzamento.
- **Mini-giochi**: Respiro del calderone, Memory delle rune.
- **Bottino**: ingredienti guadagnati con le pause e i mini-giochi.
- **Notifiche locali** quando il tempo scade.

Requisiti: iOS 17 o successivo. La Dynamic Island si vede da iPhone 14 Pro in su; sugli altri modelli la scheda appare nella schermata di blocco.

## 1. Compilare l'app con GitHub (gratis, niente Mac)

1. Crea un account su github.com e un nuovo repository **pubblico** chiamato `Hexbreak` (i repository pubblici hanno minuti di build macOS gratuiti).
2. Clicca **Add file › Upload files** e trascina dentro tutto il contenuto della cartella `Hexbreak` (non la cartella stessa). Poi **Commit changes**.
3. Controlla che esista il file `.github/workflows/build.yml`. Se il caricamento ha saltato la cartella nascosta, crealo con **Add file › Create new file**, scrivendo come nome `.github/workflows/build.yml` e incollando il contenuto.
4. Vai nella scheda **Actions**: la build parte da sola (circa 5 minuti).
5. A build verde, apri l'esecuzione e scarica l'artefatto **Hexbreak-ipa**: è uno zip con dentro `Hexbreak.ipa`.

## 2. Installarla sull'iPhone con SideStore

1. Installa SideStore seguendo la guida ufficiale su sidestore.io (la prima volta serve un computer per qualche minuto, va bene anche Windows).
2. Manda `Hexbreak.ipa` sull'iPhone (AirDrop, iCloud Drive, email…), aprilo con **Condividi › SideStore** oppure da SideStore › **+**.
3. Accedi con il tuo Apple ID quando te lo chiede: SideStore firma l'app per il tuo telefono.
4. Su iPhone vai in **Impostazioni › Generali › VPN e gestione dispositivo** e autorizza il tuo profilo sviluppatore, se richiesto.
5. Apri Hexbreak, consenti le notifiche e avvia una sessione. Esci dall'app: la strega è nella Dynamic Island.

Con un Apple ID gratuito l'app scade dopo 7 giorni: SideStore la rinnova in automatico quando sei sul Wi-Fi.

## Personalizzare

- Battute della strega: `Shared/WitchLines.swift`
- Logica di sessioni e umore: `Shared/HexbreakController.swift`
- Aspetto della Dynamic Island: `Widget/HexbreakLiveActivity.swift`
- Mini-giochi: `App/Games/`

Ogni modifica caricata su GitHub fa ripartire la build da sola.

## Limiti noti

- L'umore della strega cambia quando premi i pulsanti o riapri l'app; con l'app chiusa iOS non permette aggiornamenti automatici senza un server push. Allo scadere del tempo arriva comunque la notifica.
- Una Live Activity resta attiva al massimo circa 8 ore.
