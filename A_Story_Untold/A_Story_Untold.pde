int x = height/2;
int y = width/2;
PImage casa1,casa,modelo_bosque,pueblo,pSprite,Up,Down,Left,Right,bosque;

void setup(){
 size(800,800);
 frameRate(120);
 casa1 = loadImage("casa1.jpg");
 casa1.resize(392,344);
 pSprite = loadImage("spr_player01.png");
 Up = loadImage("up.png");
 Down = loadImage("down.png");
 Left= loadImage("left.png");
 Right= loadImage("rigth.png");
 bosque= loadImage("modelo_bosque.bmp");
}


void draw(){
  background(0);
  image(bosque,0,0);
  image(Down,x,y);
  if(keyPressed && (key == CODED)){
    if(keyCode == LEFT){
    x -=1 ;
    image(Left,x,y);
    
    }else if(keyCode == RIGHT){
    x += 1; 
    image(Right,x,y);
    }
    if(keyCode == UP){
    y -=1 ;
    image(Up,x,y);
    }else if(keyCode == DOWN){
    y += 1;
    image(Down,x,y);
    }
  }
  
  //image(pSprite,x,y);
  //ellipse(x,y,50,50);
}
