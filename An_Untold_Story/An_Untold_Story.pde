// Skecth Principal

//Para los Sprites:
import sprites.*;
import sprites.maths.*;
import sprites.utils.*;

StopWatch sw = new StopWatch();

// Para los personajes
PersonajePrincipal yue;


int pantalla = 0;
PImage inicio = new PImage();
Menu menu;
Escenario escenario;

int test = 1;

void setup() {
  size(800, 600);
  inicio = loadImage("data/inicio.jpg");
  menu = new Menu("data/menu.jpg");
  escenario = new Escenario("data/escenarios/");


  // Para la carga de los Sprites:
  yue = new PersonajePrincipal(this, "data/sprites/PersonajePrin.png");
}


void draw() {

  // Get the elapsed time and updatre the sprites accordingly
  float elapsedTime = (float) sw.getElapsedTime();
  S4P.updateSprites(elapsedTime);

  //println("UP = " + str(UP));
  switch(pantalla) {
  case 0: // Inicio (Aquí colocar audio)
    // Aquí dubujar lo nesario
    image(inicio, 0, 0);  //Dibujando el inicio

    break;
  case 1: // Menu (Aquí colocar audio)
    // Aquí dubujar lo nesario
    menu.dibujar();
    break;
  case 2: // Opciones
    // Aquí dubujar lo nesario
    background(0);
    text("Aquí van las opciones", width/2, height/2);
    text("Presione espacio para salir", width/2, (height/2) + 120);

    break;
  case 3: // Controles
    // Aquí dubujar lo nesario
    background(0);
    text("Aquí van los controles", width/2, height/2);
    text("Presione espacio para salir", width/2, (height/2) + 120);

    break;
  case 4: // Créditos
    // Aquí dubujar lo nesario
    background(0);
    text("Aquí van los créditos", width/2, height/2);
    text("Presione espacio para salir", width/2, (height/2) + 120);

    break;
  case 5: // Jugar
    // Aquí dubujar lo nesario
    /*
      background(0);
     text("Aquí empieza a jugar", width/2, height/2);
     */

    escenario.dibujar();
    yue.dibujar();
    yue.establecerPosicion( escenario.ubicacionI, escenario.ubicacionJ);
    yue.verficarMoviento( escenario.escenarioInfo );
    if ( escenario.escenarioInfo[escenario.ubicacionI][escenario.ubicacionJ] == '0' && !yue.moviendose ) {
      escenario.cambiarEscenario(constrain(escenario.mostrandoFondo + 1,0,5),'F');
    }
    if ( escenario.escenarioInfo[escenario.ubicacionI][escenario.ubicacionJ] == '3' && !yue.moviendose ) {
      escenario.cambiarEscenario(constrain(escenario.mostrandoFondo - 1,0,5),'G');
    }

    break;
  default:
    // Aquí dubujar lo nesario
    break;
  }
}

void keyPressed() {

  switch(pantalla) {
  case 0: // Inicio (Aquí colocar audio)
    // Cambiar al menú
    pantalla = 1;

    break;
  case 1: // Menu (Aquí colocar audio)


    break;
  case 2: // Opciones
    // Volver al menú  
    if (key == 32) {
      pantalla = 1;
    }
    break;
  case 3: // Controles
    // Volver al menú
    if (key == 32) {
      pantalla = 1;
    }
    break;
  case 4: // Créditos
    // Volver al menú  
    if (key == 32) {
      pantalla = 1;
    }
    break;
  case 5: // Jugar
    // Cambiando escenarios
    if (key == 32) {
      escenario.cambiarEscenario(test,'F');
      test = constrain(test + 1, 0, 5);
    }
    escenario.keyPressed(yue.sePuedeMover);


    break;
  default:
    // Aquí dubujar lo nesario
    break;
  }
}
