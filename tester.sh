#!/bin/bash
# Tester para push_swap com checker, parâmetros customizáveis e help colorido

# ===== Detecta checker =====
if [[ -x ./checker_linux ]]; then
  CHECKER=./checker_linux
elif [[ -x ./checker_Mac ]]; then
  CHECKER=./checker_Mac
else
  echo "ERRO: checker não encontrado (checker_linux / checker_Mac)."
  exit 1
fi

# ===== Cores =====
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
RESET="\033[0m"

# ===== Valores padrão =====
num_tests=100
numbers=500
max_movements=5500
range_min=-100000
range_max=100000

# ===== Função de ajuda =====
usage() {
  echo -e "${CYAN}Uso:${RESET} $0 [opções]"
  echo
  echo -e "${CYAN}Opções:${RESET}"
  echo -e "  ${YELLOW}-t${RESET}   Número de testes a rodar ${GREEN}(padrão: $num_tests)${RESET}"
  echo -e "  ${YELLOW}-n${RESET}   Quantidade de números em cada teste ${GREEN}(padrão: $numbers)${RESET}"
  echo -e "  ${YELLOW}-m${RESET}   Máximo de movimentos aceitáveis ${GREEN}(padrão: $max_movements)${RESET}"
  echo -e "  ${YELLOW}-h${RESET}   Mostra esta ajuda"
  echo
  echo -e "${CYAN}Exemplos:${RESET}"
  echo -e "  ${GREEN}./tester.sh${RESET}"
  echo -e "     → Roda com os padrões (100 testes, 500 números, limite 5500)"
  echo
  echo -e "  ${GREEN}./tester.sh -t 50 -n 200 -m 4000${RESET}"
  echo -e "     → Roda 50 testes com 200 números, limite de 4000 movimentos"
  echo
  echo -e "  ${GREEN}./tester.sh -h${RESET}"
  echo -e "     → Mostra este menu de ajuda"
  echo
  exit 0
}

# ===== Parse argumentos =====
while getopts "t:n:m:h" opt; do
  case $opt in
    t) num_tests=$OPTARG ;;
    n) numbers=$OPTARG ;;
    m) max_movements=$OPTARG ;;
    h) usage ;;
    *) usage ;;
  esac
done

# ===== Métricas =====
best=999999999
worst=0
sum=0
count_ok=0
count_ko=0
count_above_error=0
fails_file="fails_push_swap.txt"
> "$fails_file"

echo -e "${BLUE}Testando push_swap $num_tests vezes com $numbers números aleatórios...${RESET}"
echo "Usando checker: $CHECKER"
echo "Faixa aleatória: [$range_min, $range_max]"

for ((i = 1; i <= num_tests; i++)); do
  ARG=$(seq "$range_min" "$range_max" | shuf -n "$numbers")

  INSTRUCTIONS_OUTPUT=$(./push_swap $ARG)
  if [[ -z "$INSTRUCTIONS_OUTPUT" ]]; then
    INSTRUCTIONS_COUNT=0
  else
    INSTRUCTIONS_COUNT=$(wc -l <<< "$INSTRUCTIONS_OUTPUT")
  fi

  # === CHAMADA DO CHECKER ===
  if (( INSTRUCTIONS_COUNT == 0 )); then
    # Lista já ordenada? Envia EOF (sem interativo)
    CHECK_RESULT=$("$CHECKER" $ARG </dev/null 2>/dev/null)
    # Alternativa: no-op explícito
    # CHECK_RESULT=$(printf "sa\nsa\n" | "$CHECKER" $ARG 2>/dev/null)
  else
    CHECK_RESULT=$(printf "%s\n" "$INSTRUCTIONS_OUTPUT" | "$CHECKER" $ARG 2>/dev/null)
  fi

  [[ -z "$CHECK_RESULT" ]] && CHECK_RESULT="KO"

  if [[ "$CHECK_RESULT" == "OK" ]]; then
    ((count_ok++))
    (( INSTRUCTIONS_COUNT < best )) && best=$INSTRUCTIONS_COUNT
    (( INSTRUCTIONS_COUNT > worst )) && worst=$INSTRUCTIONS_COUNT
    sum=$((sum + INSTRUCTIONS_COUNT))
    (( INSTRUCTIONS_COUNT > max_movements )) && ((count_above_error++))
    if (( INSTRUCTIONS_COUNT > max_movements )); then
      echo -e "Teste $i: ${GREEN}OK${RESET} — ${RED}$INSTRUCTIONS_COUNT instruções${RESET}"
    else
      echo -e "Teste $i: ${GREEN}OK${RESET} — $INSTRUCTIONS_COUNT instruções"
    fi
  else
    ((count_ko++))
    echo -e "Teste $i: ${RED}KO${RESET} — $INSTRUCTIONS_COUNT instruções"
    echo -e "${RED}Números que causaram KO:${RESET} $ARG"
    echo "ARG (falha): $ARG" >> "$fails_file"
    echo "--------------------------------------"
  fi
done

# Média só dos OK
if (( count_ok > 0 )); then
  media=$(awk "BEGIN {print $sum / $count_ok}")
else
  media=0
fi

echo "======================================"
echo -e "Total OK: ${GREEN}$count_ok${RESET} | Total KO: ${RED}$count_ko${RESET}"
echo "Melhor (OK): $best instruções"
echo "Pior (OK): $worst instruções"
echo "Acima de $max_movements movimentos (OK): $count_above_error"
echo "Média (OK): $media instruções"
if (( count_ko > 0 )); then
  echo -e "${YELLOW}Casos com KO salvos em: $fails_file${RESET}"
fi

