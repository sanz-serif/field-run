//|------------------------------------------------|
//| Trabalho Final - Linguagem Computacional       |
//|------------------------------------------------|
//| Código: NOME_DO_JOGO                           |
//|------------------------------------------------|
//| Alunos:                                        |
//| Fábio André Camargo Sanz                       |
//| Bruna Megumi Fujita                            |
//|------------------------------------------------|
//| Descrição:                                     |
//|------------------------------------------------|
//| Observações:                                   |
//|------------------------------------------------|



//|------------------------------------------------|
//| DECLARAÇÃO DE VARIÁVEIS GLOBAIS                |
//|------------------------------------------------|

float saltoX, saltoY, quadX, quadY, quadFY, quadL;
float obsX, obsY, obsA, obsL, obsV;
float fundoX1, fundoX2; //fundoX = posição background
float pontos, recorde, razao;
float boostX, boostY, boostR;
int tela, frame, estacao, obstaculo, anos, contagem;
boolean pause, booster;
PImage fundo, placa, frame1, frame2, frame3; //background-fundo
PImage obst1, obst2;

//|------------------------------------------------|
//| FUNÇÕES - DEFINIÇÃO E EXECUÇÃO DO JOGO         |
//|------------------------------------------------|

void setup() {
  size(1024, 720); //Tamanho da tela

  textSize(50);
  tela = 0;
  fundo = loadImage("bg.png");
  frame1 = loadImage("personagem-frame1.png");
  frame2 = loadImage("personagem-frame2.png");
  frame3 = loadImage("personagem-frame3.png");
  obst1 = loadImage("obstaculo-1.png");
  obst2 = loadImage("obstaculo-2.png");
  placa = loadImage("placa.png");

  saltoX = 61; //Inicia como 61 devido ao funcionamento da função de 2º grau. Mais informações na função salto().
  saltoY = 0;
  pontos = 0;
  recorde = 0;
  razao = 1;

  tela = 0;
  frame = 0;
  pause = false;
  estacao = 1;
  anos = 0;
  obstaculo = int(random(1, 2.1));

  quadX = 100; //Posição X do jogador
  quadFY = 350; //Posição Y do jogador
  quadY = 300; //Posição Y do jogador
  quadL = 100; //Lado do quadrado

  obsY = 480;               //Posição Y do obstáculo
  obsX = width + 500;       //Posição X do obstáculo (à direita, porém fora da tela)
  obsV = 13;                //Velocidade do obstáculo

  if (obstaculo == 1) {
    obsA = -100;
    obsL = 200;
  } else if (obstaculo == 2) {
    obsA = -180;
    obsL = 120;
  }

  boostX = width + 500;
  //velocidade do objeto * quantidade de frames p/ segundo * 60 segundos
  //então o booster aparecerá uma vez a cada 60 segundos (1 minuto)
  boostY = 350;
  boostR = 40;
  booster = false;
  contagem = 0;

  fundoX1 = 0;
  fundoX2 = width;
}

void draw() {
  //As telas são identificadas pela variável int de mesmo
  //nome, sendo que cada número equivale a uma tela
  //0 - Tela de Início
  //1 - Tela de Jogo
  //2 - Tela Final

  if (tela == 0) {
    telaInicio();
  } else if (tela == 1) {
    telaJogo();
  } else if (tela == 2) {
    telaTransicao();
  } else if (tela == 3) {
    telaFinal();
  } else {
    telaInicio();
  }
}

//|------------------------------------------------|
//| FUNÇÕES - TELAS DE JOGO                        |
//|------------------------------------------------|

void telaInicio() {
  background(0);
  fill(255);
  textAlign(CENTER);
  text("Aperte 'ENTER' para iniciar o jogo!", width/2, height/2);
}

void telaJogo() {
  noStroke();
  image(fundo, fundoX1, 0);
  image(fundo, fundoX2, 0);

  //Desenha a figura quadrado (jogador).
  //Cor branca e dimensões predefnidas.
  //O argumento "quadY - (saltoY/4)" usa o valor fixo de posição Y do quadrado, menos
  //um valor definido pela função de 2º grau definida em salto() - consulte o trecho
  //do código para saber mais informações - o que resulta em um salto, quando pressionada
  //a tecla ESPAÇO, que serve de gatilho para o movimento. Dessa forma, quando o valor de
  //saltoY é 0, o quadrado se mantém fixo no lugar.

  //fill(255);
  //stroke(255);
  //square(quadX, quadY, quadL);
  if (frame < 12) {
    image(frame1, quadX, quadY-50, 150, 150);
    frame++;
  } else if (frame >= 12 && frame < 24) {
    image(frame2, quadX, quadY-50, 150, 150);
    frame++;
  } else if (frame >= 24 && frame < 36) {
    image(frame3, quadX, quadY-50, 150, 150);
    frame++;
  } else if (frame >= 36 && frame < 48) {
    image(frame2, quadX, quadY-50, 150, 150);
    frame++;
  } else if (frame >= 48) {
    image(frame1, quadX, quadY-50, 150, 150);
    frame = 0;
  }

  //Desenha a pontuação
  //Cor branca, texto de tamanho 50 e posições relativas ao canto superior direito.
  image(placa, width - 400, 50, 350, 100);

  fill(255);
  textSize(40);
  textAlign(LEFT);
  text("Pontos: " + str(int(pontos)), width - 350, 110);
  //text("Anos: " + str(int(anos)), width - 400, 200);

  if (!booster) {
    fill(255, 255, 0);
    circle(boostX, boostY, boostR);
  } else {
    fill(255, 0, 255, 40);
    rect(0, 0, width, height);
  }

  ////Desenha o obstáculo
  ////Cor vermelha
  //fill(255, 0, 0);
  ////stroke(255, 0, 0);
  //rect(obsX, obsY, obsL, obsA);
  if (obstaculo == 1) {
    image(obst1, obsX, obsY, obsL, obsA);
  } else if (obstaculo == 2) {
    image(obst2, obsX, obsY, obsL, obsA);
  }


  //Executa funções básicas para o funcionamento do jogo.
  //Mais informações nos códigos de cada função.
  colisao();
  salto();
  pontos();
  obstaculo();
  booster();
  fundo();
}

void telaTransicao() {

  noStroke();
  fill(0, 10);
  rect(0, 0, width, height);

  color a = get(width/2, height/2);
  //println(brightness(a));

  if (brightness(a) <= 12) {
    tela = 3;
  }
}

void telaFinal() {
  background(0);
  fill(255);
  textAlign(CENTER);
  text("Seu recorde: " + recorde, width/2, height/2 - 50);
  text("Aperte 'ENTER' para reiniciar o jogo!", width/2, height/2 + 50);
}

//|------------------------------------------------|
//| FUNÇÕES - SEQUÊNCIAS DE CÓDIGO DO JOGO         |
//|------------------------------------------------|

void salto() {
  //Cria uma função de segundo grau (parábola) para realizar o movimento do salto.
  //Usamos uma variável Y para definir a altura do salto, conforme os valores de Y sobem e descem.
  //Usamos também uma variável X apenas para incrementar os valores de Y, uma vez que o jogador não
  // se deslocará neste eixo (o jogador fica sempre fixo na tela, oscilando apenas para cima e para
  //baixo conforme os saltos). As raízes da função (valores de X para os quais Y é 0) são 0 e 60, por
  //isso X é sempre incrmentado em 1, até o valor máximo de 60.

  if (saltoX <= 60) {
    saltoY = -(saltoX * saltoX) + (60 * saltoX);
    saltoX++;
  }

  quadY = quadFY - (saltoY/4);
}

void pontos() {
  //Estabelece uma contagem de pontos a cada frame exibido na tela, e embora a contagem seja feita em float,
  //o valor exbido será sempre um inteiro, isso para diminuir a velocidade de contagem

  if (!booster)
    pontos += razao;
  else
    pontos += razao * 2;

  if (pontos % 500 < razao && pontos >= 500)
  {

    //código mudança de estações
    if (estacao < 4)
    {
      estacao++;
    } else
    {
      estacao = 1;
    }

    switch(estacao) {
    case 1:
      println("Verão");
      break;

    case 2:
      println("Outono");
      break;

    case 3:
      println("Inverno");
      break;

    case 4:
      println("Primavera");
      break;
    }

    if (pontos % 2000 < razao)
    {
      if (obsV < 30) { //Estipula o valor máximo para a velocidade do obstáculo
        razao++;
        obsV++;
        anos++;
      }
    }
  }
}

void obstaculo() {

  if (obsX + obsL < -100) {
    //Verifica quando o obstaculo já saiu da tela, e gera um novo obstáculo à direita da tela

    obstaculo = int(random(1, 3));

    if (obstaculo == 1) {
      obsA = -100;
      obsL = 200;
    } else if (obstaculo == 2) {
      obsA = -180;
      obsL = 120;
    }

    obsX = width + 100; //posiciona o obstáculo à direita, mas para fora da tela, de forma que o movimento o levará para a parte visível
  } else {
    //Movimenta os obstáculos a uma determinada velocidade da direita para a esquerda da tela
    if (!booster) {
      obsX -= obsV;
    } else {
      obsX -= round(obsV * 0.8);
    }
  }
}

void booster() {

  if (pontos >= 3000) {
    boostX -= obsV;

    if (boostX < 0) {
      boostY = random(200, 320);
      boostX = obsV * (2500 / razao);
    }

    if (booster) {
      contagem++;

      if (contagem >= 600) {
        booster = false;
        contagem = 0;
      }
    }
  }
}

void colisao() {

  //colisão com o obstáculo
  if (quadX + quadL > obsX && quadX + quadL < obsX + obsL) {

    if (quadY + quadL > obsY + obsA) {

      if (pontos > recorde) {
        recorde = pontos;
      }

      tela = 2;
    }
  } else if (quadX > obsX && quadX < obsX + obsL) {

    if (quadY + quadL > obsY + obsA) {

      if (pontos > recorde) {
        recorde = pontos;
      }

      tela = 2;
    }
  }

  //colisão com o booster
  if (quadX + quadL > boostX - boostR && quadX + quadL < boostX + boostR) {

    if (quadY + quadL > boostX - boostR) {

      booster = true;
    }
  } else if (quadX > boostX - boostR && quadX < boostX + boostR) {

    if (quadY + quadL > boostX - boostR) {

      booster = true;
    }
  }
}

void fundo() {
  if (!booster) {
    fundoX1 -= obsV;
    fundoX2 -= obsV;
  } else {
    fundoX1 -= round(obsV * 0.8);
    fundoX2 -= round(obsV * 0.8);
  }

  if (fundoX1 <= -width)
  {
    fundoX1 = width;
  }
  if (fundoX2 <= -width)
  {
    fundoX2 = width;
  }
}

//|------------------------------------------------|
//| FUNÇÕES - EVENTOS DE INPUT                     |
//|------------------------------------------------|

void keyPressed() {

  if (tela == 0) {
    if (key == ENTER) {
      tela = 1;
    }
  }

  if (tela == 1) {
    if (key == ' ') { //Salta apenas quando presssionada a tecla ESPAÇO
      if (saltoX >= 60)
        //Reseta a variável X do salto para reiniciar a função de 2º grau,
        //como melhor explicado dentro da própria função salto()

        saltoX = 0;
    }

    if (key == ENTER) {
      loop();
    }

    if (key == 'p') {
      if (pause) {
        loop();

        pause = false;
      } else {
        fill(0, 0, 0, 128);
        rect(0, 0, width, height);

        fill(255);
        textAlign(CENTER);
        text("Para continuar aperte 'P'", width/2, height/2);

        noLoop();

        pause = true;
      }
    }
  }

  if (tela == 3) {
    if (key == ENTER) {
      tela = 1;

      saltoX = 61; //Inicia como 61 devido ao funcionamento da função de 2º grau. Mais informações na função salto().
      saltoY = 0;
      pontos = 0;
      razao = 1;
      pause = false;
      frame = 0;
      estacao = 1;
      anos = 0;
      booster = false;
      boostX = width + 500;

      obstaculo = int(random(1, 3));
      obsY = 480;               //Posição Y do obstáculo
      obsX = width + 100;       //Posição X do obstáculo (à direita, porém fora da tela)
      obsV = 13;                //Velocidade do obstáculo

      if (obstaculo == 1) {
        obsA = -100;
        obsL = 200;
      } else if (obstaculo == 2) {
        obsA = -180;
        obsL = 120;
      }

      fundoX1 = 0;
      fundoX2 = width;
    }
  }
}
