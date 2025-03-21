#!/bin/bash

# Imposta l'indirizzo IP del server iperf
SERVER_IP="192.168.1.21"

# Durata del test in secondi
DURATION=10

# Comando per eseguire il test di velocità con iperf3
echo "🔄 Avvio test iperf3 verso $SERVER_IP per $DURATION secondi..."
iperf3 -c "$SERVER_IP" -t "$DURATION"

# Controlla se il comando è andato a buon fine
if [ $? -eq 0 ]; then
    echo "✅ Test completato con successo!"
else
    echo "❌ Errore durante l'esecuzione di iperf3!"
fi