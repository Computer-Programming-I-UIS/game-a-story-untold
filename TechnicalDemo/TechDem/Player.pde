class Player
{
  private float m_posX, m_posY, m_speed, m_distanceTravelled;
  private boolean m_isMoving, m_isRunning, m_checkTile;
  private int m_direction, m_spriteFrame, m_spriteCount;
  private PImage m_sprite, m_imgFrame;
  Monster[] m_monsterTeam;
  private int[] m_itemList = new int[4];

  Player(float posX, float posY, PImage sprite, Monster[] monsterTeam)
  {
    m_posX = posX;
    m_posY = posY;
    m_sprite = sprite;
    m_spriteCount = m_sprite.width/tileSize;

    m_isMoving = false;
    m_isRunning = false;
    m_distanceTravelled = 0;
    m_speed = 0.5;
    m_direction = 0;
    
    m_monsterTeam = monsterTeam;
    m_itemList[0] = 5;
    m_itemList[1] = 5;
  }

  void display()
  {
    m_checkTile = false;
    fill(255, 255, 255, 100);

    if (m_isRunning) m_speed = 1.0;
    if (m_isRunning == false) m_speed = 0.5;

    if (m_isMoving == true && m_distanceTravelled < tileSize)
    {
      if (m_direction == 0) m_posX += m_speed;
      if (m_direction == 1) m_posY += m_speed;
      if (m_direction == 2) m_posX -= m_speed;
      if (m_direction == 3) m_posY -= m_speed;
      m_distanceTravelled += m_speed;
      m_checkTile = false;
    }

    if (m_distanceTravelled >= tileSize)
    {
      m_isMoving = false;//no longer moving
      m_isRunning = false;
      m_checkTile = true;
     
      if (m_direction == 0) m_posX -= forceBack;
      if (m_direction == 1) m_posY -= forceBack;
      if (m_direction == 2) m_posX += forceBack;
      if (m_direction == 3) m_posY += forceBack;
      m_posX = round(m_posX);
      m_posY = round(m_posY);

      m_distanceTravelled = 0;

      if (m_spriteFrame == 0)
      {
        m_spriteFrame = 1;
      }
      else
      {
        m_spriteFrame = 0;
      }
    }
    handleSprite();
  }

  void move(int direction)
  {  
    m_direction = direction;
    m_isMoving = true;
  }
  
  boolean getIsMoving()
  {
    return m_isMoving;
  }

  float getPosX()
  {
    return m_posX;
  }

  float getPosY()
  {
    return m_posY;
  }
  
  int getDirection()
  {
    return m_direction;
  }
  
  boolean getCheckTile()
  {
    return m_checkTile;
  }
  
  int getItemCount(int index)
  {
    return m_itemList[index];
  }
  
  void setItemCount(int index, int amount)
  {
    m_itemList[index] = amount;
  }
  
  void setRunState(boolean state)
  {
    m_isRunning = state;
  }
  
  void setMoveState(boolean state)
  {
    m_isMoving = state;
  }

  void setPosition(float x, float y)
  {
    m_posX = x;
    m_posY = y;
  }
  
  void setDirection(int direction)
  {
    m_direction = direction;
  }
  
  //code involving pokemon
  Monster getPlayerMonster(int index)
  {
    return m_monsterTeam[index];
  }
  
  Monster[] getPlayerTeam()
  {
    return m_monsterTeam;
  }
  
  void addMonsterToPlayerTeam(Monster caughtMonster)
  {
    m_monsterTeam = (Monster[]) append(m_monsterTeam, caughtMonster);
  }
  
  void setPlayerTeam(Monster[] importData)//load in the new player's team from the save file
  {
    m_monsterTeam = new Monster[0];//reset the array first
    m_monsterTeam = importData;
  }
  
  void reduceMonsterHP(int amount)
  {
    m_monsterTeam[0].reduceHP(amount);
    m_monsterTeam[1].reduceHP(amount);
    m_monsterTeam[2].reduceHP(amount);
  }
  
  void swapMonster(int target, int replacer)
  {
    Monster dataHolder;//make an additional local monster ( to store data )
    dataHolder = m_monsterTeam[target];//copy data from our current monster and place it in the holder
    m_monsterTeam[target] = m_monsterTeam[replacer];//overwrite data from the one we will replace it with
    m_monsterTeam[replacer] = dataHolder;//now we have 2 times the same monster, use the dataholder to overwrite the first monster in this slot 
  }
  
  void healAllPokemon()
  {
    for(int i = 0; i<m_monsterTeam.length; ++i)
    {
      m_monsterTeam[i].setHP(m_monsterTeam[i].getMonsterMaxHP());//set the HP of each pokemon from the player's team to its max HP
    }
  }
  
  void handleSprite()
  {
    //m_sprite.width/spriteCount is the width for each sprite 

    //if the distance the character travelled is less than half of the max distance, show sprite where it stands still
    //if the distance of the character is higher than half of the max distance, show sprite where it walks forward    
    int m_frameNumber = 0;
    //walking sprites
    if (m_distanceTravelled < tileSize/2)
    {
      if(m_isRunning == false)//if the character is not running, show walking sprites
      {
        if (m_direction == 1) m_frameNumber = 0;
        else if (m_direction == 0) m_frameNumber = (m_sprite.width/m_spriteCount)*6;
        else if (m_direction == 2) m_frameNumber = (m_sprite.width/m_spriteCount)*9;
        else if (m_direction == 3) m_frameNumber = (m_sprite.width/m_spriteCount)*3;
      }
      else if(m_isRunning)//if the character is running, show the running sprites
      {
        if (m_direction == 1) m_frameNumber = (m_sprite.width/m_spriteCount)*14;
        else if (m_direction == 0) m_frameNumber = (m_sprite.width/m_spriteCount)*20;
        else if (m_direction == 2) m_frameNumber = (m_sprite.width/m_spriteCount)*23;
        else if (m_direction == 3) m_frameNumber = (m_sprite.width/m_spriteCount)*17;
      }
    }
    //running sprites
    if (m_distanceTravelled >= tileSize/2)
    {
      if (m_spriteFrame == 0 && m_isRunning == false)
      {
        if (m_direction == 1) m_frameNumber = (m_sprite.width/m_spriteCount)*1;
        else if (m_direction == 0) m_frameNumber = (m_sprite.width/m_spriteCount)*7;
        else if (m_direction == 2) m_frameNumber = (m_sprite.width/m_spriteCount)*10;
        else if (m_direction == 3) m_frameNumber = (m_sprite.width/m_spriteCount)*4;
      } 
      else if(m_spriteFrame == 0 && m_isRunning == true)
      {
        if(m_direction == 3) m_frameNumber = (m_sprite.width/m_spriteCount)*16;
        else if (m_direction == 2) m_frameNumber = (m_sprite.width/m_spriteCount)*22;
        else if (m_direction == 0) m_frameNumber = (m_sprite.width/m_spriteCount)*19;
        else if (m_direction == 1) m_frameNumber = (m_sprite.width/m_spriteCount)*13;
      }
      else if (m_spriteFrame == 1 && m_isRunning == false)
      {
        if (m_direction == 1) m_frameNumber = (m_sprite.width/m_spriteCount)*2;
        else if (m_direction == 0) m_frameNumber = (m_sprite.width/m_spriteCount)*8;
        else if (m_direction == 2) m_frameNumber = (m_sprite.width/m_spriteCount)*11;
        else if (m_direction == 3) m_frameNumber = (m_sprite.width/m_spriteCount)*5;
      }
      else if(m_spriteFrame == 1 && m_isRunning == true)
      {
        if (m_direction == 1) m_frameNumber = (m_sprite.width/m_spriteCount)*12;
        else if (m_direction == 0) m_frameNumber = (m_sprite.width/m_spriteCount)*18;
        else if (m_direction == 2) m_frameNumber = (m_sprite.width/m_spriteCount)*21;
        else if (m_direction == 3) m_frameNumber = (m_sprite.width/m_spriteCount)*15;
      }
    }

    //show the player sprite
    m_imgFrame = m_sprite.get(m_frameNumber,0,m_sprite.width/m_spriteCount, m_sprite.height);
    image(m_imgFrame, m_posX+tileSize-m_imgFrame.width, m_posY+tileSize-m_imgFrame.height);
  }
  //END void handleSprite()
}
