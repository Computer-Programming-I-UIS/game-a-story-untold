class PersonajePrincipal extends Personaje {
  // Atributos
  boolean sePuedeMover[]; // 0 -> arriba, 1 -> abajo, 2 -> derecha, 3 -> izquierda
  int enX, enY;
  boolean moviendose = false;

  // Constructor
  PersonajePrincipal(PApplet theApplet, String spriteSheet) {
    super(theApplet, spriteSheet);
    sePuedeMover = new boolean[4];
    for(int i = 0 ; i < 4; i++) {
      sePuedeMover[i] = true;
    }
  }

  // Métodos
  void dibujar() {
    //for(int i = 0 ; i < 4; i++) {
      //fill(0,0,255);
      //text(str(int(sePuedeMover[i])), 600 + i*50,20);
   // }
    
    pushMatrix();
    translate(width/2, height/2);
    personaje.draw();
    popMatrix();
    this.keyPressed();

    if (pixelesMovidos < unidadPixel) {
      pixelesMovidos++;
      switch(ultimaTecla) {
      case UP:
        personaje.setFrameSequence(12, 15, tazaDeRefresco);
        break;
      case DOWN:
        personaje.setFrameSequence(0, 3, tazaDeRefresco);       
        break;
      case LEFT:
        personaje.setFrameSequence(4, 7, tazaDeRefresco);
        break;
      case RIGHT:
        personaje.setFrameSequence(8, 11, tazaDeRefresco);
        break;
      }
    } else moviendose = false;
  }

  void keyPressed() {
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
      if ( (keyCode == UP || keyCode == DOWN || keyCode == LEFT || keyCode == RIGHT) && moverse) {
        ultimaTecla = keyCode;
        pixelesMovidos = 0;
        println("Me ejecuté bro!");
        moviendose = true;
      }
    } else if (!moviendose) {
      switch(keyCode) {
      case UP:
        personaje.setFrameSequence(12, 12, tazaDeRefresco);
        break;
      case DOWN:
        personaje.setFrameSequence(0, 0, tazaDeRefresco);       
        break;
      case LEFT:
        personaje.setFrameSequence(4, 4, tazaDeRefresco);
        break;
      case RIGHT:
        personaje.setFrameSequence(8, 8, tazaDeRefresco);
        break;
      }
    }
  }

  void establecerPosicion(int i, int j) {
    enY = i;
    enX = j;
    //println("Estoy en i = " + str(i));
    //println("Estoy en j = " + str(j));
  }

  void verficarMoviento (char [][] escena) {
    
    int numColumnas = escena[0].length;
    int numFilas = escena.length;
    //println("numFilas = " + str(numFilas));
    //println("numColumnas = " + str(numColumnas));
    
    if (enX <= 0) { // el personaje está contra la pared izquierda de la img
      sePuedeMover[3] = false; // el personaje NO se puede mover hacia la izquierda
    } else {
      if(escena[enY][enX-1] == '1' || escena[enY][enX-1] == '2') sePuedeMover[3] = false; 
      else sePuedeMover[3] = true; 
    }
    if (enX >= numColumnas-1) {
      sePuedeMover[2] = false; // el personaje NO se puede mover hacia la derecha
    } else {
      if(escena[enY][enX+1] == '1' || escena[enY][enX+1] == '2') sePuedeMover[2] = false; 
      else sePuedeMover[2] = true;
    }
    if (enY >= (numFilas-1)) {
      sePuedeMover[1] = false; // el personaje NO se puede mover hacia abajo
    } else {
      if(escena[enY+1][enX] == '1' || escena[enY+1][enX] == '2') sePuedeMover[1] = false; 
      else sePuedeMover[1] = true;
    }
    if (enY <= 0) {
      sePuedeMover[0] = false; // el personaje NO se puede mover hacia arriba
    } else {
      if(escena[enY-1][enX] == '1' || escena[enY-1][enX] == '2') sePuedeMover[0] = false; 
      else sePuedeMover[0] = true;
    }
  }
}
