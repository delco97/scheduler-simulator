class ProgressBar{
  int posX,posY;
  int w,h;
  float currentTime,endTime;
  color c;
  
  ProgressBar(int x,int y,int wid,int heig){
    posX = x;
    posY = y;
    w=wid;
    h=heig;    
    currentTime =0;
    c=color(93,214,105);
  }
  
  
  void update(float t,float tEnd){
    endTime = tEnd;
    currentTime = t;
    if(currentTime==tEnd){
      currentTime=0;
    }
  }
  
  
  void draw(){
    rect(posX,posY,w,h,10);//Disegno campo di variabilità della barra    
    fill(c);
    rect(posX,posY,w/(endTime/currentTime),h,10);
    fill(0);        
  }
}
