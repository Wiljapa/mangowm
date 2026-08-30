#!/bin/bash

LOG="/tmp/mango_menu.log"
ARQUIVO_TEMP="/tmp/wofi_escolha.txt"

echo "=== NOVO CLIQUE ===" > $LOG

export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:~/.cargo/bin

MENU="Tile\nScroller\nMonocle\nGrid\nFair\nDeck\nDwindle\nCenter Tile\nVertical Tile"

# Limpa o arquivo temporário antigo, se existir
> $ARQUIVO_TEMP

# Executa o Wofi e joga o resultado direto para o arquivo físico em vez da memória
#echo -e "$MENU" | wofi --show dmenu --prompt "Escolha o Layout" --lines 10 --width 300 > $ARQUIVO_TEMP
#echo -e "$MENU" | wofi --show dmenu --prompt "Layout" --lines 9 --width 200 --style ~/.local/state/noctalia/plugins/materialized/wil/mango_layout/menu.css > $ARQUIVO_TEMP
# Descobre a pasta atual onde este script bash está salvo
DIR_ATUAL=$(dirname "$0")

# Executa o Wofi apontando o CSS para essa mesma pasta
echo -e "$MENU" | wofi --show dmenu --prompt "Layout" --lines 9 --width 200 --style "$DIR_ATUAL/menu.css" > $ARQUIVO_TEMP

# Lê o arquivo
ESCOLHA=$(cat $ARQUIVO_TEMP)
echo "Opção selecionada no Wofi: '$ESCOLHA'" >> $LOG

if [ -z "$ESCOLHA" ]; then
    echo "Nenhuma escolha, abortando." >> $LOG
    exit 0
fi

case "$ESCOLHA" in
    "Tile")          CMD="setlayout, tile" ;;
    "Scroller")      CMD="setlayout, scroller" ;;
    "Monocle")       CMD="setlayout, monocle" ;;
    "Grid")          CMD="setlayout, grid" ;;
    "Fair")          CMD="setlayout, fair" ;;
    "Deck")          CMD="setlayout, deck" ;;
    "Dwindle")       CMD="setlayout, dwindle" ;;
    "Center Tile")   CMD="setlayout, center_tile" ;;
    "Vertical Tile") CMD="setlayout, vertical_tile" ;;
    *)               echo "Opção não reconhecida! ($ESCOLHA)" >> $LOG; exit 1 ;;
esac

echo "Tentando executar: mmsg dispatch \"$CMD\"" >> $LOG
mmsg dispatch "$CMD" >> $LOG 2>&1
echo "Comando enviado!" >> $LOG
