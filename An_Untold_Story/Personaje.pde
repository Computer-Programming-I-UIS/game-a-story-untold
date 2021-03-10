abstract class Personaje {
  // Atributos
  Sprite personaje;
  float tazaDeRefresco = 0.1; // tiempo en segundos para refrescar el Sprite
  int unidadPixel;
  int ultimaTecla, pixelesMovidos = 0;

  // Constructor
  Personaje(PApplet theApplet, String spriteSheet) {
    float resizeScale = 3;
    personaje = new Sprite(theApplet, spriteSheet, 4, 4, 0);
    personaje.setFrameSequence(0, 0, tazaDeRefresco);
    personaje.setScale(resizeScale/2);
    unidadPixel = round(16 * resizeScale);
  }

  // Métodos
  void dibujar() {
    pushMatrix();
    translate(width/2, height/2);
    personaje.draw();
    popMatrix();
  }

  
}
