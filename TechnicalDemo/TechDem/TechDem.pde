import processing.sound.*;

Player player;
Collision[] blokje = new Collision[0];//COLISIONES
OverworldObject[] map01obj = new OverworldObject[0];//OBJETOS INTERACTIVOS
OverworldObject[] overworldSprites = new OverworldObject[0];//SPRITES (such as rooftops)
OverworldObject[] mapTransitions = new OverworldObject[0];//NOTIFICACION CAMBIO ENTRE ZONAS
OverworldObject[] warpTiles = new OverworldObject[0];//CUANDO EL JUGADOR ENTRA A UNA PUERTA
OverworldObject[] grassPatches = new OverworldObject[0];

//map parameters
final int rows = 20;
final int columns = 50;
final int tileSize = 16;
float owScaler = 3.0;
int currentArea;
int notificationTimer = 0;
String[] areaName = {"TOWN", "ROUTE"};
boolean grasspatchTick;


float pPosX,pPosY;
boolean pLeft, pRight, pDown, pUp, pRun;

PImage pSprite, npcSprite01, npcSprite02, npcSprite03;
PImage imgArrow, boxFrame01, boxFrame02, boxFrame03, boxFrame04, boxFrame05;
PImage overworldmapImg,house01Img,house02Img,house03Img,tileset01;
PImage trainerSprite01, battleBackground01;
PImage[] pokemonSpritesFront = new PImage[0];
PImage[] pokemonSpritesBack = new PImage[0];
PImage[] pokemonSpritesIcons = new PImage[0];
PImage healthbarBg, healthbarOver, expbarOver;


PFont font;
boolean isInConversation = false; 
int conversationNum = 0;
String[] conversation = new String[0];
boolean owMenuOpened;
int owMenu = -1; 
int menuOption, submenuOption;
int owMenu1storePokemonID = -1;
int owMenu5option1 = 1;
int owMenu5option2;
boolean healPokemon;
boolean giveItems;


int blackoutEffectAlpha;
boolean isTransitioning;
int fadeAmount = 15;
float destinationX, destinationY;

//monster variables
String[] pokemonList = {"BULBASAUR", "CHARMANDER", "SQUIRTLE", "PIDGEY", "RATTATA", "PIKACHU", "VULPIX"};

//battle variables
boolean isBattling = false;
Monster opposingPokemon;
int battleOption;
boolean fightMenu, pokemonMenu, bagMenu;

//other
boolean showFPS;
String resolution;

//progress variables
int pMonsterSeen;
int pMonstersCaught;
int pBattlesWon;
int pPlaytimeFrame, pPlaytimeMin, pPlaytimeHour;
int[] pUniqueMonstersCaught = new int[0];

void setup()
{
  size(1000,700);
  
  frameRate(120);
  noSmooth();
  
  overworldmapImg = loadImage("data/sprites/map01_overworld.png");
  house01Img = loadImage("data/sprites/map01_house01.png");
  house02Img = loadImage("data/sprites/map01_house02.png");
  house03Img = loadImage("data/sprites/map01_house03.png");
  tileset01 = loadImage("sprites/spr_tileset01.png");

  //menu stuff
  boxFrame01 = loadImage("data/sprites/boxFrame01.png");
  boxFrame02 = loadImage("data/sprites/boxFrame02.png");
  boxFrame03 = loadImage("data/sprites/boxFrame03.png");
  boxFrame04 = loadImage("data/sprites/boxFrame04.png");
  boxFrame05 = loadImage("data/sprites/boxFrame05.png");
  imgArrow = loadImage("data/sprites/imgArrow.png");
  font = createFont("data/pkmnrs.ttf", 14);
  textFont(font);
    
  for(int i = 0; i<pokemonList.length; ++i)
  {
    PImage loadedImg = loadImage("data/sprites/spr_pokemon"+i+".png");
    pokemonSpritesFront = (PImage[]) append(pokemonSpritesFront, loadedImg);
    PImage loadedBackImg = loadImage("data/sprites/spr_pokemonback"+i+".png");
    pokemonSpritesBack = (PImage[]) append(pokemonSpritesBack, loadedBackImg);
    PImage loadedIconImg = loadImage("data/sprites/spr_pokemonsmall"+i+".png");
    pokemonSpritesIcons = (PImage[]) append(pokemonSpritesIcons, loadedIconImg);
  }

  pSprite = loadImage("sprites/spr_player01.png");
  Monster[] testPlayerTeam = new Monster[1];
  int playerStarterMonster = int(random(pokemonList.length));
  testPlayerTeam[0] = new Monster(playerStarterMonster, 5, int(random(10,20)), int(random(3,10)), int(random(3,10)), int(random(3,10)), 0, 0);
  pUniqueMonstersCaught = append(pUniqueMonstersCaught, playerStarterMonster);
  player = new Player(tileSize*5,tileSize*7, pSprite, testPlayerTeam);
  
  //npc stuff
  npcSprite01 = loadImage("data/sprites/spr_npc01.png");
  npcSprite02 = loadImage("data/sprites/spr_npc02.png");
  npcSprite03 = loadImage("data/sprites/spr_npc03.png");
  trainerSprite01 = loadImage("data/sprites/spr_trainer01.png");
  battleBackground01 = loadImage("data/sprites/img_battleBackground01.png");
  battleBackground01.resize(width,height);
  
  //battle stuff
  healthbarBg = loadImage("data/sprites/spr_healthbarBg.png");
  healthbarOver = loadImage("data/sprites/spr_healthbarOverlay.png");
  expbarOver = loadImage("data/sprites/spr_expbarOverlay.png");

  loadCollision();
  loadEntities();
}

void loadCollision()
{
  String[] loadFile = loadStrings("data/scripts/map01collision.txt");
  String[] dissection = new String[0];
  
  for(int i = 0; i<loadFile.length; ++i)
  {
    dissection = split(loadFile[i], ",");
   
    if(int(dissection[0]) == 0) blokje = (Collision[]) append(blokje, new Collision(float(dissection[1])*tileSize,float(dissection[2])*tileSize,tileSize));
  } 
}

void loadEntities()
{  
 
  String[] loadEnts = loadStrings("data/scripts/map01entities.txt");
  String[] disectEnts = new String[0];
  for(int i = 0; i<loadEnts.length; ++i)
  {
    disectEnts = split(loadEnts[i], ",");
    if(int(disectEnts[0]) == -5) map01obj = (OverworldObject[]) append(map01obj, new OverworldObject(float(disectEnts[1])*tileSize, float(disectEnts[2])*tileSize, npcSprite03, int(disectEnts[3])));
    if(int(disectEnts[0]) == -4) map01obj = (OverworldObject[]) append(map01obj, new OverworldObject(float(disectEnts[1])*tileSize, float(disectEnts[2])*tileSize, npcSprite02, int(disectEnts[3])));
    if(int(disectEnts[0]) == -3) map01obj = (OverworldObject[]) append(map01obj, new OverworldObject(float(disectEnts[1])*tileSize, float(disectEnts[2])*tileSize, npcSprite01, int(disectEnts[3])));
    if(int(disectEnts[0]) == -2) warpTiles = (OverworldObject[]) append(warpTiles, new OverworldObject(float(disectEnts[1])*tileSize, float(disectEnts[2])*tileSize, null, int(disectEnts[3])));
    if(int(disectEnts[0]) == -1) mapTransitions = (OverworldObject[]) append(mapTransitions, new OverworldObject(float(disectEnts[1])*tileSize, float(disectEnts[2])*tileSize, null, int(disectEnts[3])));
    if(int(disectEnts[0]) > 0 && int(disectEnts[0]) != 10)  map01obj = (OverworldObject[]) append(map01obj, new OverworldObject(float(disectEnts[1])*tileSize, float(disectEnts[2])*tileSize, tileset01.get(int(disectEnts[0])*tileSize,0,tileSize,tileSize), int(disectEnts[3])));
    if(int(disectEnts[0]) == 10) grassPatches = (OverworldObject[]) append(grassPatches, new OverworldObject(float(disectEnts[1])*tileSize, float(disectEnts[2])*tileSize, tileset01.get(int(disectEnts[0])*tileSize,0,tileSize,tileSize), 0));
  }
  
  //overworld sprites that are drawn-over the player
  String[] loadFile = loadStrings("data/scripts/map01overdrawn.txt");
  String[] dissection = new String[0];
  for(int i = 0; i<loadFile.length; ++i)
  {
    dissection = split(loadFile[i], ",");
   
    overworldSprites = (OverworldObject[]) append(overworldSprites, new OverworldObject(float(dissection[1])*tileSize, float(dissection[2])*tileSize, tileset01.get((int(dissection[0])-1)*tileSize, 0, tileSize, tileSize), 1));
  }
}

void draw()
{
  pPlaytimeFrame++;
  if(pPlaytimeFrame >= 120*60)
  {
    ++pPlaytimeMin;
    pPlaytimeFrame = 0;
  }
  if(pPlaytimeMin >= 60)
  {
    ++pPlaytimeHour;
    pPlaytimeMin = 0;
  }
  
  background(0);
  
  if(isBattling)
  {
    image(battleBackground01,0,0);
    
    imageMode(CENTER);
    textAlign(CENTER);
    rectMode(CENTER);
    textSize(24);
    
    
    opposingPokemon.setPosition(width*0.85,height*0.45);
    opposingPokemon.setSprite(pokemonSpritesFront[opposingPokemon.getMonsterID()]);
    opposingPokemon.display();
    image(boxFrame05, width*0.85, height*0.45-130);
    textMessage(width*0.85, height*0.45-130, opposingPokemon.m_name+ " lv."+ opposingPokemon.m_lvl, color(0));
    
  
    player.getPlayerMonster(0).setPosition(width*0.25, height*0.65);
    player.getPlayerMonster(0).setSprite(pokemonSpritesBack[player.getPlayerMonster(0).getMonsterID()]);
    player.getPlayerMonster(0).display();
    image(boxFrame05, width*0.25, height*0.65-150);
    textMessage(width*0.25, height*0.65-150, player.getPlayerMonster(0).m_name+ " lv."+ player.getPlayerMonster(0).m_lvl, color(0));

    if(isInConversation == true) 
    {
      conversationHandler(1);
    }
    else
    {
      image(boxFrame05, width/2, height*0.75);
      image(boxFrame05, width/2-boxFrame05.width*0.75, height*0.85);
      image(boxFrame05, width/2+boxFrame05.width*0.75, height*0.85);
      image(boxFrame05, width/2, height*0.95);
      color c = 0;
      
      if(fightMenu == true)
      {
  
        textMessage(width/2,height*0.75+10,player.getPlayerMonster(0).getMonsterMoveName(0), color(30,30,30));  
        textMessage(width/2-boxFrame05.width*0.75,height*0.85+10,player.getPlayerMonster(0).getMonsterMoveName(1), color(30,30,30));
        textMessage(width/2+boxFrame05.width*0.75,height*0.85+10,player.getPlayerMonster(0).getMonsterMoveName(2), color(30,30,30));
        textMessage(width/2,height*0.95+10,player.getPlayerMonster(0).getMonsterMoveName(3), color(30,30,30));
      }
      else if(pokemonMenu == true)//the user clicked on POKEMON in the battle menu
      {
        textMessage(width/2,height*0.75+10,player.getPlayerMonster(0).getMonsterName(), color(0,100,0));
        if(player.getPlayerTeam().length >= 2) 
        {
          if(player.getPlayerMonster(1).getMonsterHP() <= 0) c = color(200,0,0);
          else c = 0;
          textMessage(width/2-boxFrame05.width*0.75,height*0.85+10,player.getPlayerMonster(1).getMonsterName(), color(c));
        }
        if(player.getPlayerTeam().length >= 3) 
        {
          if(player.getPlayerMonster(2).getMonsterHP() <= 0) c = color(200,0,0);
          else c = 0;
          textMessage(width/2+boxFrame05.width*0.75,height*0.85+10,player.getPlayerMonster(2).getMonsterName(), color(c));
        }
        if(player.getPlayerTeam().length >= 4) 
        {
          if(player.getPlayerMonster(3).getMonsterHP() <= 0) c = color(200,0,0);
          else c = 0;
          textMessage(width/2,height*0.95+10,player.getPlayerMonster(3).getMonsterName(), color(c));
        }
      }
      else if(bagMenu == true)
      {
        if(player.getItemCount(0) <= 0) c = color(200,0,0);
        else c = 0;
        textMessage(width/2,height*0.75+10,"POKéBALL x"+player.getItemCount(0), c);
        if(player.getItemCount(1) <= 0) c = color(200,0,0);
        else c = 0;
        textMessage(width/2-boxFrame05.width*0.75,height*0.85+10,"POTION x"+player.getItemCount(1), c);
        c = 0;//the unused item slots are just colored black
        textMessage(width/2+boxFrame05.width*0.75,height*0.85+10,"-----", c);
        textMessage(width/2,height*0.95+10,"-----", c);
      }
      else if(fightMenu == false && pokemonMenu == false && bagMenu == false)
      {
        textMessage(width/2,height*0.75+10,"FIGHT", color(200,0,0));//fight text
        textMessage(width/2-boxFrame05.width*0.75,height*0.85+10,"POKéMON", color(0,0,200));
        textMessage(width/2+boxFrame05.width*0.75,height*0.85+10,"BAG", color(0,50,0));
        textMessage(width/2,height*0.95+10,"RUN", color(30,30,30));
      }
        
  
      noFill();
      stroke(225,0,0);
      strokeWeight(8);
      if(battleOption == 0) rect(width/2,height*0.75,boxFrame05.width, boxFrame05.height);
      else if(battleOption == 3) rect(width/2,height*0.95,boxFrame05.width, boxFrame05.height); 
      else if(battleOption == 1) rect(width/2-boxFrame05.width*0.75,height*0.85,boxFrame05.width, boxFrame05.height); 
      else if(battleOption == 2) rect(width/2+boxFrame05.width*0.75,height*0.85,boxFrame05.width, boxFrame05.height);  
    }
    
    imageMode(CORNER);
    textAlign(LEFT);
    rectMode(CORNER);
    

    drawInfoBar(width*0.85-boxFrame05.width*0.4, height*0.27, opposingPokemon.getMonsterHP(), opposingPokemon.getMonsterMaxHP(), opposingPokemon.getMonsterEXP(), opposingPokemon.getMonsterMaxEXP());
    drawInfoBar(width*0.25-boxFrame05.width*0.4, height*0.44, player.getPlayerMonster(0).getMonsterHP(), player.getPlayerMonster(0).getMonsterMaxHP(), player.getPlayerMonster(0).getMonsterEXP(), player.getPlayerMonster(0).getMonsterMaxEXP());
  }
  else //drawing the overworld phase
  {
    pushMatrix();
    translate(width/2,height/2); 
    scale(owScaler);
  
    translate(player.getPosX()*-1-(tileSize/2),player.getPosY()*-1-(tileSize/2));
    drawOverworldmap();
    
    

    noFill();
    for(int i = 0; i<columns; ++i)
    {   
      for(int j = 0; j<rows; ++j)
      {
        rect(i*tileSize,j*tileSize,tileSize,tileSize);
      }
    }
    
    if(owMenuOpened == false && isInConversation == false)
    {
      if(player.getIsMoving() == false)
      {
        if(pUp) checkCollision(3);
        else if(pDown) checkCollision(1);      
        else if(pLeft) checkCollision(2);
        else if(pRight) checkCollision(0);
        if(pRun)
        {
          player.setRunState(true);
        }
        else
        {
          player.setRunState(false);
        }
      }    
    }
    
    for(int i = 0; i<map01obj.length; ++i)
    {
      map01obj[i].display();  
    }
    
    for(int i = 0; i<grassPatches.length; ++i)
    {
      grassPatches[i].display();
      if(player.getCheckTile() && player.getPosX() == grassPatches[i].getPosX() && player.getPosY() == grassPatches[i].getPosY())
      {   
        int battleRNGInitializer = int(random(10));//increase for less chance on wild battle
        if(battleRNGInitializer == 0 && player.getPlayerMonster(0).getMonsterHP() > 0 && player.getPlayerTeam().length > 0)
        {
          opposingPokemon = new Monster(int(random(pokemonList.length)), int(random(2,5)), int(random(10,20)), int(random(3,10)), int(random(3,10)), int(random(3,10)), 0, 0);
          isBattling = true;
          player.setMoveState(false);
          pMonsterSeen++;
          println("battle");
        }
      }
    }
    
    player.display();
    

    for(int i = 0; i<overworldSprites.length; ++i)
    {
      overworldSprites[i].display();
    }
  
    popMatrix();
    
    displayOWMenu();
    handleTransitions();
  
    //info text
    fill(0);//black
    textSize(24);
    textAlign(LEFT);
    textLeading(30);
    if(owMenu == -1 || owMenuOpened == false) textMessage(10, 30, "Z or W = Correr\nX = Interactuar\nEnter = Abrir Menu (Cerrar con Z/W)\nFlechas = Movimiento\nO: Zoom+ / L: Zoom- \nR = Reset\nP = Carga ", color(255));
    if(showFPS) textMessage(width/2,height-30,str(frameRate),color(255));  
    
    if(isInConversation == true) conversationHandler(0);
  
    blackoutEffect();
  }
}

void keyPressed()
{
  if(isBattling)
  {
    if(keyCode == UP) battleOption = 0;
    if(keyCode == DOWN) battleOption = 3;
    if(keyCode == LEFT) battleOption = 1;
    if(keyCode == RIGHT) battleOption = 2;
    
    if(isInConversation == true)
    {
      if(key == 'x')
      {
        conversationNum++;
        if(conversationNum >= conversation.length)
        {
          isInConversation = false;
          conversationNum = 0;
          conversation = new String[0];
        }
      }
    }
    else
    {
      
      if((key == 'z' || key == 'w') && player.getPlayerMonster(0).getMonsterHP() > 0)
      {
        fightMenu = false;
        bagMenu = false;
        pokemonMenu = false;
      }
      
      if(key == 'x' && fightMenu == false && pokemonMenu == false && bagMenu == false)
      {
        if(battleOption == 0) fightMenu = true;
        if(battleOption == 1) pokemonMenu = true;
        if(battleOption == 2) bagMenu = true;
        if(battleOption == 3) isBattling = false;
        battleOption = 0;
      }
      else if(key == 'x' && pokemonMenu == true && player.getPlayerTeam().length != 0)
      {
        if(battleOption != 0 && battleOption < player.getPlayerTeam().length && player.getPlayerMonster(battleOption).getMonsterHP() > 0) 
        { 
          player.swapMonster(0, battleOption);
          int opposingPokemonMove =  int(random(opposingPokemon.getMonsterMovesAmount()));  
          isInConversation = true;
          conversation = append(conversation, "Opposing "+ opposingPokemon.getMonsterName() +" used "+ opposingPokemon.getMonsterMoveName(opposingPokemonMove) +" after you\nswapped out " +player.getPlayerMonster(0).getMonsterName() +" !");
          battleMove(opposingPokemon, player.getPlayerMonster(0), opposingPokemonMove);
          pokemonMenu = false;
          battleOption = 0;
        }
      }
      else if(key == 'x' && fightMenu == true && battleOption < player.getPlayerMonster(0).getMonsterMovesAmount())
      {
        isInConversation = true;

        int opposingPokemonMove =  int(random(opposingPokemon.getMonsterMovesAmount()));
        if(player.getPlayerMonster(0).getMonsterSpeed() >= opposingPokemon.getMonsterSpeed())
        {
          conversation = append(conversation, "Your "+ player.getPlayerMonster(0).getMonsterName() +" used "+ player.getPlayerMonster(0).getMonsterMoveName(battleOption));
          battleMove(player.getPlayerMonster(0), opposingPokemon, battleOption);      
          conversation = append(conversation, "Opposing "+ opposingPokemon.getMonsterName() +" used "+ opposingPokemon.getMonsterMoveName(opposingPokemonMove));
          battleMove(opposingPokemon, player.getPlayerMonster(0), opposingPokemonMove);
        }
        else
        {
          conversation = append(conversation, "Opposing "+ opposingPokemon.getMonsterName() +" used "+ opposingPokemon.getMonsterMoveName(opposingPokemonMove));
          battleMove(opposingPokemon, player.getPlayerMonster(0), opposingPokemonMove);       
          conversation = append(conversation, "Your "+ player.getPlayerMonster(0).getMonsterName() +" used "+ player.getPlayerMonster(0).getMonsterMoveName(battleOption));
          battleMove(player.getPlayerMonster(0), opposingPokemon, battleOption);
        }
        fightMenu = false;
        battleOption = 0;
        
        if(opposingPokemon.getMonsterHP() <= 0 || player.getPlayerMonster(0).getMonsterHP() <= 0)
        {
          conversation = new String[0];
          if(player.getPlayerMonster(0).getMonsterHP() <= 0)
          {
            conversation = append(conversation, "Your " +player.getPlayerMonster(0).getMonsterName()+ " was defeated!\nThe wild POKéMON fled!");
          }
          else if(opposingPokemon.getMonsterHP() <= 0)
          {
            conversation = append(conversation, "Opposing " +opposingPokemon.getMonsterName() +" has been defeated!\nYour " +player.getPlayerMonster(0).getMonsterName()+ " gained "+ (opposingPokemon.getMonsterLvl()*100) +" EXP points!");
            player.getPlayerMonster(0).raiseExp(opposingPokemon.getMonsterLvl()*100);
            ++pBattlesWon;
          }
          else
          {
            conversation = append(conversation, "both POKéMON fainted during the battle!");
          }
          isInConversation = true;
          isBattling = false;
        }
      }
      else if(key == 'x' && bagMenu == true)
      {
        if(battleOption < 2)
        {
          conversation = new String[0];
          if(battleOption == 0 && player.getItemCount(0) > 0 && player.getPlayerTeam().length < 4)
          {
            player.setItemCount(0, player.getItemCount(0)-1);
            player.addMonsterToPlayerTeam(opposingPokemon);
            conversation = append(conversation, "You threw a POKéBALL and succesfully \ncaught the "+ opposingPokemon.getMonsterName());
            ++pMonstersCaught;

            boolean hasCaught = false;
            for(int i = 0; i<pUniqueMonstersCaught.length; ++i)
            {
              if(opposingPokemon.getMonsterID() == pUniqueMonstersCaught[i]) hasCaught = true;
            }
            if(hasCaught == false) pUniqueMonstersCaught = append(pUniqueMonstersCaught, opposingPokemon.getMonsterID());
            isBattling = false;
          }
          else if(player.getPlayerTeam().length >= 4) conversation = append(conversation, "You've reached the maximum team capacity!\nThis demo only allows a maximum team of 4.");
          if(battleOption == 1 && player.getItemCount(1) > 0)
          {
            int opposingPokemonMove =  int(random(opposingPokemon.getMonsterMovesAmount()));  
            conversation = append(conversation, "Opposing "+ opposingPokemon.getMonsterName() +" used "+ opposingPokemon.getMonsterMoveName(opposingPokemonMove)+ "\nRight after you healed your POKéMON!");
            player.getPlayerMonster(0).setHP(player.getPlayerMonster(0).getMonsterMaxHP());
            player.setItemCount(1, player.getItemCount(1)-1);//subtract 1 item
            battleMove(opposingPokemon, player.getPlayerMonster(0), opposingPokemonMove); 
          }
          if(conversation.length != 0)
          {
            isInConversation = true;
            bagMenu = false;
            battleOption = 0;
          }
        }
      }
    }
  }
  else 
  {
   
    if(key == 'o') owScaler += 0.2;
    if(key == 'l') owScaler -= 0.2;
    if(key == 'p')//load game
    {
      String[] loadfile = loadStrings("savegame01.txt");
      player.setPosition(float(loadfile[0]), float(loadfile[1]));
      showFPS = boolean(loadfile[2]); 
      surface.setSize(int(loadfile[3]), int(loadfile[4]));
      battleBackground01.resize(width,height);
      player.setItemCount(0, int(loadfile[5]));
      player.setItemCount(1, int(loadfile[6]));
      pMonsterSeen = int(loadfile[7]);
      pMonstersCaught = int(loadfile[8]);
      pBattlesWon = int(loadfile[9]);
      pPlaytimeMin = int(loadfile[10]);
      pPlaytimeHour = int(loadfile[11]);
      
      int loadUniqueMonstersCaught = int(loadfile[12]);
      pUniqueMonstersCaught = new int[0];
      for(int j = 13; j<13+loadUniqueMonstersCaught; ++j)
      {
        pUniqueMonstersCaught = append(pUniqueMonstersCaught, int(loadfile[j]));
      }
      pPlaytimeFrame = 0;

      Monster[] importPlayerMonsterTeam = new Monster[0];
      for(int i = 0; i<loadfile.length; ++i)
      {
        String[] dissection = split(loadfile[i], "/");
        if(int(dissection[0]) == -100)
          importPlayerMonsterTeam = (Monster[]) append(importPlayerMonsterTeam, new Monster(int(dissection[1]), int(dissection[2]), int(dissection[4]), int(dissection[5]), int(dissection[6]), int(dissection[7]), 0, 0));
          importPlayerMonsterTeam[importPlayerMonsterTeam.length-1].setHP(int(dissection[3]));
        }
      }
      player.setPlayerTeam(importPlayerMonsterTeam);
    }
  
    if(keyCode == 10 && isInConversation == false)
    {
      owMenuOpened = !owMenuOpened;
      owMenu = -1;
    }
    
    if(owMenuOpened == false && isInConversation == false && isTransitioning == false)
    {
      if(keyCode == LEFT) pLeft = true;
      if(keyCode == RIGHT) pRight = true;
      if(keyCode == UP) pUp = true;
      if(keyCode == DOWN) pDown = true;
      if(key == 'z' || key == 'w') pRun = true;
      if(key == 'x') 
      {
        checkPlayerInteraction();
        checkWarp();
      }
      if(key == 'r' && player.getIsMoving() == false) player.setPosition(tileSize*5,tileSize*7);
    }
    else if(isInConversation == true)
    {
      if(key == 'x')
      {
        conversationNum++;
        if(conversationNum >= conversation.length)
        {
          if(healPokemon)
          {
            destinationX = player.getPosX();
            destinationY = player.getPosY();
            isTransitioning = true;
            player.healAllPokemon();
            println("healed pokemon.");
          }
          if(giveItems)
          {
            player.setItemCount(0, player.getItemCount(0)+5);
            player.setItemCount(1, player.getItemCount(1)+5);
          }
          isInConversation = false;
          conversationNum = 0;
          conversation = new String[0];
        }
      }
    }
    
    if(owMenu == -1 && owMenuOpened == true)
    {
      if(keyCode == DOWN) menuOption = (menuOption+1)%7;
      if(keyCode == UP) menuOption--;
      if(menuOption < 0) menuOption = 6;
      
      if(key == 'z' || key == 'w') owMenuOpened = false;
      if(key == 'x')
      {
        owMenu = menuOption;
        submenuOption = 0;
      }
    }
    else if(owMenu == 0 && owMenuOpened == true)
    {
      if(key == 'z' || key == 'w') owMenu = -1; 
    }
    else if(owMenu == 1 && owMenuOpened == true)
    {
      if(keyCode == DOWN) submenuOption = (submenuOption+1)%player.getPlayerTeam().length;
      if(keyCode == UP) submenuOption--;
      if(submenuOption < 0) submenuOption = player.getPlayerTeam().length-1;
      if(key == 'x' && owMenu1storePokemonID == -1)
      {
        owMenu1storePokemonID = submenuOption;
      }
      else if(key == 'x' && owMenu1storePokemonID != -1)
      {
        player.swapMonster(owMenu1storePokemonID,submenuOption);
        owMenu1storePokemonID = -1;
      }
      if(key == 'z' || key == 'w') owMenu = -1; 
    }
    else if(owMenu == 2 && owMenuOpened == true)
    {
      if(key == 'z' || key == 'w') owMenu = -1;
    }
    else if(owMenu == 3 && owMenuOpened == true)
    {
      if(key == 'z' || key == 'w') owMenu = -1; 
    }
   
    else if(owMenu == 4 && owMenuOpened == true)
    {
      if(key == 'z' || key == 'w') owMenu = -1;
      if(keyCode == DOWN) submenuOption = 0;
      if(keyCode == UP) submenuOption = 1;
      if(key == 'x' && submenuOption == 0) owMenu = -1;
      if(key == 'x' && submenuOption == 1)
      {
        String[] savefile = new String[0];
        savefile = append(savefile, str(player.getPosX()));
        savefile = append(savefile, str(player.getPosY()));
        savefile = append(savefile, str(showFPS));
        savefile = append(savefile, str(width));
        savefile = append(savefile, str(height));
        savefile = append(savefile, str(player.getItemCount(0)));
        savefile = append(savefile, str(player.getItemCount(1)));
        savefile = append(savefile, str(pMonsterSeen));
        savefile = append(savefile, str(pMonstersCaught));
        savefile = append(savefile, str(pBattlesWon));
        savefile = append(savefile, str(pPlaytimeMin));
        savefile = append(savefile, str(pPlaytimeHour));
        savefile = append(savefile, str(pUniqueMonstersCaught.length));
        for(int j = 0; j<pUniqueMonstersCaught.length; ++j)
        {
          savefile = append(savefile, str(pUniqueMonstersCaught[j]));
        }
        
        Monster[] pokemonData = player.getPlayerTeam();
        for(int i = 0; i<pokemonData.length; ++i)
        {
          savefile = append(savefile, pokemonData[i].getPokemonData());
        }
        
        saveStrings("savegame01.txt", savefile);
        
        owMenu = -1;
        owMenuOpened = false;
        menuOption = 0;
      }
    }
    
    else if(owMenu == 5 && owMenuOpened == true)
    {
      if(key == 'z' || key == 'w') owMenu = -1;
      if(keyCode == DOWN) submenuOption = (submenuOption+1)%3;
      if(keyCode == UP) submenuOption--;
      if(submenuOption < 0) submenuOption = 2;
      
      if(keyCode == RIGHT)
      {
        if(submenuOption == 0) owMenu5option1 = (owMenu5option1+1)%3;
        if(submenuOption == 1) owMenu5option2 = (owMenu5option2+1)%2;
      }
      if(keyCode == LEFT)
      {
        if(submenuOption == 0) owMenu5option1--;
        if(submenuOption == 1) owMenu5option2--;
      }
      if(owMenu5option1 < 0) owMenu5option1 = 2;
      if(owMenu5option2 < 0) owMenu5option2 = 1;
      
      if(key == 'x' && submenuOption == 2)
      {
        String[] changeRes = split(resolution, "x");
        surface.setSize(int(changeRes[0]),int(changeRes[1]));
        battleBackground01.resize(int(changeRes[0]), int(changeRes[1]));
        if(owMenu5option2 == 1) showFPS = true;
        else showFPS = false;
      }
    }
    
    
    if(owMenu == 6 && owMenuOpened == true)
    {
        owMenuOpened = false;
        owMenu = -1;
    }
  }
}

void keyReleased()
{
  if(keyCode == LEFT) pLeft = false;
  if(keyCode == RIGHT) pRight = false;
  if(keyCode == UP) pUp = false;
  if(keyCode == DOWN) pDown = false;
  if(key == 'z' || key == 'w') pRun = false;
}

void displayOWMenu()
{
  if(owMenu == -1 && owMenuOpened == true)
  {
    textSize(24);
    int textGap = 45;
    
    image(boxFrame01, width-boxFrame01.width, height/2-boxFrame01.height/2);
    textAlign(CENTER);
    rectMode(CENTER);
    color c = color(40);
    float textPosX = width-boxFrame01.width/2;
    float textPosY = height/2-boxFrame01.height/2;
    textLeading(45);
    textMessage(textPosX,textPosY+textGap,"POKéDEX\nPOKéMON\nBAG\nPLAYER\nSAVE\nOPTION\nEXIT", c);
    image(imgArrow, width-boxFrame01.width+10, textPosY+30+(menuOption*textGap));
    rectMode(CORNER);
  }
  if(owMenu == 0)//POKEDEX
  {
    imageMode(CENTER);
    image(boxFrame03,width/2,height/2);
    imageMode(CORNER);
    
    textMessage(width/2-boxFrame03.width/2+20, height/2-boxFrame03.height/2+45, "TOTAL UNIQUE POKéMON AVAILABLE: " +pokemonList.length +"\n\nTOTAL UNIQUE POKéMON CAUGHT: " +str(pUniqueMonstersCaught.length), color(0));
  }
  if(owMenu == 1)//POKEMON
  {
    imageMode(CENTER);
    image(boxFrame03,width/2,height/2);
    imageMode(CORNER);
    int gap = 58;
    
    if(owMenu1storePokemonID != -1) 
    {
      stroke(150);
      rect(width/2-boxFrame03.width/2+10, (height/2-boxFrame03.height/2+15)+((boxFrame03.height/4-5)*owMenu1storePokemonID), boxFrame03.width*0.75, 50);
    }
    noFill();
    stroke(225,0,0);//red
    strokeWeight(4);
    rect(width/2-boxFrame03.width/2+10, (height/2-boxFrame03.height/2+15)+((boxFrame03.height/4-5)*submenuOption), boxFrame03.width*0.75, 50);
    
    Monster[] testDisplay = player.getPlayerTeam();
    for(int i = 0; i<testDisplay.length; ++i)
    {
      testDisplay[i].setSprite(pokemonSpritesIcons[testDisplay[i].getMonsterID()]);
      testDisplay[i].setPosition(width/2-boxFrame03.width/2+10, height/2-boxFrame03.height/2+15+(i*gap));
      textSize(18);
      textMessage(width/2-boxFrame03.width/2+64, height/2-boxFrame03.height/2+45+(i*gap), "Name: "+ (testDisplay[i].getMonsterName()) +"   Lvl: "+ str(testDisplay[i].getMonsterLvl()) +"   HP: "+ str(testDisplay[i].getMonsterHP())+"/"+str(testDisplay[i].getMonsterMaxHP()), color(0));
      testDisplay[i].display();
    }
  }
  if(owMenu == 2)
  {
    imageMode(CENTER);
    image(boxFrame03,width/2,height/2);
    imageMode(CORNER);
    color c = color(40);
    textLeading(30);
    textMessage(width/2-boxFrame03.width/2+20, height/2-boxFrame03.height/2+40,"POKéBALLS x"+ player.getItemCount(0) +"\nPOTIONS x"+ player.getItemCount(1), c);
  }
  if(owMenu == 3)
  {
    imageMode(CENTER);
    image(boxFrame03,width/2,height/2);
    imageMode(CORNER);
    image(trainerSprite01, width/2+boxFrame03.width/2-trainerSprite01.width, height/2-boxFrame03.height/2+5);
    color c = color(40);
    textLeading(30);
    textMessage(width/2-boxFrame03.width/2+20, height/2-boxFrame03.height/2+40,"NAME\nGENDER\nPOKéMON SEEN\nPOKéMON CAUGHT\nBATTLES WON\nBADGES OBTAINED\nPLAY TIME", c);
    textMessage(width/2, height/2-boxFrame03.height/2+40, "PLAYER\nMALE\n"+ pMonsterSeen +"\n"+ pMonstersCaught +"\n"+ pBattlesWon +"\n0\n"+ pPlaytimeHour+":"+pPlaytimeMin, c);
  }
  if(owMenu == 4)
  {
    int gap = 20;
    imageMode(CENTER);
    image(boxFrame03,width/2,height/2);
    image(boxFrame02,width/2,height*0.8);
    imageMode(CORNER);
    color c = color(40);
    textLeading(30);
    textMessage(width/2-boxFrame03.width/2+gap, height/2-boxFrame03.height/2+gap*3,"SAVEFILE NAME\n\nSAVING:\n- POSITION\n- PROGRESS\n- STATS", c);//text in top box left
    textMessage(width/2, height/2-boxFrame03.height/2+gap*3, "savegame01.txt", c);
    textMessage(width/2-boxFrame02.width/2+gap, height*0.75+gap, "EL ARCHIVO SE SOBREESCRIBIRA.\nESTAS SEGURO?", color(40));
    textMessage(width/2+boxFrame02.width/4+gap, height*0.75+gap, "SI\nNO", color(40));
    image(imgArrow, width/2+boxFrame02.width/4, height*0.75+35-(submenuOption*(30)));
    stroke(255,0,0);
    noFill();
  }
  if(owMenu == 5)
  {
    if(owMenu5option1 == 0) resolution = "512x512";
    if(owMenu5option1 == 1) resolution = "1000x700";
    if(owMenu5option1 == 2) resolution = "1024x1024";
    boolean showFPScounter = false;
    if(owMenu5option2 == 1) showFPScounter = true;
    
    imageMode(CENTER);
    image(boxFrame03,width/2,height/2);
    imageMode(CORNER);
    color c = color(40);
    textLeading(30);
    textMessage(width/2-boxFrame03.width/2+20, height/2-boxFrame03.height/2+40,"OPCIONES\n\nRESOLUCION DE PANTALLA\nMOSTRAR FPS", c);
    textMessage(width/2, height/2-boxFrame03.height/2+40,"PRESIONA CONFIRMAR PARA JUGAR\n\n"+ resolution +"\n"+ showFPScounter +"\nCONFIRMAR", c);
    image(imgArrow, width/2-imgArrow.width*2, height/2-40+(submenuOption*(30)));
  }
}

void drawOverworldmap()
{
  image(overworldmapImg,0,0);
  image(house01Img,100*tileSize,0);
  image(house02Img,200*tileSize,0);
  image(house03Img,300*tileSize,0);
}

void textMessage(float posX, float posY, String text, color c)
{
    fill(125);
    text(text, posX+1, posY+1);
    fill(c);
    text(text, posX, posY);
}

void handleTransitions()
{
  for(int i = 0; i<mapTransitions.length; ++i)
  {

    if(player.getPosX() == mapTransitions[i].getPosX() && player.getPosY() == mapTransitions[i].getPosY() && currentArea != mapTransitions[i].getNPCType())
    {
      notificationTimer = 360;
      currentArea = mapTransitions[i].getNPCType();
    }
  }
  
  if(notificationTimer > 0)
  {
    textAlign(CENTER);
    image(boxFrame02, width/2-boxFrame02.width/2, height*0.05);
    textSize(48);
    textMessage(width/2, height*0.15, areaName[currentArea], color(40));
    notificationTimer--;
  }  
}

void checkWarp()
{
  for(int i = 0; i<warpTiles.length; ++i)
  {
    
    if((player.getPosX() == warpTiles[i].getPosX() && player.getPosY() == warpTiles[i].getPosY()+(1*tileSize) && player.getDirection() == 3) || (player.getPosX() == warpTiles[i].getPosX() && player.getPosY() == warpTiles[i].getPosY()-(1*tileSize) && player.getDirection() == 1))
    {
      if(warpTiles[i].getNPCType() == 0)
      {
        destinationX = warpTiles[i+1].getPosX();
        destinationY = warpTiles[i+1].getPosY()-(1*tileSize);
        isTransitioning = true;
      }
      else if(warpTiles[i].getNPCType() == 1)
      {
        destinationX = warpTiles[i-1].getPosX();
        destinationY = warpTiles[i-1].getPosY()+(1*tileSize);
        isTransitioning = true;
      }
    }
  }
}

void blackoutEffect()
{
  noStroke();
  fill(0,0,0,blackoutEffectAlpha);
  
  if(isTransitioning)
  {
    rect(0,0,width,height);
    blackoutEffectAlpha += fadeAmount;
    
    if(blackoutEffectAlpha >= 255) 
    {
      fadeAmount *= -1;
      player.setPosition(destinationX,destinationY);
    }
    if(blackoutEffectAlpha <= 0)
    {
      blackoutEffectAlpha = 0;
      fadeAmount = 15;
      isTransitioning = false;
    }
  }
}


void checkCollision(int direction)
{
  boolean playerCollision = false;
 
  for (int i = 0; i<blokje.length; ++i)
  {
    if (blokje[i].checkCollision(player.getPosX(), player.getPosY(), direction))
    {
      playerCollision = true;
    }
  }  

  for (int i = 0; i<map01obj.length; ++i)
  {
    if (map01obj[i].checkCollision(player.getPosX(), player.getPosY(), direction))
    {
      playerCollision = true;
    }
  }  
  
  if(playerCollision == false)
  {
    player.move(direction);
    player.setRunState(true);
  }
  else if(playerCollision == true)
  {
    player.setDirection(direction);
    player.setRunState(false);
  }
}

void checkPlayerInteraction()
{
  healPokemon = false;
  for (int i = 0; i<map01obj.length; ++i)
  {
    if (map01obj[i].checkCollision(player.getPosX(), player.getPosY(), player.getDirection()))
    {
     
      if(map01obj[i].getNPCType() == 0)
      {
        if(player.getDirection() == 0) map01obj[i].changeDir(2);
        else if(player.getDirection() == 1) map01obj[i].changeDir(3);
        else if(player.getDirection() == 2) map01obj[i].changeDir(0);
        else if(player.getDirection() == 3) map01obj[i].changeDir(1);
      }
      isInConversation = true;
      

      String[] loadFile = loadStrings("data/scripts/map01strings.txt");
      String[] dissection = new String[0];
      for(int j = 0; j<loadFile.length; ++j)
      {
        dissection = split(loadFile[j], "/");
        if(int(dissection[0]) == i) conversation = append(conversation, dissection[1]);
      }

   
      for(int k = 0; k<conversation.length; ++k)
      {
        conversation[k] = conversation[k].replaceAll("NEWLINE", "\n");
        conversation[k] = conversation[k].replaceAll("SLASHe", "é");
      }
      
      println("Character ID: "+i);
      

      if(i == 3) healPokemon = true;
      else healPokemon = false;
      if(i == 10) giveItems = true;
      else giveItems = false;
    }
  }
}

void drawInfoBar(float posX, float posY, float health, float maxHP, float exp, float maxExp)
{
  noStroke();

  image(healthbarBg, posX, posY);
  fill(0,158,14);
  rect(posX+25, posY, (health/maxHP)*(healthbarOver.width-27), healthbarOver.height);
  image(healthbarOver, posX, posY);

  image(healthbarBg, posX, posY+expbarOver.height+2);
  fill(0,148,255);
  rect(posX+25, posY+expbarOver.height+2, (exp/maxExp)*(healthbarOver.width-27), healthbarOver.height);
  image(expbarOver, posX, posY+expbarOver.height+2);
}

void conversationHandler(int type)
{
  int gap = 20;
  textAlign(LEFT);
  imageMode(CENTER);
  if(type == 0) image(boxFrame02, width/2, height*0.8);
  if(type == 1) image(boxFrame02, width/2, height*0.1);
  imageMode(CORNER);
  
  fill(0);//black
  textFont(font);
  textSize(28);
  textLeading(30);
  if(type == 0) textMessage(width/2-boxFrame02.width/2+gap , height*0.75+gap, conversation[conversationNum], color(40));
  else if(type == 1) textMessage(width/2-boxFrame02.width/2+gap , height*0.1, conversation[conversationNum], color(40));
}

void battleMove(Monster attacker, Monster target, int move)
{
  int fullDamage = (attacker.getMonsterMoveDamage(move)*attacker.getMonsterAtt())/(target.getMonsterDef()*2);

  if(checkMoveEffectiveness(attacker.getMonsterMoveType(move), target.getType()) == 0)
  {
    target.reduceHP(fullDamage);
  }
  if(checkMoveEffectiveness(attacker.getMonsterMoveType(move), target.getType()) == -1)
  {
    target.reduceHP(int(fullDamage*0.5));
    conversation = append(conversation, "It was not very effective!");
  }
  if(checkMoveEffectiveness(attacker.getMonsterMoveType(move), target.getType()) == 1)
    target.reduceHP(int(fullDamage*1.5));
    conversation = append(conversation, "It was super effective!");
  }
}

int checkMoveEffectiveness(String attacker, String target)
{

  int result = 0;
 
  if(attacker.equals("fire") && target.equals("water")) result = -1;
  if(attacker.equals("fire") && target.equals("grass")) result = 1;
  if(attacker.equals("grass") && target.equals("water")) result = 1;
  if(attacker.equals("grass") && target.equals("fire")) result = -1;
  if(attacker.equals("grass") && target.equals("flying")) result = -1;
  if(attacker.equals("water") && target.equals("fire")) result = 1;
  if(attacker.equals("water") && target.equals("grass")) result = -1;
  if(attacker.equals("water") && target.equals("electric")) result = -1;
  if(attacker.equals("flying") && target.equals("grass")) result = 1;
  if(attacker.equals("flying") && target.equals("electric")) result = -1;
  if(attacker.equals("electric") && target.equals("grass")) result = -1;
  if(attacker.equals("electric") && target.equals("water")) result = 1;
  if(attacker.equals("electric") && target.equals("flying")) result = 1;

  if(attacker.equals(target) && attacker.equals("normal") == false && attacker.equals("flying") == false) result = -1;
  return result;
}

//Autor original Dieter Boddin, 2017. Adaptacion Diego Fernando Rueda Baez (a medias)
