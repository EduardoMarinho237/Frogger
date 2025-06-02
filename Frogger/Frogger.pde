// Frogger Game

// Main Game Controller
RowController rControl;
RowController rControl1;

// Main frog object
Frog frog;
// Finish Line Object 
Finish fLine;

// Global Variables
float grid = 25;
int frogRow = 0;
int highScore = 0;
int currentScore = 0;
boolean ismoving = false;

PImage frogpic;
PFont defaultFont;
PFont largeFont;

// Game state: "menu", "game", or "credits"
String gameState = "menu";

void setup() {
  size(575, 800);
  frogpic = loadImage("frog.png");
  frogpic.resize(25, 25);

  // Load sound files
  jumpSound = new SoundFile(this, "jump.wav");
  squashSound = new SoundFile(this, "squash.wav");
  backgroundMusic = new SoundFile(this, "music.mp3");
  backgroundMusic.loop();

  // Fonte padrão para o jogo e grande para o menu
  defaultFont = createFont("Arial", 12, true);
  largeFont = createFont("Arial", 32, true);
  textFont(defaultFont);

  frog = new Frog(width / 2 - grid / 2, height - grid, grid);
  frogRow  = 1;
  rControl = new RowController(true);
  fLine = new Finish();

  frameRate(60);
}

void draw() {
  if (gameState.equals("menu")) {
    drawMenu();
  } else if (gameState.equals("credits")) {
    drawCredits();
  } else if (gameState.equals("game")) {
    drawGame();
  }
}

// ========== TELA DE MENU ==========
void drawMenu() {
  background(0);
  fill(255);
  textAlign(CENTER, CENTER);
  textFont(largeFont);
  text("FROGGER", width / 2, height / 4);

  rectMode(CENTER);
  textSize(20);
  fill(100, 255, 100);
  rect(width / 2, height / 2, 180, 50);
  fill(0);
  text("Jogar", width / 2, height / 2);

  fill(100, 100, 255);
  rect(width / 2, height / 2 + 70, 180, 50);
  fill(0);
  text("Créditos", width / 2, height / 2 + 70);
}

// ========== TELA DE CRÉDITOS ==========
void drawCredits() {
  background(0);
  fill(255);
  textAlign(CENTER);
  textFont(defaultFont);
  textSize(18);
  text("CAIPORA STUDIO", width / 2, 60);

  String[] nomes = {
    "Arthur Nogueira Silveira de Lima Santos - 01610363",
    "Eduardo Marinho Xavier Junior - 01625908",
    "Kawan Leandro Batista de Lima Santos - 01616317",
    "Leticia Pinheiro Paoleschi - 01651848",
    "Marcus Trummer - 01650257",
    "Matheus Emanuel dos Santos Aguiar Paiva - 01615805"
  };
  textSize(14);
  for (int i = 0; i < nomes.length; i++) {
    text(nomes[i], width / 2, 100 + i * 25);
  }

  // Botão "Voltar" no canto superior esquerdo
  rectMode(CORNER);
  fill(255, 100, 100);
  rect(10, 10, 80, 30);
  fill(0);
  textAlign(LEFT, CENTER);
  text("Voltar", 20, 25);
}

// ========== JOGO PRINCIPAL ==========
void drawGame() {
  background(50);
  textFont(defaultFont); // garante fonte original no jogo
  fLine.show();
  rControl.update();
  rControl.show(); 
  frog.show(); 

  if (ismoving) {
    rControl1.show();
    rControl1.update();
    frog.moveDown();

    if (rControl.hasmoved >= height - 25) {
      rControl1.stopMove();
      rControl = rControl1;
      rControl1 = null;
      frameRate(60);
      ResetFrog(false);
      ismoving = false;
    }
  } else if (frogRow > 29) {
    ismoving = true;
    rControl.moveDown();
    rControl1 = new RowController(false);
    rControl1.moveDown();
    frameRate(120);
  }

  // Painel de Pontuação
  fill(200);
  rect(0, 0, 125, 75);
  fill(0);
  text("HighScore: " + highScore, 10, 15);
  text("CurrentScore: " + currentScore, 10, 30);
}

// ========== MOUSE INTERAÇÃO ==========
void mousePressed() {
  if (gameState.equals("menu")) {
    if (mouseX > width / 2 - 90 && mouseX < width / 2 + 90) {
      if (mouseY > height / 2 - 25 && mouseY < height / 2 + 25) {
        gameState = "game";
      } else if (mouseY > height / 2 + 45 && mouseY < height / 2 + 95) {
        gameState = "credits";
      }
    }
  } else if (gameState.equals("credits")) {
    if (mouseX > 10 && mouseX < 90 && mouseY > 10 && mouseY < 40) {
      gameState = "menu";
    }
  }
}

// ========== CONTROLE DE TECLADO ==========
void keyPressed() {
  if (!gameState.equals("game")) return;

  jumpSound.play();
  if (!ismoving) {
    if (keyCode == UP) {
      currentScore++;
      if (currentScore > highScore) {
        highScore = currentScore;
      }
      frog.move(0, 1);
      frogRow++;
      rControl.setfrogRow();
    } else if (keyCode == DOWN) {
      if (frogRow > 1) {
        currentScore--;
        frogRow--;
        rControl.setfrogRow();
      }
      frog.move(0, -1);
    } else if (keyCode == LEFT) {
      frog.move(-1, 0);
    } else if (keyCode == RIGHT) {
      frog.move(1, 0);
    }
  }
}

// ========== RESET DO SAPO ==========
void ResetFrog(boolean died) {
  if (died) {
    squashSound.play();
    currentScore = 0;
    frog = new Frog(width / 2 - grid / 2, height - grid, grid);
  } else {
    frog = new Frog(frog.left, height - grid, grid);
  }

  frogRow = 1;
  rControl.setfrogRow();
}
