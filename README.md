# 🅿️ Sistema de Controle de Estacionamento

> Sistema completo de gerenciamento de estacionamento desenvolvido em **Português Estruturado**, com controle de entrada/saída de veículos, múltiplos métodos de pagamento e relatórios financeiros.

---

## 📋 Resumo Técnico

**Linguagem:** Português Estruturado (VisuAlg/Similar)  
**Funcionalidades:** 7 operações principais  
**Estrutura de Dados:** Arrays paralelos com suporte a 20 vagas  
**Sistema de Pagamento:** 4 métodos (Dinheiro, PIX, Cartão, Plano Mensal)  
**Histórico:** Até 100 transações armazenadas

---

## 🔑 Funções Principais

### 1. **`login()`** - Autenticação com Limite de Tentativas
```
Complexidade: O(n) | Segurança: Média
```
**Funcionalidade:**
- Validação de credenciais com máximo 3 tentativas
- Bloqueio do sistema após 3 falhas
- Delay de 1.5s e 3s para feedback visual

**Parâmetros:** Nenhum  
**Retorno:** `logico` (verdadeiro/falso)

**Tecnologias:** Tratamento de exceção de acesso, controle de tentativas

---

### 2. **`registrar_entrada()`** - Alocação de Vaga
```
Complexidade: O(n) | Dependência: status_vaga[], placas[], modelo[]
```
**Funcionalidade:**
- Busca sequencial por primeira vaga livre (índice 0-19)
- Captura de dados: modelo, placa, hora de entrada
- Atualização de estado da vaga (falso → verdadeiro)
- Feedback visual com número da vaga

**Fluxo:**
```
Busca vaga livre → Captura dados → Atualiza array → Exibe confirmação
```

**Parâmetros:** Nenhum  
**Retorno:** Void (com efeito colateral em `status_vaga[]`)

---

### 3. **`registrar_saida()`** - Processamento de Saída e Cálculo de Tarifa
```
Complexidade: O(n) | Cálculo: Tempo - Tarifa - Pagamento
```
**Funcionalidade:**
- Busca veículo por placa (varredura linear de 20 posições)
- Cálculo de tempo estacionado: `hora_saida - hora_entrada`
- Invoca cálculo de tarifa via `calcular_valor_pagamento()`
- Inicializa fluxo de pagamento

**Fluxo:**
```
Busca placa → Valida presença → Captura hora saída → 
Calcula tempo → Calcula valor → Inicia pagamento → Libera vaga
```

**Parâmetros:** Nenhum  
**Retorno:** Void (com múltiplas modificações de estado)

---

### 4. **`calcular_valor_pagamento(tempo: real)`** - Lógica Tarifária
```
Complexidade: O(1) | Modelo: Tarifa fixa + variável por hora
```
**Funcionalidade:**
- Tarifa mínima: R$ 15,00 (até 1 hora)
- Tarifa adicional: R$ 15,00 por hora excedente
- Cálculo: `valor = 15 + (tempo - 1) × 15`

**Fórmula:**
```
Se tempo ≤ 1h → R$ 15,00
Se tempo > 1h → R$ 15,00 + (tempo - 1) × R$ 15,00
```

**Parâmetros:** `tempo: real`  
**Retorno:** `real` (valor em reais)

---

### 5. **`realizar_pagamento(vaga, valor_devido, placa)`** - Orquestrador de Pagamento
```
Complexidade: O(1) | Padrão: Strategy Pattern
```
**Funcionalidade:**
- Menu interativo com 4 opções de pagamento
- Despacho condicional para função específica de pagamento
- Loop até confirmação de pagamento
- Registro de transação após sucesso

**Fluxo de Controle:**
```
Exibe menu → Lê opção → Escolha (4 branches) → 
Executa estratégia → Valida retorno → Registra ou repete
```

**Métodos Suportados:**
- `pagamento_dinheiro()` - Validação de troco
- `pagamento_pix()` - Geração de código + confirmação
- `pagamento_cartao()` - Validação de 16 dígitos + CVV
- `pagamento_plano()` - Agregação mensal

**Parâmetros:** `inteiro vaga`, `real valor_devido`, `cadeia placa`  
**Retorno:** Void (com modificação de `valor_pg_*` globais)

---

### 6. **`pagamento_cartao(valor: real)`** - Validação de Cartão
```
Complexidade: O(1) | Validação: Tamanho + Data + CVV
```
**Funcionalidade:**
- Captura 16 dígitos do cartão
- Valida comprimento: `Tipos.tamanho() == 16`
- Captura mês, ano e CVV (3 dígitos)
- Simula aprovação e registra valor

**Validações:**
```
✓ Número do cartão = 16 caracteres exatamente
✓ Mês: 1-12 (sem validação no código)
✓ Ano: 4 dígitos (sem validação no código)
✓ CVV: 3 dígitos (sem validação no código)
```

**Parâmetros:** `real valor`  
**Retorno:** `logico` (verdadeiro após validação bem-sucedida)

---

### 7. **`exibir_historico_pagamentos()`** - Relatório de Transações
```
Complexidade: O(n) | Iteração: até 100 registros
```
**Funcionalidade:**
- Varredura de array histórico com 4 dimensões paralelas:
  - `historico_placa[]` - Identificação do veículo
  - `historico_valor[]` - Montante pago
  - `historico_metodo[]` - Tipo de pagamento
  - `historico_hora_saida[]` - Timestamp
- Formatação em tabela estruturada
- Tratamento de histórico vazio

**Estrutura de Exibição:**
```
┌─ Transação N ─────┐
│ Placa: ABC-1234   │
│ Valor: R$ XX,XX   │
│ Método: [Tipo]    │
│ Hora: HH:MM       │
└───────────────────┘
```

**Parâmetros:** Nenhum  
**Retorno:** Void (apenas exibição)

---

### 8. **`exibir_totais_pagamentos()`** - Agregação Financeira
```
Complexidade: O(1) | Somatório: 4 variáveis globais
```
**Funcionalidade:**
- Exibe saldo acumulado por método:
  - `valor_pg_dinheiro`
  - `valor_pg_pix`
  - `valor_pg_cartao`
  - `valor_pg_plano`
- Calcula e exibe total geral

**Parâmetros:** Nenhum  
**Retorno:** Void (apenas exibição)

---

### 9. **`mostrar_vagas_ocupadas()`** - Status de Ocupação
```
Complexidade: O(n) | Iteração: 20 vagas
```
**Funcionalidade:**
- Varredura de array `status_vaga[]`
- Exibição formatada de vagas ocupadas
- Cálculo de ocupação: `total_ocupadas / 20`
- Cálculo de disponibilidade: `20 - total_ocupadas`

**Parâmetros:** Nenhum  
**Retorno:** Void (apenas exibição)

---

## 📊 Estruturas de Dados

### Arrays Paralelos (Veículos)
```
| Índice | placas[i] | modelo[i] | hora_entrada[i] | hora_saida[i] | status_vaga[i] |
|--------|-----------|-----------|-----------------|----------------|----------------|
| 0-19   | String    | String    | Float           | Float          | Boolean        |
```

### Arrays Paralelos (Histórico)
```
| Índice | historico_placa[i] | historico_valor[i] | historico_metodo[i] | historico_hora_saida[i] |
|--------|--------------------|--------------------|---------------------|-------------------------|
| 0-99   | String             | Float              | String              | Float                   |
```

### Variáveis Globais (Agregação Financeira)
```
valor_pg_dinheiro  = 0.0   (∑ pagamentos em dinheiro)
valor_pg_pix       = 0.0   (∑ pagamentos em PIX)
valor_pg_cartao    = 0.0   (∑ pagamentos em cartão)
valor_pg_plano     = 0.0   (∑ pagamentos em plano mensal)
```

---

## 🔄 Fluxo Principal

```
┌─────────────────────────────────────────────┐
│ INÍCIO                                      │
└────────────────┬────────────────────────────┘
                 │
                 ▼
        ┌────────────────┐
        │   login()      │ ◄─── 3 tentativas
        └────────┬───────┘
                 │ Sucesso?
        ┌────────▼────────┐
        │ Menu Principal  │
        │ (Opcões 1-7)    │
        └────────┬────────┘
                 │
      ┌──────────┼──────────┐
      │          │          │
      ▼          ▼          ▼
  [1]entrada  [2]saida   [3]status
      │          │          │
      ▼          ▼          ▼
  registrar_   registrar_  mostrar_
  entrada()    saida()     vagas()
                  │
                  ▼
          calcular_valor_
          pagamento()
                  │
                  ▼
           realizar_
           pagamento()
                  │
         ┌────────┼────────┬──────────┐
         ▼        ▼        ▼          ▼
      pag_$    pag_pix  pag_cartao  pag_plano
         │        │        │          │
         └────────┼────────┴──────────┘
                  │
                  ▼
          registrar_
          transacao()
                  │
                  ▼
          [Histórico atualizado]
```

---

## 🎯 Características Técnicas

### Validações Implementadas
- ✅ Limite de 3 tentativas de login
- ✅ Busca por vaga disponível (FIFO)
- ✅ Busca por placa (linear search)
- ✅ Validação de tamanho de cartão (16 dígitos)
- ✅ Verificação de valor suficiente (dinheiro)
- ✅ Verificação de limite de histórico (100 transações)

### Padrões de Design
- **Strategy Pattern** - Múltiplos métodos de pagamento
- **Observer Pattern** - Sistema de notificação (feedback visual)
- **Array Pattern** - Estrutura paralela para dados relacionados

### Complexidade Computacional
| Função | Complexidade | Causa |
|--------|-------------|-------|
| `login()` | O(1) | Tentativas fixas (3) |
| `registrar_entrada()` | O(n) | Busca sequencial (20 vagas) |
| `registrar_saida()` | O(n) | Busca por placa (20 vagas) |
| `calcular_valor_pagamento()` | O(1) | Cálculo aritmético |
| `exibir_historico_pagamentos()` | O(n) | Iteração 0-100 transações |
| `exibir_totais_pagamentos()` | O(1) | 4 operações fixas |

---

## 💾 Limitações Conhecidas

- ⚠️ Máximo 20 vagas (array fixo)
- ⚠️ Máximo 100 transações (histórico fixo)
- ⚠️ Sem persistência em disco/banco de dados
- ⚠️ Sem validação completa de cartão (data não é verificada)
- ⚠️ Sem criptografia de dados sensíveis
- ⚠️ Sem auditoria de tentativas de login falhadas

---

## 🚀 Possíveis Melhorias

- [ ] Implementar banco de dados SQL
- [ ] Adicionar autenticação com hash de senha
- [ ] Validar data de validade do cartão
- [ ] Implementar sistema de auditoria
- [ ] Adicionar persistência de dados
- [ ] Criar API REST para integração
- [ ] Implementar relatórios avançados (período, comparativos)
- [ ] Adicionar suporte a backup automático

---

## 📝 Exemplo de Uso

```
1. Login com sucesso
2. Registrar entrada: ABC-1234, Carro, 14:00
3. Registrar saída: ABC-1234, 16:30
   ├─ Tempo: 2,5 horas
   ├─ Valor: R$ 37,50
   └─ Pagar via Cartão
4. Exibir histórico
5. Exibir totais
```

---

**Status:** ✅ Funcional | **Versão:** 1.0 | **Atualizado:** 2024

