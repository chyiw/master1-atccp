
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import java.util.Collections;
import processing.sound.*;


Box2DProcessing box2d;
SumoJumpEngine gameEngine;
PImage backgroundImage;

boolean timerEnabled = false;  // Set to true, if the level should have a time limit
// Timer related variables:
SinOsc sine;
int countDownDuration = 60000;                           // Time in milliseconds
int countDownStartTime = 0;                              // Point of time when countdown starts
int countDownlastFullSecond = countDownDuration / 1000;
int countDownRemainingTime = countDownDuration;
boolean countDownFinished = false;


void setup() {
  size(1024, 700);
  backgroundImage = loadImage("background.png");
  sine = new SinOsc(this);
  sine.freq(1500);
  initGame();
}


void initGame() {
  // Initialize and create the Box2D world
  box2d = new Box2DProcessing(this);  
  box2d.createWorld();
  box2d.setGravity(0, -98.1);
  // Turn on collision listening!
  box2d.listenForCollisions();

  // Create the engine
  gameEngine = new SumoJumpEngine("level1.csv");

  // Create the players
  gameEngine.addController( new SumoJumpExampleKeyCtrl());
  gameEngine.addController( new DeinCtrl());

  // Initialize countdown
  countDownStartTime = millis();
}


void keyPressed() {
  if (keyCode == 'D') {
    gameEngine.toggleAgentDebugDrawingDisplay();
  } else if (keyCode == 'S') {
    gameEngine.toggleAgentStatusDrawingDisplay();
  } else if (keyCode == 'R') {
    initGame();
  }
}


void handleCountDown() {
  int currentTime = millis();
  int endOfCountDown = countDownStartTime + countDownDuration;
  countDownRemainingTime = 0;
  if (currentTime < endOfCountDown) // Is there still some time left?
    countDownRemainingTime = endOfCountDown - currentTime;
}


void drawBackground() {
  // A blue sky:
  //background(74, 184, 237);
  // Some grass:
  //noStroke();
  //fill(44, 137, 23);
  //rectMode(CORNER);
  //rect(0, height-30, width, 30);
  imageMode(CORNER);
  image(backgroundImage, 0, 0);
}


void drawCountDown() {
  // Split for display:
  int seconds = countDownRemainingTime / 1000;
  int milliSecondsRemaining = countDownRemainingTime - seconds*1000;

  // Tick
  if (seconds < countDownlastFullSecond && seconds < 10 && seconds > 0) {
    sine.freq(1500);
    sine.play();
  }
  if ((milliSecondsRemaining > 0 && milliSecondsRemaining < 800) || seconds > 10)
    sine.stop();

  // Draw seconds in huge black numbers
  textAlign(RIGHT);
  textSize(50);
  fill(0);
  text(seconds, width-100, 70);

  // Draw milliseconds in small orange numbers
  textAlign(LEFT);
  textSize(30);
  fill(255, 128, 0);
  text(milliSecondsRemaining, width-100, 70);
}


void draw() {
  drawBackground();
  if (timerEnabled && gameEngine.getWinner() == null)
    handleCountDown();
  if (gameEngine.getWinner() == null && countDownRemainingTime > 0) {
    box2d.step();
    gameEngine.step();
  }
  gameEngine.draw();
  if (timerEnabled)
    drawCountDown();
  if (gameEngine.getWinner() != null) {
    textAlign(CENTER);
    textSize(120);
    fill(255, 200, 100);
    text("WINNER!", width/2, height/2.5);
    text(gameEngine.getWinner().getName(), width/2, height/1.5);
    textSize(20);
    textAlign(LEFT);
    text("Press R for restart", 30, 30);
  }
  if (countDownRemainingTime == 0) {
    textAlign(CENTER);
    textSize(120);
    fill(255, 200, 100);
    text("TIME IS UP!", width/2, height/2.5);
    sine.freq(500);
    sine.play();
  }
}


// Collision event function
void beginContact(Contact cp) {
  gameEngine.beginContact(cp);
}


void endContact(Contact cp) {
  // empty...
}
