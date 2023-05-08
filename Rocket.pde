class Rocket{
  int posX,posY;
  int targetX,targetY;
  float timeToTarget;
  PImage rocketImg,targetImg;
  boolean thrown;
  float angolo;
  AudioPlayer decollo;  
  
  //Costruttori
  Rocket(int x,int y,int Targx,int Targy,String n1,String n2){
    rocketImg = loadImage(n1);
    targetImg = loadImage(n2);    
    targetX = Targx;
    targetY = Targy;
    posX = x;
    posY = y;
    timeToTarget = 2;
    if(int(random(10))==1)decollo = minim.loadFile("../sounds/fart.mp3");
    else decollo = minim.loadFile("../sounds/decollo.mp3");
    thrown = false;
  }
  
  
  //Metodi
  void drawMis(){
    pushMatrix();
      translate(posX+rocketImg.width/2,posY+rocketImg.height/2);   //
      rotate(angolo);                                     //Rotazione
      translate(-(posX+rocketImg.width/2),-(posY+rocketImg.height/2));//Traslazione nell'origine degli assi per la rotazione
      image(rocketImg,posX,posY);
      popMatrix();    
  }
  
  
  void updateAngolo(){
    angolo = atan2((targetY+targetImg.height/2)-(rocketImg.height/2)-posY, (targetX+targetImg.width/2)-(rocketImg.width/2)-posX);
  }
  
  
  void drawTarg(){
    image(targetImg,targetX,targetY);
  }
  
  
  void sound(){
    decollo.play();
    //decollo.rewind();
  }
  
  
  boolean isArrived(){
    return posX==(targetX+targetImg.width/2)-(rocketImg.width/2) && posY==(targetY+targetImg.height/2)-(rocketImg.height/2);
  }
  
  
  void goToTarget(){//Fa raggingere il bersaglio al missile
    thrown = true;
    Ani.to(this,timeToTarget,"posX",(targetX+targetImg.width/2)-(rocketImg.width/2));
    Ani.to(this,timeToTarget,"posY",(targetY+targetImg.height/2)-(rocketImg.height/2));
  }
  
  
  void goTo(int x,int y,float t){
    thrown = true;
    Ani.to(this,t,"posX",x);
    Ani.to(this,t,"posY",y);
  }
  
  
}
