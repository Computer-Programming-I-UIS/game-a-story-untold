class Monster
{
  //HP Iv = between 10 and 20 / other IVs betweem 3 and 10
  private int m_lvl,m_maxHP,m_att,m_def,m_spd,m_currentHP, m_exp, m_expMax;
  private int m_ID, m_HPIV, m_attIV, m_defIV, m_spdIV;
  private String m_name, m_type;
  private float m_posX, m_posY;//we will use positions to place our sprite on the battlefield
  private PImage m_sprite;
  Move[] m_moveset = new Move[0];
  
  
  Monster(int ID, int level, int HPIV, int attIV, int defIV, int spdIV, float posY, float posX)
  {
    m_lvl = level;
    //store the IVs(individual values)
    m_HPIV = HPIV;
    m_attIV = attIV;
    m_defIV = defIV;
    m_spdIV = spdIV;
    m_posX = posX;
    m_posY = posY;
    
    //calculate monster stats with level and IV
    m_maxHP = m_lvl*HPIV;
    m_att = m_lvl*attIV;
    m_def = m_lvl*defIV;
    m_spd = m_lvl*spdIV;
    m_currentHP = m_maxHP;//when this monster is created, it starts with full health
    
    m_name = pokemonList[ID];//pokemonList[] contains names of the monsters
    m_ID = ID;
    
    //load in the data for the monster(type, moves)
    String[] loadFile = loadStrings("data/scripts/monsterData.txt");
    String[] dissection = split(loadFile[ID], "/");
    m_type = dissection[1];
    
    //for the demo, our monsters will not yet learn new moves
    for(int i = 2; i<dissection.length; ++i)
    {
      m_moveset = (Move[]) append(m_moveset, new Move(int(dissection[i])));
    }
  }
  
  void display()
  {
    fill(255);
    image(m_sprite, m_posX, m_posY);
  }
  
  void raiseLevel()
  {
    m_lvl++;
    m_maxHP = m_lvl*m_HPIV;
    m_att = m_lvl*m_attIV;
    m_def = m_lvl*m_defIV;
    m_spd = m_lvl*m_spdIV;  
  }
  
  void raiseExp(int amount)
  {
    m_expMax = (m_lvl+1)*125;//amount of expierence needed to level up (next level * 100(ex. at level5, level 6 requires 750 exp)
    m_exp += amount;
    
    if(m_exp >= m_expMax)//if we level up
    {
      raiseLevel();//increase our level and calculate our stats
      m_exp -= m_expMax;//if we get more exp than the limit we need to level up, make sure we do not lose this progress on the next level
    }
  }
  
  int getMonsterHP()
  {
    return m_currentHP;
  }
  
  int getMonsterMaxHP()
  {
    return m_maxHP;
  }
  
  String getMonsterName()
  {
    return m_name;
  }
  
  int getMonsterID()
  {
    return m_ID;
  }
  
  String getType()
  {
    return m_type;
  }
  
  int getMonsterSpeed()
  {
    return m_spd;
  }
  
  int getMonsterAtt()//used in damage calculation
  {
    return m_att;
  }
  
  int getMonsterDef()
  {
    return m_def;
  }
  
  int getMonsterLvl()//used in calculated the amount of expierenced gained when defeating this monster
  {
    return m_lvl;
  }
  
  int getMonsterEXP()
  {
    return m_exp;
  }
  
  int getMonsterMaxEXP()
  {
    return m_expMax;
  }
  
  void reduceHP(int amount)
  {
    m_currentHP -= amount;
  }
  
  void setHP(int amount)
  {
    m_currentHP = amount;
  }
  
  void setPosition(float x, float y)
  {
    m_posX = x;
    m_posY = y;
  }
  
  void setSprite(PImage sprite)
  {
    m_sprite = sprite;
  }
  
  //moveset data
  int getMonsterMoveDamage(int index)
  {
    return m_moveset[index].getMoveDmg();
  }
  
  String getMonsterMoveName(int index)
  {
    if(index < m_moveset.length)
    {
      return m_moveset[index].getMoveName();  
    }
    else
    {
      return "-----";
    }
  }
  
  int getMonsterMovesAmount()
  {
    return m_moveset.length;
  }
  
  String getMonsterMoveType(int index)
  {
    return m_moveset[index].getType();
  }
  
  String getPokemonData()//this is called when saving the game
  {
    String fullData = "-100"+"/"+str(m_ID)+"/"+ str(m_lvl)+"/"+ str(m_currentHP)+"/"+ str(m_HPIV)+"/"+ str(m_attIV)+"/"+ str(m_defIV)+"/"+ str(m_spdIV);
    return fullData;
  }
}
