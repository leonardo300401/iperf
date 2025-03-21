#!/bin/bash

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

# 🔍 Controllo connessione Wi-Fi
termux-wifi-connectioninfo > "$DIR/WiFi_info.json"
echo "🟢 Info Wi-Fi salvate in WiFi_info.json"
cat "$DIR/WiFi_info.json"

# 🔁 Loop per ogni posizione
for (( count=1; count<=POSIZIONI; count++ ))
do
    echo "📍 Posizione $count: posizionati e premi ENTER per iniziare"
    read

    # 🔽 TEST DOWNLOAD
    echo "🟢 Inizio test di Download per la posizione $count..."
    echo "Test eseguito il $(date)" > "$DIR/Download_posizione${count}.csv"
    iperf3 -c $IP -t $TEMPO -P $PARALLEL -R >> "$DIR/Download_posizione${count}.csv"
    echo "✅ Download completato per posizione $count"
    cat "$DIR/Download_posizione${count}.csv"

    # 🔼 TEST UPLOAD
    echo "🟢 Inizio test di Upload per la posizione $count..."
    echo "Test eseguito il $(date)" > "$DIR/Upload_posizione${count}.csv"
    iperf3 -c $IP -t $TEMPO -P $PARALLEL >> "$DIR/Upload_posizione${count}.csv"
    echo "✅ Upload completato per posizione $count"
    cat "$DIR/Upload_posizione${count}.csv"
done

echo "✅ Test completato! Tutti i file sono salvati in: $DIR"
