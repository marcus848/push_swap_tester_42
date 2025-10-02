# Push_Swap Tester

Um script em **bash** para testar a eficiência e a correção do seu projeto `push_swap`, utilizando o `checker` da 42.  
Ele executa várias rodadas com números aleatórios, mede a quantidade de movimentos, valida o resultado no `checker` e gera métricas (melhor, pior, média, etc).  

---

## 🔧 Instalação

#### Opção 1: Clonar o repositório

```bash
   git clone https://github.com/marcus848/push_swap_tester_42.git
   cd push_swap_tester_42
   chmod +x tester.sh
```
#### Opção 2: Baixar apenas o tester.sh

Você pode baixar somente o script pelo link direto do GitHub:

- Com curl:
```bash
curl -o tester.sh https://raw.githubusercontent.com/marcus848/push_swap_tester_42/main/tester.sh
chmod +x tester.sh
```

- Com wget:
```bash
wget -O tester.sh https://raw.githubusercontent.com/marcus848/push_swap_tester_42/main/tester.sh
chmod +x tester.sh
```
---
- OBS: Certifique-se de que os binários estão presentes:

   * `./push_swap`
   * `./checker_linux` **ou** `./checker_OS`

---

## ▶️ Uso

Rodar com os parâmetros padrão (100 testes, 500 números, limite 5500 movimentos):

```bash
./tester.sh
```

### Opções

| Flag | Descrição                           | Padrão |
| ---- | ----------------------------------- | ------ |
| `-t` | Número de testes a rodar            | `100`  |
| `-n` | Quantidade de números em cada teste | `500`  |
| `-m` | Máximo de movimentos aceitáveis     | `5500` |
| `-h` | Mostra ajuda                        | —      |

---

## 📌 Exemplos

```bash
./tester.sh -t 100 -n 100 -m 700
```

👉 Roda 100 testes com 100 números cada, limite de 700 movimentos.

```bash
./tester.sh -h
```

👉 Mostra a tela de ajuda.

---

## 📊 Saída

Para cada teste, o script mostra:

* **OK** (verde) se o `checker` validar a ordenação.
* **KO** (vermelho) se o resultado estiver incorreto, junto com os números que causaram falha.
* Se for **OK** mas acima do limite de movimentos, o número de instruções aparece em **vermelho**.

No final, exibe:

* Melhor resultado (menor número de instruções)
* Pior resultado (maior número de instruções)
* Média de movimentos (apenas para casos OK)
* Quantidade de casos acima do limite
* Lista de casos `KO` salva em `fails_push_swap.txt`

---

## 📝 Notas

* Por padrão, os números são sorteados no intervalo `[-100000, 100000]`.
* O script espera encontrar `checker_linux` ou `checker_Mac` no mesmo diretório.
* Casos `KO` salvam os números de entrada no arquivo `fails_push_swap.txt` para posterior reprodução.

---

## 🎨 Exemplo de saída

```
Testando push_swap 5 vezes com 100 números aleatórios...
Usando checker: ./checker_linux
Faixa aleatória: [-100000, 100000]

Teste 1: OK — 4578 instruções
Teste 2: OK — 6012 instruções   <- acima do limite, em vermelho
Teste 3: KO — 1234 instruções
Números que causaram KO: 3 0 1 255
--------------------------------------
...
======================================
Total OK: 4 | Total KO: 1
Melhor (OK): 3890 instruções
Pior (OK): 6012 instruções
Acima de 5500 movimentos (OK): 1
Média (OK): 4895.5 instruções
Casos com KO salvos em: fails_push_swap.txt
```

---

## 🔁 Reproduzindo um KO salvo

Se quiser reproduzir um caso salvo em `fails_push_swap.txt`, copie a linha dos números e rode:

```bash
./push_swap <numeros> | ./checker_linux <numeros>
```

Exemplo (linha salva foi `3 0 1 255`):

```bash
./push_swap 3 0 1 255 | ./checker_linux 3 0 1 255
```

Assim você pode debugar manualmente o que aconteceu.

---

⚡ Agora é só rodar e avaliar se o seu `push_swap` está dentro dos limites exigidos pela 42!

