class Proc{
  int tempo;
  String nome;
  String imgName= "../img/plane" + int (random(1,6)) + ".png";;
  Rocket missile;
  
  Proc(String s,int t,int x,int y,int Targx,int Targy){//NomeProc - tempo di servizio - x - y 
    tempo=t;
    nome=s;
    missile = new Rocket(x,y,Targx,Targy,imgName,"../img/target.png");
  }
  
  
  Proc(Proc a){
    tempo=a.tempo;
    nome=a.nome;
    missile = new Rocket(a.missile.posX,a.missile.posY,a.missile.targetX,a.missile.targetY,imgName,"../img/target.png");
  }    
}
