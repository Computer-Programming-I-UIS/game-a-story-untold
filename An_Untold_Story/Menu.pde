class Menu {
  // Atributos
  PImage fondo;
  BotonMenu botonOpciones;
  BotonMenu botonControles;
  BotonMenu botonCreditos;
  BotonMenu botonJugar;
  
  // Constructor
  Menu( String nombreFondo ){
    
    fondo = new PImage();
    fondo = loadImage(nombreFondo);
    
    //Botones
    //BotonMenu(String nombre, int posX, int posY, int ancho, int alto, int nextPantalla) 
    botonJugar = new BotonMenu("Jugar", width/2, (height/2), 200, 60, 5);
    botonOpciones = new BotonMenu("Opciones", width/2, (height/2)+60, 200, 60, 2);
    botonControles = new BotonMenu("Controles", width/2, (height/2)+120, 200, 60, 3);
    botonCreditos = new BotonMenu("Creditos", width/2, (height/2)+180, 200, 60, 4);
    
  }
  
  // Mátodos
  void dibujar() {
    image(fondo, 0, 0); 
    botonOpciones.dibujar();
    botonControles.dibujar();
    botonCreditos.dibujar();
    botonJugar.dibujar();
    
  }
  
  
  
}
