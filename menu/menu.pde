import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import sprites.*;
import sprites.maths.*;
import sprites.utils.*;

PImage Creditos;


//// variables de control 
boolean button1 = false ; /// boton de control para iniciar juego
boolean button2 = false ; // boton para intruciones 
boolean button3 = false ; // para ver creditos
boolean control1 = false ; /// control para habilitar los botones en cada texto
boolean control2 = true ; /// coontrol de la musica , siempre inicia activo el 
/// el usuario lo apaga con 1 
//// botones 

/// ubivacion de los botones para que se precione al hacer contacto con las letras 
int x1=350 ;
int y1=440 ;
int w1=210 ;
int h1=40 ;


int x3=350 ;
int y2=490 ;
int w2=210 ;
int h2=35 ;


int x4=350 ;
int y3=520 ;
int w3=170 ;
int h3=25 ;


//////////////// modo de juego y valores de control para perry y bob

int mode = 0;
int x = 400;
int x2 = 150;

//definimos variables
/// control de audio 
Minim inicio;
AudioPlayer primero;
AudioPlayer golpe;


//// control de animaciones 
Sprite fondo;
Sprite perry;
Sprite Bob;
Sprite Menu;
Sprite GameOver;
StopWatch reloj;

PImage test;

float tiempo;
//// valores de control para las animaciones de bob 
boolean golpeandoPatadaBob = false;
boolean golpeandoPunoBob = false;
int ultimaDireccionBob = LEFT;
//// valores de control para las animaciones de perry 
boolean golpeandoPatadaperry = false;
boolean golpeandoPunoperry = false;
int ultimaDireccionperry = RIGHT;

/// vida de los jugadores
int vidaperry =100 ; 
int vidabob = 100 ;
//// daño resivido por los jugadores  
int danobob = 0;
int danoperry = 0;

void setup() {
  size(900, 900); 
  println("click on canvas and use key [n] for next level");
  println("mode: "+mode);
 //// se inicia el reloj y se cargan los archivos para las animaciones 
  reloj = new StopWatch();
  fondo = new Sprite(this, "Fondo.png", 8, 1, 1);
  fondo.setFrameSequence(0, 8, 0.1);

  // reloj = new StopWatch();
  Bob = new Sprite(this, "Bob.png", 68, 1, 1);
  Bob.setFrameSequence(0, 0, 0.1);

  //reloj = new StopWatch();
  perry = new Sprite(this, "Perry.png", 52, 1, 1);
  perry.setFrameSequence(15, 15, 0.1);

  Menu = new Sprite(this, "Menu.png", 61, 1, 1);
  Menu.setFrameSequence(1, 56, 0.2);
  //// se cargan los audios 
 inicio = new Minim(this);
 primero = inicio.loadFile("first.mp3");
 golpe = inicio.loadFile("golpeo.mp3");
 
   GameOver = new Sprite(this, "GameOver.png", 22, 1, 1);
  

  
}

void draw() {
 // se inicia el reloj y se verifican los modos del menu 
  
  tiempo = (float) reloj.getElapsedTime();
  S4P.updateSprites(tiempo);
  switch(mode) {
  case 0:
   /// modo cero 
   ///*
   /*
   este modo precenta una animacion controlada por tiempo y 
   al final de esta deja ver el menu
   
   */
    background(0);
    pushMatrix();
    scale(2.0);
    translate(225, 250);
    Menu.draw();
    popMatrix(); 
    break;
  case 1:
     /*
   este modo presenta las intruciones y muestra los controles de los
   personajes 
   
   */
     
    background(0);
    pushMatrix();
    scale(2.0);
    translate(225, 250);
    Menu.draw();
    popMatrix();

    break;
  case 2:
      /*
   este es el modo de juego presenta las animaciones de perry y bob
   tambien verifica los golpes y los sonidos de estos , tambien muestra la
   orientacion de las animaciones 
   
   */


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
    ///// barras de vida ////
       /*
   este es el control de las barras de vida , es una barra roja que va 
   disminullendo y es la vida - el daño resivido por el jugador 
   
   */
    fill(255);
    rect(50,300,100,30);
    fill(255,0,0,191);
    rect(50,300,vidaperry-danoperry,30);
    
    fill(255);
    rect(730,300,100,30);
    fill(255,0,0,191);
    rect(730+danobob,300,vidabob-danobob,30);
    
    /// game over 
       /*
   en esta parte se verifica el game over , si alguno de los jugaroes recibio mas 
   daño del permitido pierde el juego y manda a los modos de fin de juego
   
   */
    
    if(danobob>=100){
     mode = 4; 
     danobob=0;
        x = 400;
        x2 = 150;
    }
   if(danoperry>=100){
     mode = 5; 
     danoperry=0;
     x = 400;
     x2 = 150;
    }
    
    
    /////////////// golpe bob //////////////
       /*
   esta parte son los golpes dados por el personaje bob y a su vez controla tanto 
   el audio como la orientacion 
   
   */
    if (golpeandoPunoBob) {
      if (Bob.getFrame() >= 22) {
          if((x<=x2+50)&&(x>=x2)){
            danoperry+=5;
            golpe.play();
          }
        golpe.rewind();
        golpeandoPunoBob = false;
      }
    } else if(golpeandoPatadaBob){
      if (Bob.getFrame() >= 25) {
        if((x<=x2+50)&&(x>=x2)){
            danoperry+=10;
            golpe.play();
          }
        golpe.rewind();
        golpeandoPatadaBob = false;
      }
    }
    else if(ultimaDireccionBob == LEFT){
     Bob.setFrameSequence(0, 0, 0.1); 
    } else if(ultimaDireccionBob == RIGHT){
      Bob.setFrameSequence(68, 68, 0.1);
    } 
   ////////////// pelea perry ///////////////////  
       /*
   esta parte son los golpes dados por el personaje perry y a su vez controla tanto 
   el audio como la orientacion 
   
   */
   if (golpeandoPunoperry) {
      if (perry.getFrame() >= 16) {
        if ((x2+50<=x)&&(x-50>=x2)){
          danobob+=5;
          golpe.play();
        }
        golpe.rewind();
        golpeandoPunoperry = false;
      }
    } else if(golpeandoPatadaperry){
      if (perry.getFrame() >= 19) {
        if ((x2+50<=x)&&(x-50>=x2)){
          danobob+=10;
          golpe.play();
        } 
        golpe.rewind();
        golpeandoPatadaperry = false;
      }
    }
    else if(ultimaDireccionperry == LEFT){
     perry.setFrameSequence(27, 27, 0.1);
    } else if(ultimaDireccionperry == RIGHT){
      perry.setFrameSequence(25, 25, 0.1);
    }   
      //// creditos ;::
   break;
  case 3:
      /*
   en este modo deben ser cargados los creditos 
   
   */
   Creditos = loadImage ("Creditos.png");
   
  background(0);
    pushMatrix();
    scale(2.0);
    translate(225, 250);
    image(Creditos,0,0);
    popMatrix(); 
 
  break;
  case 4:
      /*
   este es el game over en donde gana perry dado que la vida de bob es 0 
   
   */
   GameOver.setFrameSequence(0, 10, 0.4);
   
     background(0);
    pushMatrix();
    scale(2.0);
    translate(220, 250);
    GameOver.draw();
    popMatrix();
  
   break;
  case 5:
    /*
   este es el game over en donde gana bob dado que la vida de perry es 0 
   
   */

   GameOver.setFrameSequence(12, 22, 0.4);
   
     background(0);
    pushMatrix();
    scale(2.0);
    translate(220, 250);
    GameOver.draw();
    popMatrix();
  

      

    break;
  default:
    println("you should never see this");
    break;
  }
  /// cuando pase el tiempo cambiara la animacion de el modo cero mostrasndo el inicio 
  
  if ((millis()>11400)&&(mode == 0)){
    control1 = true;
   Menu.setFrameSequence(51, 55, 0.2); 
  }
  
  /// aqui estan los controles de los botones de texto , 
  //// dato que cada boton lleva a un modo aqui se muestra cada boton y cada modo
  
 if((mode ==0)&& (control1)){
 
  if (button1){
   mode = 2 ;
   button1 = false;

  }
  if (button2){
   Menu.setFrameSequence(58, 58, 0.1);
   mode = 1 ;   
   button2 = false; 

  }
  if (button3){
    mode = 3 ;
    button3 = false;

  }
  
 }
 
 /// esqui esta el control de audio general , tanto para el modo 0 (inicio)
 /// como para el modo 2 (pelea)
 if((mode == 0)&&(control2)||(mode == 2)&&(control2)){
   primero.play();
   
 }else{
  primero.pause();
  //primero.rewind();

 }
 
  
}


void mousePressed(){
  /// esta son las funciones que hacen los botones , al hacer clik dentro del los puntos
  /// anterior mente mostrados estos accionaran los botones 
  
  if ((mouseX > x1)&&(mouseX < x1 + w1)&&(mouseY > y1)&&(mouseY < y1 + h1 )){
   button1 = true ; 
  } 
  
  if ((mouseX > x3)&&(mouseX < x3 + w2)&&(mouseY > y2)&&(mouseY < y2 + h2 )){
   button2 = true ; 
  }
  
  if ((mouseX > x4)&&(mouseX < x4 + w3)&&(mouseY > y3)&&(mouseY < y3 + h3 )){
   button3 = true ;
  }
  
}


void keyPressed() {
  /// aqui se ejerce el control de cada letra 
  // al ser precionada ejerce una accion 
  
  /// exit 
 if (key=='*' ){
  mode = 0; 
 danobob = 0;
 danoperry = 0;
  
 }
 

  if (key==CODED && keyCode==RIGHT ) {
    x=x+10;
    if (x >= 450 ){
     x=450; 
    }
    ultimaDireccionBob = RIGHT;
    Bob.setFrameSequence(48, 52, 0.1);
  } else if (key==CODED && keyCode==LEFT ) {
    ultimaDireccionBob = LEFT;
    x=x-10;
    if (x <= 40 ){
     x=40; 
    }
    
    
    Bob.setFrameSequence(17, 21, 0.1);
  } else if (key=='l' ) {
    golpeandoPunoBob = true;
    Bob.setFrameSequence(20, 22, 0.5);
  } else if (key=='k' ) {
    golpeandoPatadaBob = true;
    Bob.setFrameSequence(23, 25, 0.5);
  } 
  //////////////////// movimientos perry 
  
  if (key=='a' ) {
    x2=x2-10;
    if (x2 <= 40 ){
     x2=40; 
    }
    ultimaDireccionperry = LEFT;
    perry.setFrameSequence(26, 27, 0.1);
  } else if (key=='d' ) {
    x2=x2+10;
    if (x2 >= 400 ){
     x2=400; 
    }
    ultimaDireccionperry = RIGHT;
    
    perry.setFrameSequence(23, 25, 0.1);
  } else if (key=='r' ) {
    golpeandoPunoperry = true;
    perry.setFrameSequence(15, 16, 0.1);
  } else if (key=='f' ) {
    golpeandoPatadaperry = true;
    perry.setFrameSequence(17, 19, 0.1);
  }
  
  //// esta es la tecla de control de audio 
  if (key=='1' ){
       if (control2){
     control2 = false ; 
    }else { 
    control2 = true ;
 
    } 
  }
  
}
