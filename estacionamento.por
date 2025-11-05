programa {
    inclua biblioteca Tipos --> tp
    inclua biblioteca Util


  // ===== VARIÁVEIS GLOBAIS =====
  cadeia placas[20]
  cadeia modelo[20]
  real hora_entrada[20]
  real hora_saida[20]
  logico status_vaga[20]
  real preco_hora = 15.00
  inteiro vg_livre = 0

  // ===== VARIÁVEIS DE PAGAMENTO =====
  real valor_pg_dinheiro = 0.0
  real valor_pg_pix = 0.0
  real valor_pg_cartao = 0.0
  real valor_pg_plano = 0.0

  // ===== ARRAYS PARA HISTÓRICO DE PAGAMENTOS =====
  inteiro indice_historico = 0
  cadeia historico_placa[100]
  real historico_valor[100]
  cadeia historico_metodo[100]
  real historico_hora_saida[100]

  // ===== FUNÇÃO PRINCIPAL =====
  funcao inicio() {
    inteiro opcao_menu
    caracter op
    logico usuario_logado = falso

    limpa()
    escreva("╔════════════════════════════════╗\n")
    escreva("║     SISTEMA DE LOGIN           ║\n")
    escreva("╚════════════════════════════════╝\n")

    usuario_logado = login()

    se(usuario_logado == falso){
      escreva("\n❌ Acesso negado! Sistema encerrado.\n")
      retorne
    }

    para(inteiro i = 0; i < 20; i++){
      status_vaga[i] = falso
    }

    faca{
      escreva("╔════════════════════════════════╗\n")
      escreva("║    BEM VINDO AO SISTEMA        ║\n")
      escreva("║   CONTROLE DE ESTACIONAMENTO   ║\n")
      escreva("╚════════════════════════════════╝\n")
      escreva("[1] Registrar entrada de veículos\n")
      escreva("[2] Registrar saída de veículos\n")
      escreva("[3] Mostrar vagas ocupadas\n")
      escreva("[4] Métodos de pagamento\n")
      escreva("[5] Ver histórico de pagamentos\n")
      escreva("[6] Ver totais por método\n")
      escreva("[7] Sair do Programa\n")
      escreva("════════════════════════════════\n")
      escreva("Opção: ")
      leia(opcao_menu)
      limpa()

      escolha(opcao_menu){
        caso 1:
          registrar_entrada()
          pare
        caso 2:
          registrar_saida()
          pare
        caso 3:
          mostrar_vagas_ocupadas()
          pare
        caso 4:
          escreva("Opção indisponível neste menu.\n")
          pare
        caso 5:
          exibir_historico_pagamentos()
          pare
        caso 6:
          exibir_totais_pagamentos()
          pare
        caso 7:
          escreva("✅ Saindo do Sistema...\n")
          pare
        caso contrario:
          escreva("❌ Opção inválida!\n")
      }

      se(opcao_menu != 7){
        escreva("\nPressione ENTER para continuar...")
        leia(op)
        limpa()
      }

    }enquanto(opcao_menu != 7)
  }

  // ===== FUNÇÃO DE LOGIN =====
  funcao logico login(){
    logico logado = falso
    inteiro tentativas = 0
    cadeia usuario, senha

    faca{
      escreva("Digite o usuário: ")
      leia(usuario)
      escreva("Digite a senha: ")
      leia(senha)
      tentativas++

      se(senha == "123456"){
        escreva("\n❌ Acesso negado! Você ainda tem ", 3 - tentativas, " tentativa(s)\n\n")
        logado = falso
      }
      senao{ 
        escreva("\n✅ Login realizado com sucesso!\n")
        logado = verdadeiro
        Util.aguarde(1500)
        limpa()
      }
    }enquanto(logado == falso e tentativas < 3)

    se(logado == falso){
      limpa()
      escreva("\n🔒 Suas tentativas acabaram! Sistema encerrado.\n")
      Util.aguarde(3000)
    }

    retorne logado  
  }

  // ===== FUNÇÃO PARA REGISTRAR ENTRADA =====
  funcao registrar_entrada(){
    inteiro vaga_livre_local = -1

    para(inteiro i = 0; i < 20; i++){
      se(status_vaga[i] == falso){
        vaga_livre_local = i
        pare
      }
    }

    se(vaga_livre_local == -1){
      escreva("❌ Estacionamento lotado!\n")
    }
    senao{
      escreva("✅ Vaga encontrada: ", vaga_livre_local + 1, "\n\n")

      escreva("Modelo (carro ou moto): ")
      leia(modelo[vaga_livre_local])

      escreva("Informe a placa: ") 
      leia(placas[vaga_livre_local])
      
      escreva("Hora de entrada (ex: 14.5): ")
      leia(hora_entrada[vaga_livre_local])

      status_vaga[vaga_livre_local] = verdadeiro
      vg_livre = vaga_livre_local

      escreva("\n✅ Veículo registrado com sucesso na vaga ", vaga_livre_local + 1, "!\n")
    }
    mostrar_vagas_ocupadas()
  }

  // ===== FUNÇÃO PARA REGISTRAR SAÍDA =====
  funcao registrar_saida(){
    mostrar_vagas_ocupadas()

    cadeia placa_busca
    inteiro posicao_encontrada = -1

    escreva("\nDigite a placa do veículo que está saindo: ")
    leia(placa_busca)

    para(inteiro i = 0; i < 20; i++){
      se(status_vaga[i] == verdadeiro e placas[i] == placa_busca){
        posicao_encontrada = i
        pare
      }
    }

    se(posicao_encontrada == -1){
      escreva("❌ Veículo não encontrado!\n")
    }
    senao{
      escreva("\n✅ Veículo encontrado na vaga ", posicao_encontrada + 1, "\n")
      escreva("Modelo: ", modelo[posicao_encontrada], "\n")
      escreva("Hora entrada: ", hora_entrada[posicao_encontrada], "\n")

      escreva("Hora de saída (ex: 16.5): ")
      leia(hora_saida[posicao_encontrada])

      real tempo_estacionado = hora_saida[posicao_encontrada] - hora_entrada[posicao_encontrada]
      real valor_devido = calcular_valor_pagamento(tempo_estacionado)

      escreva("\n💰 Tempo estacionado: ", tempo_estacionado, " horas\n")
      escreva("💰 Valor devido: R$ ", valor_devido, "\n")

      realizar_pagamento(posicao_encontrada, valor_devido, placa_busca)

      status_vaga[posicao_encontrada] = falso
      escreva("\n✅ Saída registrada com sucesso!\n")
    }
  }

  // ===== FUNÇÃO PARA CALCULAR VALOR =====
  funcao real calcular_valor_pagamento(real tempo){
    real valor = 0.0
    
    se(tempo <= 1.0){
      valor = 15.00
    }
    senao{
      valor = 15.00 + ((tempo - 1.0) * preco_hora)
    }

    retorne valor
  }

  // ===== FUNÇÃO PARA REALIZAR PAGAMENTO =====
  funcao realizar_pagamento(inteiro vaga, real valor_devido, cadeia placa){
    inteiro opcao_pagamento = 0
    cadeia metodo_selecionado = ""
    logico pagamento_confirmado = falso

    faca{
      escreva("\n╔════════════════════════════════╗\n")
      escreva("║     MÉTODO DE PAGAMENTO        ║\n")
      escreva("╚════════════════════════════════╝\n")
      escreva("[1] 💵 Dinheiro\n")
      escreva("[2] 📱 PIX\n")
      escreva("[3] 💳 Cartão de Crédito\n")
      escreva("[4] 📅 Plano Mensal\n")
      escreva("════════════════════════════════\n")
      escreva("Escolha o método: ")
      leia(opcao_pagamento)
      limpa()

      escolha(opcao_pagamento){
        caso 1:
          pagamento_confirmado = pagamento_dinheiro(valor_devido)
          metodo_selecionado = "Dinheiro"
          pare
        caso 2:
          pagamento_confirmado = pagamento_pix(valor_devido)
          metodo_selecionado = "PIX"
          pare
        caso 3:
          pagamento_confirmado = pagamento_cartao(valor_devido)
          metodo_selecionado = "Cartão"
          pare
        caso 4:
          pagamento_confirmado = pagamento_plano(valor_devido)
          metodo_selecionado = "Plano Mensal"
          pare
        caso contrario:
          escreva("❌ Opção inválida!\n")
      }

      se(pagamento_confirmado){
        registrar_transacao(placa, valor_devido, metodo_selecionado, hora_saida[vaga])
      }

    }enquanto(pagamento_confirmado == falso)
  }

  // ===== PAGAMENTO EM DINHEIRO =====
  funcao logico pagamento_dinheiro(real valor){
    real valor_recebido = 0.0
    real troco = 0.0

    escreva("💵 PAGAMENTO EM DINHEIRO\n")
    escreva("Valor devido: R$ ", valor, "\n")
    escreva("Valor recebido: R$ ")
    leia(valor_recebido)

    se(valor_recebido < valor){
      escreva("❌ Valor insuficiente! Faltam R$ ", valor - valor_recebido, "\n")
      retorne falso
    }
    senao{
      troco = valor_recebido - valor
      escreva("\n✅ Pagamento aceito!\n")
      escreva("Troco: R$ ", troco, "\n")
      valor_pg_dinheiro = valor_pg_dinheiro + valor
      retorne verdadeiro
    }
  }

  // ===== PAGAMENTO COM PIX =====
  funcao logico pagamento_pix(real valor){
    cadeia codigo_pix = ""
    inteiro confirmacao = 0

    escreva("📱 PAGAMENTO COM PIX\n")
    escreva("Valor: R$ ", valor, "\n\n")
    escreva("Código PIX gerado: ", gerar_codigo_pix(), "\n\n")
    escreva("Pagamento confirmado? [1]Sim [2]Não: ")
    leia(confirmacao)

    se(confirmacao == 1){
      escreva("\n✅ Pagamento PIX confirmado!\n")
      valor_pg_pix = valor_pg_pix + valor
      retorne verdadeiro
    }
    senao{
      escreva("\n❌ Pagamento não confirmado.\n")
      retorne falso
    }
  }

  // ===== PAGAMENTO COM CARTÃO =====
  funcao logico pagamento_cartao(real valor){
    cadeia numero_cartao = ""
    inteiro mes = 0, ano = 0
    cadeia cvv = ""

    escreva("💳 PAGAMENTO COM CARTÃO\n")
    escreva("Valor: R$ ", valor, "\n\n")
    escreva("Número do cartão (16 dígitos): ")
    leia(numero_cartao)

    se(Tipos.tamanho(numero_cartao) != 16){
      escreva("❌ Cartão inválido!\n")
      retorne falso
    }

    escreva("Mês de validade: ")
    leia(mes)
    escreva("Ano de validade: ")
    leia(ano)
    escreva("CVV (3 dígitos): ")
    leia(cvv)

    escreva("\n✅ Cartão validado!\n")
    escreva("Pagamento de R$ ", valor, " aprovado!\n")
    valor_pg_cartao = valor_pg_cartao + valor
    retorne verdadeiro
  }

  // ===== PAGAMENTO COM PLANO MENSAL =====
  funcao logico pagamento_plano(real valor){
    inteiro confirmacao = 0

    escreva("📅 PLANO MENSAL\n")
    escreva("Valor desta saída: R$ ", valor, "\n")
    escreva("(Será incluído no seu plano mensal)\n\n")
    escreva("Confirmar? [1]Sim [2]Não: ")
    leia(confirmacao)

    se(confirmacao == 1){
      escreva("\n✅ Cobrança adicionada ao plano mensal!\n")
      valor_pg_plano = valor_pg_plano + valor
      retorne verdadeiro
    }
    senao{
      escreva("\n❌ Operação cancelada.\n")
      retorne falso
    }
  }

  // ===== GERAR CÓDIGO PIX =====
  funcao cadeia gerar_codigo_pix(){
    cadeia codigo = "00020126580014br.gov.bcb.pix"
    retorne codigo
  }

  // ===== REGISTRAR TRANSAÇÃO NO HISTÓRICO =====
  funcao registrar_transacao(cadeia placa, real valor, cadeia metodo, real hora){
    se(indice_historico < 100){
      historico_placa[indice_historico] = placa
      historico_valor[indice_historico] = valor
      historico_metodo[indice_historico] = metodo
      historico_hora_saida[indice_historico] = hora
      indice_historico++
    }
  }

  // ===== EXIBIR HISTÓRICO DE PAGAMENTOS =====
  funcao exibir_historico_pagamentos(){
    escreva("╔════════════════════════════════════════════╗\n")
    escreva("║       HISTÓRICO DE PAGAMENTOS             ║\n")
    escreva("╚════════════════════════════════════════════╝\n\n")

    se(indice_historico == 0){
      escreva("Nenhuma transação registrada.\n")
      retorne
    }

    para(inteiro i = 0; i < indice_historico; i++){
      escreva("Transação ", i + 1, ":\n")
      escreva("  Placa: ", historico_placa[i], "\n")
      escreva("  Valor: R$ ", historico_valor[i], "\n")
      escreva("  Método: ", historico_metodo[i], "\n")
      escreva("  Hora saída: ", historico_hora_saida[i], "\n")
      escreva("────────────────────────────────────────────\n")
    }
  }

  // ===== EXIBIR TOTAIS POR MÉTODO =====
  funcao exibir_totais_pagamentos(){
    escreva("╔════════════════════════════════════════════╗\n")
    escreva("║         TOTAIS POR MÉTODO                 ║\n")
    escreva("╚════════════════════════════════════════════╝\n\n")
    escreva("💵 Dinheiro:      R$ ", valor_pg_dinheiro, "\n")
    escreva("📱 PIX:           R$ ", valor_pg_pix, "\n")
    escreva("💳 Cartão:        R$ ", valor_pg_cartao, "\n")
    escreva("📅 Plano Mensal:  R$ ", valor_pg_plano, "\n")
    
    real total = valor_pg_dinheiro + valor_pg_pix + valor_pg_cartao + valor_pg_plano
    escreva("────────────────────────────────────────────\n")
    escreva("💰 TOTAL GERAL:   R$ ", total, "\n")
  }

  // ===== FUNÇÃO PARA MOSTRAR VAGAS OCUPADAS =====
  funcao mostrar_vagas_ocupadas(){
    inteiro total_ocupadas = 0

    escreva("╔════════════════════════════════════════════╗\n")
    escreva("║           VAGAS OCUPADAS                  ║\n")
    escreva("╚════════════════════════════════════════════╝\n")

    para(inteiro i = 0; i < 20; i++){
      se(status_vaga[i] == verdadeiro){
        escreva("Vaga ", i + 1, " | Placa: ", placas[i])
        escreva(" | Modelo: ", modelo[i], "\n")
        total_ocupadas++
      }
    }

    se(total_ocupadas == 0){
      escreva("Nenhuma vaga ocupada!\n")
    }

    escreva("╠════════════════════════════════════════════╣\n")
    escreva("║ Total ocupadas: ", total_ocupadas, " / 20\n")
    escreva("║ Vagas livres: ", 20 - total_ocupadas, "\n")
    escreva("╚════════════════════════════════════════════╝\n")
  }
}
  
