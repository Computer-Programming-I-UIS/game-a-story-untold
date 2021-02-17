class jugador{

  float m_posX, m_posY, m_speed;
  PImage m_sprite;
  boolean m_isMoving, m_isRunning;
  
  jugador(float posX, float posY, PImage sprite ){
   m_posX = posX;
   m_posY = posY;
   m_sprite = sprite;
   
   m_isMoving = false;
   m_isRunning = false;
   m_speed = 0.5; 
  }
  void display()
  {
  if (m_isRunning) m_speed = 1.0;
  if (m_isRunning == false) m_speed = 0.5;
  
  }




}
