#!/bin/bash

#!/bin/bash

# 🔓 Rendi lo script eseguibile automaticamente (se non lo è già)
if [ ! -x "$0" ]; then
    chmod +x "$0"
    echo "✅ Permessi di esecuzione assegnati a $0"
fi


# 🟢 Chiedi il nome del dispositivo e altre info
read -p "📌 Inserisci il nome del dispositivo testato: " DUT
read -p "📌 Quante posizioni vuoi testare? " POSIZIONI
read -p "📌 Tempo di campionamento (secondi)? " TEMPO
read -p "📌 Inserisci l'IP del server iperf3: " IP

PARALLEL=4  # Numero di flussi paralleli

# 📌 Crea una cartella con il nome del dispositivo e timestamp
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
DIR="${DUT}_${timestamp}"
mkdir -p "$DIR"

echo "🟢 Cartella creata: $DIR"

# 📡 Salva le informazioni sulla connessione WiFi
echo "🔍 Raccolta informazioni WiFi..."
termux-wifi-connectioninfo > "$DIR/WiFi_info.json"

# 📝 Controllo se il file WiFi_info.json è stato generato
if [ -f "$DIR/WiFi_info.json" ]; then
    echo "✅ Informazioni WiFi salvate in WiFi_info.json"
    cat "$DIR/WiFi_info.json"
else
    echo "❌ Errore: il file WiFi_info.json non è stato creato!"
fi

# 🔁 Loop per ogni posizione
for (( count=1; count<=POSIZIONI; count++ ))
do
    echo "📍 Posizione $count: posizionati e premi ENTER per iniziare"
    read

    # 🔽 TEST DOWNLOAD
    echo "🟢 Inizio test di Download per la posizione $count..."
    echo "Test eseguito il $(date)" > "$DIR/Download_posizione${count}.csv"
    iperf3 -c $IP -t $TEMPO -P $PARALLEL -R >> "$DIR/Download_posizione${count}.csv"

    if [ $? -eq 0 ]; then
        echo "✅ Download completato per posizione $count"
        cat "$DIR/Download_posizione${count}.csv"
    else
        echo "❌ Errore durante il test di Download!"
    fi

    # 🔼 TEST UPLOAD
    echo "🟢 Inizio test di Upload per la posizione $count..."
    echo "Test eseguito il $(date)" > "$DIR/Upload_posizione${count}.csv"
    iperf3 -c $IP -t $TEMPO -P $PARALLEL >> "$DIR/Upload_posizione${count}.csv"

    if [ $? -eq 0 ]; then
        echo "✅ Upload completato per posizione $count"
        cat "$DIR/Upload_posizione${count}.csv"
    else
        echo "❌ Errore durante il test di Upload!"
    fi
done

echo "✅ Test completato! Tutti i file sono salvati in: $DIR"

# 📂 DESTINAZIONE dei file sulla memoria interna accessibile
DEST_PATH="/sdcard/iperf_results"

# 📁 Crea la cartella se non esiste
mkdir -p "$DEST_PATH"

# 🚀 Sposta i file nella memoria accessibile
mv "$DIR" "$DEST_PATH/"

# 📝 Verifica che lo spostamento sia riuscito
if [ -d "$DEST_PATH/$DIR" ]; then
    echo "✅ I file sono stati salvati in: $DEST_PATH/$DIR"
else
    echo "❌ Errore durante lo spostamento dei file!"
fi
