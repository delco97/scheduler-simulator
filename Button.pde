class Button{
  int posX,posY,state;
  PImage[] imgButtons;
  
  Button(String s, int x, int y){//Bottone con solo uno stato
    imgButtons = new PImage[1];
    imgButtons[0]= new PImage();
    imgButtons[0]=loadImage(s);
    posX=x;
    posY=y;
    state=0;
  }
  
  
  Button(String[] s, int x, int y){//Bottone con più stati
    imgButtons = new PImage[s.length];
    for(int i=0;i<s.length;i++){
      imgButtons[i] = new PImage();
      imgButtons[i]=loadImage(s[i]);
    }      
    posX=x;
    posY=y;
    state=0;
  } 
  
  
  int getNumStates(){return imgButtons.length;}
  int getState(){return state;}
  void drawButton(){
    image(imgButtons[state],posX,posY);
  }
  
  
  void changeState(){
    if(state<imgButtons.length-1)state+=1;
    else state=0;      
  }
  
  
  boolean pressedButton(int x,int y){
    if(((x>=posX)&&(x<=posX+imgButtons[state].width))&&((y>=posY)&&(y<=posY+imgButtons[state].height))){
      return true;
    }
    return false;
  }
  
  
}
