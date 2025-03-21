#!/bin/bash

# Definisci i file di output
RAW_OUTPUT_FILE="iperf_output.json"
CSV_OUTPUT_FILE="iperf_results.csv"

# Esegui il test e salva tutto l'output JSON
iperf3 -c 192.168.1.21 -t 10 -J > "$RAW_OUTPUT_FILE"

# Se il CSV non esiste, crea l'intestazione
if [ ! -f "$CSV_OUTPUT_FILE" ]; then
    echo "Timestamp,Transfer (MB),Bandwidth (Mbit/s)" > "$CSV_OUTPUT_FILE"
fi

# Estrai i dati principali dal JSON e scrivili nel CSV
jq -r '
    .end.sum_sent | 
    [.start.timestamp.timesecs, .bytes/1048576, .bits_per_second/1000000] |
    @csv' "$RAW_OUTPUT_FILE" >> "$CSV_OUTPUT_FILE"

# Messaggio di conferma
echo "✅ Test completato! Output JSON salvato in $RAW_OUTPUT_FILE"
echo "✅ Risultati principali salvati in $CSV_OUTPUT_FILE"
