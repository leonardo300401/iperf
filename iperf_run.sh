#!/bin/bash

# Crea un timestamp per i file di output
timestamp=$(date +"%H.%M.%S")

# Chiedi all'utente i parametri di test
read -p "Aggiungi il modello testato ed eventuali note (senza spazi): " DUT
read -p "Scrivi quante posizioni testare: " posizioni
read -p "Imposta il tempo di campionamento per ogni posizione (secondi): " tempo
read -p "Aggiungi l'IP della CPE: " IP

# Crea la cartella per i risultati
mkdir -p "${DUT}_${timestamp}"

echo "Ora comincia il test di wifi performance."
sleep 2
clear

count=0
while [ "$count" -lt "$posizioni" ]; do
    count=$((count+1))

    read -p "Posizionati per Posizione n. $count e premi Invio..."

    echo "Test di Download in esecuzione..."
    echo "Il test è stato eseguito il $(date)" >> "${DUT}_${timestamp}/Download_posizione${count}.csv"
    termux-wifi-connectioninfo >> "${DUT}_${timestamp}/Download_posizione${count}.csv"

    iperf3 -c "$IP" -t "$tempo" -P 4 -R >> "${DUT}_${timestamp}/Download_posizione${count}.csv"

    echo "Test di Upload in esecuzione..."
    echo "Il test è stato eseguito il $(date)" >> "${DUT}_${timestamp}/Upload_posizione${count}.csv"
    termux-wifi-connectioninfo >> "${DUT}_${timestamp}/Upload_posizione${count}.csv"

    iperf3 -c "$IP" -t "$tempo" -P 4 >> "${DUT}_${timestamp}/Upload_posizione${count}.csv"

    echo "Download/Upload nella posizione n.$count completato"
    sleep 2
    clear
done

echo "Test finito!"
