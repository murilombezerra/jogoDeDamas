/*
Projeto 
Tema: Jogo de damas multiplayer com interface gráfica
Autor: Murilo Machado Bezerra
*/

clear;   //limpa todas variáveis do programa
clc;    //limpa todas as entradas e saídas do console


//############################### Variáveis globais ###############################
global matrizTabuleiro;                         //variável com valores da matriz inicial do tabuleiro          
global modoDeJogo;                                      //armazena o modo de jogo escolhido                    
global nomeJogador1;                                    //variável para armazenar nome do jogador 1
global nomeJogador2;                                    //variável para armazenar nome do jogador 2
global pontosJogador1;                                  //variável para armazenar os pontos do jogador 1
global pontosJogador2;                                  //variável para armazenar os pontos do jogador 2
global jogoFinalizado;                                  //variável para armazenar o estado do jogo atual
global jogadorDaVez;                                    //variável para armazenar o jogador da vez
global jogadorPontuou;                                  //variável para armazenar se o jogador marcou ponto

pontosJogador1 = 0;
pontosJogador2 = 0;

jogoFinalizado = %F;                                    //inicializa variável como falsa
matrizTabuleiro = [ ...                                 //defini valores iniciais da matriz
                    3,1,3,1,3,1,3,1; ...
                    1,3,1,3,1,3,1,3; ...
                    3,1,3,1,3,1,3,1; ...
                    0,3,0,3,0,3,0,3; ...
                    3,0,3,0,3,0,3,0; ...
                    2,3,2,3,2,3,2,3; ...
                    3,2,3,2,3,2,3,2; ...
                    2,3,2,3,2,3,2,3; ...
                                       ] 


//############################### Funções ###############################

/*
Solicita ao usuário o modo de jogo escolhido
*/
function selecionarModoDeJogo()                                                //define valor padrão da variável
    global modoDeJogo;
    
    escolha = messagebox("Bem Vindo! Selecione o modo de jogo desejado", "modal", "question", ["Jogador vs Jogador","Ajuda"]);  //exibe mensagem
    
    if (escolha == 2) then      //caso o jogador clique em ajuda, será exibido as informações sobre o jogo
        x_dialog(['Informações sobre o jogo:'],[
            'Instruções:';
            '- Para iniciar o jogo basta selecionar a opção no meu inicial *Jogador vs Jogador*';
            '- Caso seja de vontade dos jogadores, o jogo oferece recurso para personalizar o nome de cada jogador';
            '- Sempre o jogador 1 irá iniciar jogando';
            '- As jogadas são realizadas em dois passos, sendo eles:';
            ' -> Escolha da posição de origem (peça qual o jogador deseja mover)';
            ' -> Escolha da posição de destino (local para qual se deseja mover a peça escolhida anteriormente)';
            '- Em cada um dos dois passos citados acima deve-se escolher somente e unicamente um campo do tabuleiro';
            '- Após selecionar o campo do tabuleiro deve-se clicar em OK para seguir para o próximo passo';
            '- O jogo é encerrado quando um dos jogadores comer primeiros as 12 peças do adversário';
            ' ';
            'Peças:';
            '- O jogador 1 irá jogar com a peça X'
            '- O jogador 2 irá jogar com a peça O'
            '- A diferença entre uma peça comum e a dama é o tamanho (Ex: x - peça normal | X - dama)';
            ' ';
            'Tabuleiro:';
            '- O tabuleiro é formado por:';
            ' -> Espaços vazios que não possuem peças';
            ' -> Espaços ocupados por peças';
            ' -> Espaços indisponíveis que não podem ser ocupados, identificados pela cor preta (⬛)';
            ' -> Existe um botão denominado Sair, caso deseje encerrar a partida selecione o mesmo e clique em OK';
            ' ';
            'Desenvolvedor:';
            ' -> Murilo Machado Bezerra';
            ' ';
            'Universidade Federal do ABC - Bases Computacionais da Ciência - 2021';
            ' ';
            'Bom jogo! :)';
            ' ';            
            ]);
            
            selecionarModoDeJogo();
            return;
    elseif (escolha == 1) then
        modoDeJogo = 1; //define o modo de jogo selecionado
    else
        abort;          //caso o jogador clique em fechar o jogo será encerrado
    end  
endfunction


/*
Solicita nome do jogador
*/
function solicitarNomeJogador()
    global nomeJogador1;                                                        //declara uso da variavel global
    global nomeJogador2;                                                        //declara uso da variavel global
   
    //solicita dados dos jogadores através de interface de entrada de dados
    labels=["Nome jogador 1 ( X )"; "Nome jogador 2 ( O )"];                    //define nome das labels
    [ok,nomeJogador1,nomeJogador2]=getvalue("Configurações",labels,list("str",-1,"str",-1),["";""]);
    
    //verifica se foi selecionado ok ou cancelar
    if(ok == %F) then
        abort;
    end   
endfunction


/*
Solicita coordenadas de origem e do proximo local da peça
*/
function retorno = solicitarMovimentoPeca()
    global matrizTabuleiro;
    origem = [];            //armazena posicao campo origem
    destino = [];           //armazena posicao campo destino
    
    //Executa função de tabuleiro até um retorno válido   
    while (length(origem) == 0)
        origem = tabuleiroInterface('Origem');
    end
    
    //Executa função de tabuleiro até um retorno válido
    while (length(destino) == 0)
        destino = tabuleiroInterface('Destino');
    end       
    
    //separa informações de retorno do tabuleiro
    linhaOrigem = origem(1,1);
    colunaOrigem = origem(1,2);
    linhaDestino = destino(1,1);
    colunaDestino = destino(1,2);
    
    retorno = [linhaOrigem, colunaOrigem, linhaDestino, colunaDestino];
endfunction


/*
Tabuleiro com interface
*/
function retorno = tabuleiroInterface(tipo)
    global matrizTabuleiro;                                     //declara uso da variavel global
    global jogadorDaVez;                                        //declara uso da variavel global
    global nomeJogador1;                                        //declara uso da variavel global
    global nomeJogador2;                                        //declara uso da variavel global
    global pontosJogador1;                                      //variável para armazenar os pontos do jogador 1
    global pontosJogador2;                                      //variável para armazenar os pontos do jogador 2
    jogador = ''                                                //nomr do jogador da vez   
    pecas = [];                                                 //armazena valores string das pecas
    
    
    placar = '  Placar: '+string(pontosJogador1)+' || '+string(pontosJogador2);   //define texto de placar
    
    //define texto contendo nome do jogador que irá aparecer na tela
    if(jogadorDaVez == 1)then
        jogador = nomeJogador1 + ' (x)';
    else
        jogador = nomeJogador2 + ' (o)';
    end
    
    //percorre toda a matriz com valores do tabuleiro e converte para sua string correspondente
    //armazenando em uma nova matriz
    for (i = 1 : 8)
        for (ii = 1 : 8)
            if (matrizTabuleiro(i,ii) == 0) then
                pecas(i,ii) = '     ';
            elseif (matrizTabuleiro(i,ii) == 3) then
                pecas(i,ii) = '⬛'
            elseif (matrizTabuleiro(i,ii) == 1) then    
                pecas(i,ii) = '  x  ';
            elseif (matrizTabuleiro(i,ii) == 11) then    
                pecas(i,ii) = '  X  ';
            elseif (matrizTabuleiro(i,ii) == 2) then    
                pecas(i,ii) = '  o  ';
            elseif (matrizTabuleiro(i,ii) == 22) then    
                pecas(i,ii) = '  ⭘  ';
            end           
        end
    end    
    
    messagebox(jogador +" Selecione campo de "+tipo, "modal", "info", ["OK"]); //exibe mensagem
   
   //cria listas para cada linha do tabuleiro                 
    a = list('  A  ', 0,[pecas(1,1),pecas(1,2),pecas(1,3),pecas(1,4),pecas(1,5),pecas(1,6),pecas(1,7),pecas(1,8)]);
    b = list('  B  ', 0,[pecas(2,1),pecas(2,2),pecas(2,3),pecas(2,4),pecas(2,5),pecas(2,6),pecas(2,7),pecas(2,8)]);
    c = list('  C  ', 0,[pecas(3,1),pecas(3,2),pecas(3,3),pecas(3,4),pecas(3,5),pecas(3,6),pecas(3,7),pecas(3,8)]);
    d = list('  D  ', 0,[pecas(4,1),pecas(4,2),pecas(4,3),pecas(4,4),pecas(4,5),pecas(4,6),pecas(4,7),pecas(4,8)]);
    e = list('  E  ', 0,[pecas(5,1),pecas(5,2),pecas(5,3),pecas(5,4),pecas(5,5),pecas(5,6),pecas(5,7),pecas(5,8)]);
    f = list('  F  ', 0,[pecas(6,1),pecas(6,2),pecas(6,3),pecas(6,4),pecas(6,5),pecas(6,6),pecas(6,7),pecas(6,8)]);
    g = list('  G  ', 0,[pecas(7,1),pecas(7,2),pecas(7,3),pecas(7,4),pecas(7,5),pecas(7,6),pecas(7,7),pecas(7,8)]);
    h = list('  H  ', 0,[pecas(8,1),pecas(8,2),pecas(8,3),pecas(8,4),pecas(8,5),pecas(8,6),pecas(8,7),pecas(8,8)]);
    i = list('', 0,['-----', '-----', '-----', '-----', '-----', '-----', '-----', '-----']);
    j = list('', 0,['Sair']);
    
    //gera interface grafica do tabuleiro e armazena resultado dos campos selecionados
    selecionados = x_choices('Selecione campo de '+tipo+' **Vez de '+jogador+placar, list(a,b,c,d,e,f,g,h,i,j));
    
    selecaoValida = %T;         //validacao de selecao de campo valida
    contagemSelecao = 0;        //contagem de quantos campos foram selecionados   
    
    //verifica se foi selecionado opção para sair do jogo
    if (selecionados(1,10) == 1 || length(selecionados) == 0) then
        r = messagebox("Deseja realmente encerrar essa partida ?", "modal", "info", ["Sim", "Não"]);  //exibe mensagem
        
        //verifica se usario confirmou encerramento do jogo
        if (r == 1) then
            abort;
        else
            retorno = [];
            return;
        end                 
    end
    
    //verificacao se foi selecionado somente um campo do tabuleiro
    for (i = 1:8)
        if (selecionados(1,i) ~= 0) then
           contagemSelecao = contagemSelecao + 1;       //sinaliza que existe campo selecionado
           retorno(1,1) = i;                            //armazena linha selecionada
           retorno(1,2) = selecionados(1,i);            //armazena coluna selecionada
        end       
    end     
    
    //verificacao se foi selecionado somente um campo do tabuleiro
    if (contagemSelecao == 0 || contagemSelecao > 1) then   
       messagebox("Selecione um e somente um campo do tabuleiro", "modal", "error", ["OK"]); //exibe mensagem
       retorno = [];
       return; 
    end         
endfunction


/*
Valida os movimentos das peças
*/
function retorno = validarMovimento(movimentos)
    global matrizTabuleiro;                                                     //declara uso da variavel global
    global jogadorDaVez;                                                        //declara uso da variavel global
    isDama = %F;                                                                //armazena se a peça é uma dama
    retorno = %T;
        
    linhaOrigem = movimentos(1,1);                                              //separa valores dos movimentos recebidos
    colunaOrigem = movimentos(1,2);                                             //separa valores dos movimentos recebidos
    linhaDestino = movimentos(1,3);                                             //separa valores dos movimentos recebidos
    colunaDestino = movimentos(1,4);                                            //separa valores dos movimentos recebidos
    
    valorLocalOrigem = matrizTabuleiro(linhaOrigem, colunaOrigem);              //armazena valor da coordenada de origem
    valorLocalDestino = matrizTabuleiro(linhaDestino, colunaDestino);           //armazena valor da coordenada de destino        
    
    //conversao de valores de damas para possibilar comparações
    if  valorLocalOrigem == 11 then
        valorLocalOrigem = 1;
        isDama = %T;
    end
    if  valorLocalDestino == 11 then
        valorLocalDestino = 1;
    end
    if  valorLocalOrigem == 22 then
        valorLocalOrigem = 2;
        isDama = %T;
    end
    if  valorLocalDestino == 22 then
        valorLocalDestino = 2;
    end
    
    
    if valorLocalOrigem == valorLocalDestino then       //validacao de peça igual no destino
        retorno = %F;
        return;
    elseif valorLocalOrigem ~= jogadorDaVez then        //validação se o jogador moveu sua propria peça
        retorno = %F;
        return;
    elseif valorLocalDestino~= 0 then                   //validação se existe peça no destino
        retorno = %F;
        return;
    elseif colunaOrigem+(abs(linhaOrigem-linhaDestino)) ~= colunaDestino && colunaOrigem-(abs(linhaOrigem-linhaDestino)) ~= colunaDestino  then       //validação se é um movimento na diagonal
        retorno =  %F;
        return;
    elseif  isDama == %F && abs(linhaOrigem-linhaDestino) > 2 then   //validação se o movimento é maior que duas casa para uma peça comum
        retorno =  %F;
        return;
    end   
    
    //verifica peça na posição anterior da diagonal parte superior do tabuleiro
    if (colunaDestino - colunaOrigem) > 0 && (linhaDestino - linhaOrigem) > 0 then
        valorLocalAnteriorDestino = matrizTabuleiro(linhaDestino-1, colunaDestino-1);     
    elseif (colunaDestino - colunaOrigem) < 0 && (linhaDestino - linhaOrigem) > 0 then
        valorLocalAnteriorDestino = matrizTabuleiro(linhaDestino-1, colunaDestino+1);
    end
     //verifica peça na posição anterior da diagonal parte inferior do tabuleiro
    if (colunaDestino - colunaOrigem) > 0 && (linhaDestino - linhaOrigem) < 0 then
        valorLocalAnteriorDestino = matrizTabuleiro(linhaDestino+1, colunaDestino-1);     
    elseif (colunaDestino - colunaOrigem) < 0 && (linhaDestino - linhaOrigem) < 0 then
        valorLocalAnteriorDestino = matrizTabuleiro(linhaDestino+1, colunaDestino+1);
    end
    
    //conversao de valores de damas no local anterior do destino para possibilar comparações
    if  valorLocalAnteriorDestino == 11 then
        valorLocalAnteriorDestino = 1;
    end
    if  valorLocalAnteriorDestino == 22 then
        valorLocalAnteriorDestino = 2;
    end
    
    //valida para movimentos > 2 casas
    if  abs(linhaOrigem-linhaDestino) >= 2 && valorLocalAnteriorDestino == valorLocalOrigem then
        retorno =  %F;
        return;
    elseif isDama == %F && valorLocalAnteriorDestino == 0 then 
        retorno =  %F;
        return; 
    elseif isDama == %F && (linhaDestino - linhaOrigem) == -1 && jogadorDaVez == 1 then //proibe mv para atrás
        retorno =  %F;
        return;
    elseif isDama == %F && (linhaDestino - linhaOrigem) == 1 && jogadorDaVez == 2 then //proibe mv para atrás
        retorno =  %F;
        return;
    end
    
    //verificação campos pertencentes a trajetoria da dama
    if (isDama == %T) then
        for (i = 1 : abs(colunaDestino - colunaOrigem)-1 )
            //verifica peça na posição anterior da diagonal parte superior do tabuleiro
            if (colunaDestino - colunaOrigem) > 0 && (linhaDestino - linhaOrigem) > 0 then
                valorLocalTrajetoDama = matrizTabuleiro(linhaDestino-i, colunaDestino-i);  
            elseif (colunaDestino - colunaOrigem) < 0 && (linhaDestino - linhaOrigem) > 0 then
                valorLocalTrajetoDama = matrizTabuleiro(linhaDestino-i, colunaDestino+i);
            end
             //verifica peça na posição anterior da diagonal parte inferior do tabuleiro
            if (colunaDestino - colunaOrigem) > 0 && (linhaDestino - linhaOrigem) < 0 then
                valorLocalTrajetoDama = matrizTabuleiro(linhaDestino+i, colunaDestino-i);  
            elseif (colunaDestino - colunaOrigem) < 0 && (linhaDestino - linhaOrigem) < 0 then
                valorLocalTrajetoDama = matrizTabuleiro(linhaDestino+i, colunaDestino+i);   
            end
            
            //conversao de valores de damas no local anterior do destino para possibilar comparações
            if  valorLocalTrajetoDama == 11 then
                valorLocalTrajetoDama = 1;
            end
            if  valorLocalTrajetoDama == 22 then
                valorLocalTrajetoDama = 2;
            end
            
            //verifica se existe uma peça na trajetória da dama sem ser no campo anterior
            if (valorLocalAnteriorDestino == 0 && valorLocalTrajetoDama ~= 0 ) then
                retorno =  %F;
                break;
                return;            
            end
            
        end
    end        
endfunction


/*
Movimenta a peça selecionada para o destino informado
*/
function moverPeca(movimentos)
    global matrizTabuleiro;                                                     //declara uso da variavel global  
    global jogadorDaVez;                                                        //declara uso da variavel global 
    global nomeJogador1;                                                        //declara uso da variavel global
    global nomeJogador2;                                                        //declara uso da variavel global 
    
    //separa informações recebidas através do parâmetro
    linhaOrigem = movimentos(1,1);
    colunaOrigem = movimentos(1,2);
    linhaDestino = movimentos(1,3);
    colunaDestino = movimentos(1,4);
    
    //remove peça da coordenada de origem
    valorPeca = matrizTabuleiro(linhaOrigem, colunaOrigem);
    matrizTabuleiro(linhaOrigem, colunaOrigem) = 0;    
    
    //verifca se chegou na fileira final oposta e converte a peça em dama
    if (jogadorDaVez == 1 && linhaDestino == 8 && valorPeca ~= 11) then
        messagebox(nomeJogador1+' Conquistou uma dama!', "modal", "info", ['OK']);  //exibe mensagem
        valorPeca = 11;
    elseif (jogadorDaVez == 2 && linhaDestino == 1 && valorPeca ~= 22) then
        messagebox(nomeJogador1+' Conquistou uma dama!', "modal", "info", ['OK']);  //exibe mensagem
        valorPeca = 22;
    end
    
    //move peça para coordenada de destino
    matrizTabuleiro(linhaDestino, colunaDestino) = valorPeca;
endfunction


/*
Verifica se jogador efetuou um ponto
*/
function verificarSePontuou(movimentos)
    global jogadorPontuou;                                              //declara uso da variavel global
    global matrizTabuleiro;                                             //declara uso da variavel global
    global jogadorDaVez;                                                //declara uso da variavel global
    global pontosJogador1;                                              //declara uso da variavel global
    global pontosJogador2;                                              //declara uso da variavel global
    
    jogadorPontuou = %F;                                                //inicia variavel como falsa 
    linhaPecaAnteriorDestino = 0                                        //armazena a linha da peca anterior
    colunaPecaAnteriorDestino = 0                                       //armazena a coluna da peca anterior
    
    linhaOrigem = movimentos(1,1);                                  //separa valores dos movimentos recebidos
    colunaOrigem = movimentos(1,2);                                 //separa valores dos movimentos recebidos
    linhaDestino = movimentos(1,3);                                 //separa valores dos movimentos recebidos
    colunaDestino = movimentos(1,4);                                //separa valores dos movimentos recebidos
    
    valorLocalOrigem = matrizTabuleiro(linhaOrigem, colunaOrigem);     //armazena valor da coordenada de origem
    valorLocalDestino = matrizTabuleiro(linhaDestino, colunaDestino);  //armazena valor da coordenada de destino        
    
    //conversao de valores de damas para possibilar comparações
    if  valorLocalOrigem == 11 then
        valorLocalOrigem = 1;
        isDama = %T;
    end
    if  valorLocalDestino == 11 then
        valorLocalDestino = 1;
    end
    if  valorLocalOrigem == 22 then
        valorLocalOrigem = 2;
        isDama = %T;
    end
    if  valorLocalDestino == 22 then
        valorLocalDestino = 2;
    end
    
    valorLocalAnteriorDestino = 0;  //valor do local anterior ao destino da peça
    
    //verifica peça na posição anterior da diagonal parte superior do tabuleiro
    if (colunaDestino - colunaOrigem) > 0 && (linhaDestino - linhaOrigem) > 0  then
        linhaPecaAnteriorDestino = linhaDestino-1;
        colunaPecaAnteriorDestino = colunaDestino-1;
        valorLocalAnteriorDestino = matrizTabuleiro(linhaPecaAnteriorDestino, colunaPecaAnteriorDestino);     
    elseif (colunaDestino - colunaOrigem) < 0 && (linhaDestino - linhaOrigem) > 0 then
        linhaPecaAnteriorDestino = linhaDestino-1;
        colunaPecaAnteriorDestino = colunaDestino+1;
        valorLocalAnteriorDestino = matrizTabuleiro(linhaPecaAnteriorDestino, colunaPecaAnteriorDestino);
    end
     //verifica peça na posição anterior da diagonal parte inferior do tabuleiro
    if (colunaDestino - colunaOrigem) > 0 && (linhaDestino - linhaOrigem) < 0 then
         linhaPecaAnteriorDestino = linhaDestino+1;
        colunaPecaAnteriorDestino = colunaDestino-1;
        valorLocalAnteriorDestino = matrizTabuleiro(linhaPecaAnteriorDestino, colunaPecaAnteriorDestino);     
    elseif (colunaDestino - colunaOrigem) < 0 && (linhaDestino - linhaOrigem) < 0 then
        linhaPecaAnteriorDestino = linhaDestino+1;
        colunaPecaAnteriorDestino = colunaDestino+1;
        valorLocalAnteriorDestino = matrizTabuleiro(linhaPecaAnteriorDestino, colunaPecaAnteriorDestino);
    end
    
    //conversao de valores de damas no local anterior do destino para possibilar comparações
    if  valorLocalAnteriorDestino == 11 then
        valorLocalAnteriorDestino = 1;
    end
    if  valorLocalAnteriorDestino == 22 then
        valorLocalAnteriorDestino = 2;
    end
    
    //verifica se jogador comeu uma peça inimiga
    if (valorLocalOrigem ~= valorLocalAnteriorDestino && valorLocalAnteriorDestino ~= 0) then
        messagebox("Você realizou um ponto! Jogue novamente", "modal", "info", ["OK"]);     //exibe mensagem
        matrizTabuleiro(linhaPecaAnteriorDestino, colunaPecaAnteriorDestino) = 0;           //remove peça do campo
        jogadorPontuou = %T;
        
        //adiciona um ponto ao jogador da vez
        if (jogadorDaVez == 1) then
            pontosJogador1 = pontosJogador1+1
        else
            pontosJogador2 = pontosJogador2+1
        end
        
    end   
endfunction


/*
Lógica de realização de jogada da máquina 
*/
function realizarJogadaIA()
     global matrizTabuleiro;                                                     //declara uso da variavel global
     matrizTabuleiroAnalise = []                                                //armazena valores da análise do tabuleiro
     
     /*
     Valores de referência para cada análise
     - 1 : peça pode ser comida
     - 2 : peça pode comer para cima a esquerda
     - 3 : peça pode comer para cima a direita
     - 4 : peça pode comer para baixo a esquerda
     - 5 : peça pode comer para baixo a direita
     -
     */
     
     //percorre toda a matrizTabuleiro analisando todas as peças pertencentes a IA
     for (i = 1 : 8)
        for (ii = 1 : 8)
            if (matrizTabuleiro(i,ii) == 2 || matrizTabuleiro(i,ii) == 22) then
                
            end                         
        end
    end
     
     
     
    
endfunction



/*
Lógica do modo de jogo multiplayer
*/
function modoMultiplayer()
    global matrizTabuleiro;                                                     //declara uso da variavel global
    global nomeJogador1;                                                        //declara uso da variavel global
    global nomeJogador2;                                                        //declara uso da variavel global
    global jogoFinalizado;                                                      //declara uso da variavel global
    global jogadorDaVez;                                                        //declara uso da variavel global
    global pontosJogador1;                                                      //declara uso da variavel global
    global pontosJogador2;                                                      //declara uso da variavel global
    global jogadorPontuou;                                                      //declara uso da variavel global
    jogadorDaVez = 1;                                                           //inicia a partir do jogador 1
    jogadorPontuou = %F                                                         //inicia variavel como falsa
    
    while (jogoFinalizado == %F)
        movimentos = solicitarMovimentoPeca();               //solicita e armazena as informações sobre o movimento da peça
        validacaoMovimento = validarMovimento(movimentos);                      //valida o movimento
        
        //repetição enquanto movimento for falso
        while (validacaoMovimento == %F)
            messagebox("Movimento inválido", "modal", "error", ["OK"]); //exibe mensagem
            movimentos = solicitarMovimentoPeca();              //solicita e armazena as informações sobre o movimento da peça
            validacaoMovimento = validarMovimento(movimentos);                  //valida o movimento
        end                
        
        verificarSePontuou(movimentos)                                          //verifica se pontuou
        moverPeca(movimentos);                                                  //move a peça         
        
        //verificação se houve vitoria de algum dos jogadores
        if (pontosJogador1 == 12) then
            messagebox(nomeJogador1+' Venceu a partida!', "modal", "info", ['Encerrar']);  //exibe mensagem
            jogoFinalizado = %T;
        elseif (pontosJogador2 == 12) then
            messagebox(nomeJogador2+' Venceu a partida!', "modal", "info", ['Encerrar']);  //exibe mensagem
            jogoFinalizado = %T;      
        end
        
        //altera a vez para o outro jogador
        if (jogadorDaVez == 1 && jogadorPontuou == %F) then
            jogadorDaVez = 2
        elseif (jogadorDaVez == 2 && jogadorPontuou == %F) then 
            jogadorDaVez = 1
        end    
        
    end
endfunction


/*
Lógica do modo de jogo SinglePlayer
*/
function modoSinglePlayer()
    global matrizTabuleiro;                                                     //declara uso da variavel global
    global nomeJogador1;                                                        //declara uso da variavel global
    global nomeJogador2;                                                        //declara uso da variavel global
    global jogoFinalizado;                                                      //declara uso da variavel global
    global jogadorDaVez;                                                        //declara uso da variavel global
    global pontosJogador1;                                                      //declara uso da variavel global
    global pontosJogador2;                                                      //declara uso da variavel global
    global jogadorPontuou;                                                      //declara uso da variavel global
    jogadorDaVez = 1;                                                           //inicia a partir do jogador 1
    nomeJogador2 = 'BOT'                                                        //define nome do jogador 2 como BOT
    
    
    
    printf("[debug] - modo de jogo não finalizado");    
endfunction


/*
Logica de execução principal
*/
function main()
    global modoDeJogo;                                                          //declara uso da variavel global
    global matrizTabuleiro;                                                     //declara uso da variavel global
    
    selecionarModoDeJogo();                                                     //executa função de interação com usuário
    solicitarNomeJogador();                                                 //solicita nome dos jogadores
    
    //verifica qual será o modo de jogo
    if modoDeJogo == 1   then                                                   //modo multiplayer        
        modoMultiplayer();                                                      //inicia modo PvP
    else                                                                        //modo player vs maquina
        modoSinglePlayer();                                                     //inicia modo solo
    end
    
endfunction





//############################### Execução principal ###############################
main();



clear;   //limpa todas variáveis do programa
clc;    //limpa todas as entradas e saídas do console
