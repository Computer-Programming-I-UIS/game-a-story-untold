class BotonMenu extends Boton {
  //Atributos
  int nextPantalla;
  
  //Constructor
  BotonMenu(String nombre, int posX, int posY, int ancho, int alto, int nextPantalla) {
    super(nombre, posX, posY, ancho, alto);
    this.nextPantalla = nextPantalla;
  }
  
  //Métodos
  void funcion() { // función a modificar para botón!
  
    pantalla = nextPantalla;
    
  }
  
}
