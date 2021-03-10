abstract class Boton  {
  //Atributos
  String nombre;
  PFont tipoLetra;
  int posX, posY, ancho, alto;


  //Constructor
  Boton(String nombre, int posX, int posY, int ancho, int alto) {
    this.nombre = nombre;
    this.posX = posX;
    this.posY = posY;
    this.ancho = ancho;
    this.alto = alto;
    this.tipoLetra = createFont("Blackadder ITC", 48);
  }


  //Métodos
  void dibujar() {
    this.mouseEncima();
    textAlign(CENTER);
    textFont(tipoLetra);
    text(nombre, posX-(ancho/2), posY-(alto/2), ancho, alto);
  }

  void mouseEncima() {
    // Verificar la posición del cursor
    if ( mouseX > ( posX-(ancho/2) ) &&  mouseX < ( posX+(ancho/2) ) && mouseY > ( posY-(alto/2) ) && mouseY < posY+(alto/2) ) { // Cursor encima

      fill(#A7A7A7);

      if ( mousePressed && mouseButton == LEFT ) {
        funcion();
      }
    } else { // cursor no encima

      fill(255);
    }
  }

  void funcion() { // función a modificar para botón!

    
  }
}
