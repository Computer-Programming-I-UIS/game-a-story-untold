class Escenario {
  //Atributos
  PImage fondos[];
  int cantidadEscenarios = 6;
  int mostrandoFondo = 0;
  int posX, posY, unidadPixel, laFenX, laFenY;
  int ultimaTecla, pixelesMovidos = 0;
  int velDesp = 2;
  char escenarioInfo[][];
  int numeroColumnas, numeroFilas;
  //Para el personaje principal
  int ubicacionI, ubicacionJ;

  //Constructor 
  Escenario(String nombreFondo) {
    int resizeScale = 3;
    fondos = new PImage[cantidadEscenarios];
    for (int indice = 0; indice < cantidadEscenarios; indice++) {
      fondos[indice] = loadImage(nombreFondo + "Escenario" + str(indice+1) + ".bmp");
      fondos[indice].resize(fondos[indice].width*resizeScale, fondos[indice].height*resizeScale);
      unidadPixel = 16 * resizeScale;
    }
    posX = 0;
    posY = 0;
    cargarMatriz(mostrandoFondo+1,'F');
  }


  //Métodos
  void dibujar() {
    background(0);
    pushMatrix();
    translate(laFenX, laFenY);
    translate(width/2, height/2);
    //imageMode(CORNER);
    image(fondos[mostrandoFondo], posX, posY);
    popMatrix();

    if (pixelesMovidos < unidadPixel) {
      pixelesMovidos += velDesp;
      switch(ultimaTecla) {
      case UP:
        posY += velDesp;
        break;
      case DOWN:
        posY -= velDesp;          
        break;
      case LEFT:
        posX += velDesp;
        break;
      case RIGHT:
        posX -= velDesp;
        break;
      }
    }
  }

  void cambiarEscenario(int mostrandoFondo, char aparacion) {
    this.mostrandoFondo = mostrandoFondo;
    cargarMatriz(mostrandoFondo+1,aparacion);
  }

  void keyPressed(boolean [] sePuedeMover) {
    boolean moverse = false;
    if (keyPressed && key == CODED && pixelesMovidos == unidadPixel) {

      switch(keyCode) {
      case UP:
        moverse = sePuedeMover[0];
        break;
      case DOWN:
        moverse = sePuedeMover[1];
        break;
      case LEFT:
        moverse = sePuedeMover[3];
        break;
      case RIGHT:
        moverse = sePuedeMover[2];
        break;
      }
    }
    if (key == CODED && pixelesMovidos == unidadPixel) {
      if ( (keyCode == UP || keyCode == DOWN || keyCode == LEFT || keyCode == RIGHT) && moverse ) {

        ultimaTecla = keyCode;
        pixelesMovidos = 0;
        switch(ultimaTecla) {
        case UP:
          if (ubicacionI != 0) ubicacionI --;
          break;
        case DOWN:
          if (ubicacionI != numeroFilas - 1) ubicacionI ++;          
          break;
        case LEFT:
          if (ubicacionJ != 0) ubicacionJ --; 
          break;
        case RIGHT:
          if (ubicacionJ != numeroColumnas - 1) ubicacionJ ++; 
          break;
        }
      }
    }
  }


  void cargarMatriz(int numEscena, char aparicion) {

    String[] lines = loadStrings("data/colisiones/Escenario" + str(numEscena) + ".txt");
    println("there are " + lines.length + " lines");
    println("Each line has " + lines[0].length() + " characters");
    for (int i = 0; i < lines.length; i++) {
      println(lines[i]);
    }

    numeroColumnas = lines[0].length();
    numeroFilas = lines.length;
    escenarioInfo = new char[numeroFilas][numeroColumnas];
    for (int i = 0; i < numeroFilas; i++) {
      for (int j = 0; j < numeroColumnas; j++) {
        escenarioInfo[i][j] = lines[i].charAt(j);
      }
    }

    println("La matriz es: ");
    for (int i = 0; i < numeroFilas; i++) {
      for (int j = 0; j < numeroColumnas; j++) {
        print(escenarioInfo[i][j]);
      }
      println(" ");
    }

    posX = 0;
    posY = 0;
    // Buscando la F
    for (int i = 0; i < numeroFilas; i++) {
      for (int j = 0; j < numeroColumnas; j++) {
        if (escenarioInfo[i][j] == aparicion) {
          println("j = " + str(j));
          println("i = " + str(i));
          ubicacionI = i;
          ubicacionJ = j;
          laFenY = (floor(numeroFilas/2) - i)*unidadPixel ;
          laFenX = (floor(numeroColumnas/2) - j)*unidadPixel ;
        }
      }
    }

    // Una pequeña "Calibración"
    if (mostrandoFondo > 1) laFenX -= unidadPixel/2;
    else laFenX += 0;
    if (mostrandoFondo == 1) laFenY += unidadPixel/2;
    else laFenY += 0;



    // el centro está en 
    // x = floor(numeroColumnas/2);
    // y = floor(numeroFilas/2);
  }
}
