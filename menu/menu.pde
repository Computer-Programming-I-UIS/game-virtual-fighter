import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import sprites.*;
import sprites.maths.*;
import sprites.utils.*;



int mode = 0;
int x = 400;
int x2 = 150;

//definimos variables
Minim inicio;
AudioPlayer primero;

Sprite fondo;
Sprite perry;
Sprite Bob;
Sprite Menu;
StopWatch reloj;

PImage test;

float tiempo;

boolean golpeandoPatadaBob = false;
boolean golpeandoPunoBob = false;
int ultimaDireccionBob = LEFT;


void setup() {
  size(900, 900);
  println("click on canvas and use key [n] for next level");
  println("mode: "+mode);

  reloj = new StopWatch();
  fondo = new Sprite(this, "Fondo.png", 8, 1, 1);
  fondo.setFrameSequence(0, 8, 0.1);

  // reloj = new StopWatch();
  Bob = new Sprite(this, "Bob.png", 68, 1, 1);
  Bob.setFrameSequence(0, 0, 0.1);

  //reloj = new StopWatch();
  perry = new Sprite(this, "Perry.png", 52, 1, 1);
  perry.setFrameSequence(15, 15, 0.1);

  Menu = new Sprite(this, "Menu.png", 71, 1, 1);
  Menu.setFrameSequence(1, 56, 0.2);
  
 inicio = new Minim(this);
 primero = inicio.loadFile("first.mp3");
  
}

void draw() {
  tiempo = (float) reloj.getElapsedTime();
  S4P.updateSprites(tiempo);
  switch(mode) {
  case 0:

    background(0);
    pushMatrix();
    scale(2.0);
    translate(225, 250);
    Menu.draw();
    popMatrix();

    break;
  case 1:

    background(0);
    pushMatrix();
    scale(2.0);
    translate(225, 250);
    Menu.draw();
    popMatrix();

    break;
  case 2:



    background(0);
    pushMatrix();
    scale(2.0);
    translate(220, 250);
    fondo.draw();
    popMatrix();

    pushMatrix();
    scale(2.0);
    translate(x2, 290);
    perry.draw();
    popMatrix();

    pushMatrix();
    scale(1.8);
    translate(x, 325);
    Bob.draw();
    popMatrix();
    if (golpeandoPunoBob) {
      if (Bob.getFrame() >= 22) {
        golpeandoPunoBob = false;
      }
    } else if(golpeandoPatadaBob){
      if (Bob.getFrame() >= 25) {
        golpeandoPatadaBob = false;
      }
    }
    else if(ultimaDireccionBob == LEFT)
      Bob.setFrameSequence(0, 0, 0.1);
      else if(ultimaDireccionBob == RIGHT)
      Bob.setFrameSequence(68, 68, 0.1);

    break;
  default:
    println("you should never see this");
    break;
  }
}


void keyPressed() {
  if ( key == 'n' ) mode++;
  if ( mode > 2 ) {
    println("reset");
    mode = 0;
  }
  println("mode: "+mode);

  switch(mode) {
  case 0:
    Menu.setFrameSequence(1, 56, 0.1);
    break;
  case 1:
    Menu.setFrameSequence(57, 71, 0.1);
    break;
  case 2:


    break;
  default:
    println("you should never see this");
    break;
  }


  if (key==CODED && keyCode==RIGHT ) {
    x=x+10;
    ultimaDireccionBob = RIGHT;
    Bob.setFrameSequence(48, 52, 0.1);
  } else if (key==CODED && keyCode==LEFT ) {
    ultimaDireccionBob = LEFT;
    x=x-10;
    Bob.setFrameSequence(17, 21, 0.1);
  } else if (key=='l' ) {
    golpeandoPunoBob = true;
    Bob.setFrameSequence(20, 22, 0.5);
  } else if (key=='k' ) {
    golpeandoPatadaBob = true;
    Bob.setFrameSequence(23, 25, 0.5);
  } else if (key=='a' ) {
    x2=x2-10;
    perry.setFrameSequence(26, 27, 0.1);
  } else if (key=='d' ) {
    x2=x2+10;
    perry.setFrameSequence(23, 25, 0.1);
  } else if (key=='r' ) {
    perry.setFrameSequence(15, 16, 0.1);
  } else if (key=='f' ) {
    perry.setFrameSequence(17, 19, 0.1);
  }
  
  if (key =='1'){
    primero.play();
  }
  if (key =='2'){
    primero.pause();
    
  }
  
}
