import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

import de.looksgood.ani.*;

Proc[] processi;
Proc[] processiSJF;
Button jsf,fcfs,inc,dec,stopPlaySim,reload,edit,sounds;
ProgressBar fuel;
Table table;
int menuChoice=0;
int p=0;
float frameCont=0,frameContInput=0;
float tempoMedio=0;
int fps=30;
int nproc=0;
float boostTime=1;
boolean play=false,fine=false;
PImage sfondo,pista,benzina;
int codaX=60,codaY=540;//Cordinate di inizio della coda
int stepSize=40;//Distanza fra gli aerei in coda
int textSize=15;
Minim minim;
boolean isOk;
int randX,randY;

void setup(){
  minim = new Minim(this);
  size(800,640);
  frameRate(fps);
  readFile("input.csv");
  println("dopo");
  for(int i=0;i<processiSJF.length;i++)println(processiSJF[i].nome + " " +processiSJF[i].missile.posX +"x");
  jsf= new Button("../img/bottonejsf.png",300,400);
  fcfs= new Button("../img/bottonefcfs.png",420,400);
  inc = new Button("../img/inc.png",273,597);
  dec= new Button("../img/dec.png",313,597);
  edit= new Button("../img/edit.png",360,353);
  reload = new Button("../img/reload.png",273,597);
  fuel = new ProgressBar(codaX,codaY-20,50,10);
  String[] s = {"../img/play.png","../img/stop.png"};
  stopPlaySim= new Button(s,353,597);
  String[] s2 = {"../img/soundOn.png","../img/soundOff.png"};
  sounds= new Button(s2,440,597);    
  sfondo = loadImage("../img/mappa.png");
  pista = loadImage("../img/runway.png");
  benzina = loadImage("../img/benzina.png");
  Ani.init(this);
  textSize(textSize);
  fill(255);
}
void draw(){
  //println(mouseX);
  //println(mouseY);
  frameContInput++;
  background(0);
  image(sfondo,0,0,800,codaY);
  image(pista,0,codaY-10);
  switch(menuChoice){
    case 0://Menu principale
      fcfs.drawButton();
      edit.drawButton();
      jsf.drawButton();
    break;
    case 1://Gestione FCFS
      inc.drawButton();
      dec.drawButton();
      stopPlaySim.drawButton();
      sounds.drawButton();
      gestProc(processi);
    break;
    case 2://Gestione SJF
      inc.drawButton();
      dec.drawButton();
      stopPlaySim.drawButton();
      sounds.drawButton();
      gestProc(processiSJF);
    break;
    case 3://Schermata dei risultati
      fill(255);
      text("Tempo di attesa medio: " + String.format("%.2f",tempoMedio) + " s",25,596+textSize);
      fill(0);
      reload.drawButton();        
    break;
    case 4://Editor
      if(p!=processi.length){
        for(int i=0;i<p;i++){
          image(processi[i].missile.targetImg,processi[i].missile.targetX,processi[i].missile.targetY);//Disegna i bersagli già definiti.
          fill(219,60,60,200);
          rect(float((processi[i].missile.targetX-5)-(processi[i].nome.length())),float(processi[i].missile.targetY-textSize),processi[i].nome.length()*textSize*0.6+6,textSize+5,10);
          fill(0);
          text(processi[i].nome,processi[i].missile.targetX-(processi[i].nome.length()),processi[i].missile.targetY);
          fill(255);
        }
        textSize(20);
        text("Inserire coordinate aeroplano(" + (p+1) + "/" + processi.length + ")",14,603);
        textSize(textSize);
        text("r: cordinate random",14,603+textSize);
        text("<-: undo",14,603+textSize*2);
        textSize(20);
        line(0,mouseY-6,width,mouseY-6);
        line(mouseX-1,0,mouseX-1,height);
        fill(0);
        image(processi[p].missile.targetImg,mouseX-(processi[p].missile.rocketImg.width),mouseY-(processi[p].missile.rocketImg.height));
        text(processi[p].nome,mouseX+25,mouseY-8);
        fill(255);
        textSize(textSize);
        //Comandi
        if(keyCode==LEFT && p!=0 && frameContInput/fps>=0.25){p-=1;frameContInput=0;keyCode=' ';}//Torna al processo precedente.(se possibile)
        if(key=='r'){//Cordinate random (cordinate uguali non si ripetono, i bersagli non combaciano mai)
          for(int i=p;i<processi.length;i++){
            isOk=false;
            while(!isOk){//Ripete finche non trova delle cordinate valide.
              randX = int(random(0,width-processi[p].missile.targetImg.width));
              randY = int(random(0,500));
              for(int j=0;j<processi.length;j++){
                if(randX!=processi[j].missile.targetX && randY!=processi[j].missile.targetY){
                  isOk = true;
                  break;
                }
              }
            }
            //Cordinate valide trovate
            processi[i].missile.targetX = randX;
            processi[i].missile.targetY = randY;                    
          }
          p=processi.length;
        }   
      }
      else{
        p=0;
        menuChoice=0;
        writeFile("input.csv");
        readFile("input.csv");
      }
      keyCode=' ';
      key=' ';
    break;
  }
}
void ordinaVett(Proc[] V){
  int i,j;
  Proc min;
  for(i=0;i<V.length;i++){
    min= new Proc(V[i]);
    j=i-1;
    while((j>=0)&&(V[j].tempo>min.tempo)){
      V[j+1]=V[j];
      j--;
    }
    V[j+1]=min;
  }
  for(i=0;i<V.length;i++)println(V[i].nome + " " +V[i].missile.posX +"x");
}
void gestProc(Proc[] v){
  //println(v[10].missile.posX + "x _  " + v[v.length-1].missile.posY + "y");
  for(int i=0;i<v.length;i++){//Animazioni
    if(v[i].missile.posX==0)println(i);
    v[i].missile.drawTarg();//Disegno dei bersagli dei missili lanciati
    v[i].missile.drawMis();//Disegno missili
    //text(v[i].nome,v[i].missile.posX+5,v[i].missile.posY-10);
    if(v[i].missile.isArrived())//Determina se il missile è arrivato.    
      v[i].missile.thrown=false;
    if(v[i].missile.posX==width+100){//Fine decollo
      v[i].missile.posX=width-v[i].missile.rocketImg.width;
      v[i].missile.posY=0;//Si posiziona nell'angolo in alto a destra prima di ragguingere target, dopo il decollo
      v[i].missile.updateAngolo();//Ruota l'aereo in direzione del bersaglio prima di lanciarlo.
      v[i].missile.goToTarget();//Animazione lancio missile verso il bersagliio
      println("Lancio: " + i);
    } 
  }
  image(benzina,codaX-benzina.width+5,codaY-benzina.height-10);    
  fuel.draw(); 
  if(play){
    if(nproc<v.length){//scorrimento della coda di procecssi
      if(v[nproc].tempo>=(frameCont/fps)*boostTime){//Attesa x processo
        frameCont++;
        fuel.update((frameCont/fps)*boostTime,v[nproc].tempo);
        fill(255);
        text("Sto servendo il processo : " + v[nproc].nome,14,596);
        text("Tempo trascorso: " + String.format("%.2f", (frameCont/fps)*boostTime) + " s" + " x " + boostTime,14,596+(textSize*1)+3);
        text("Tempo di servizio: "+v[nproc].tempo + " s",14,596+(textSize*2)+6);
        fill(0);
      }
      else{//Fine servizio di UN processo    
        v[nproc].missile.goTo(width+100,v[nproc].missile.posY,2.5);//Animazione decollo.
        if(sounds.getState()!=1)v[nproc].missile.sound();//Suono decollo.
        for(int i=v.length-1;i>nproc;i--)//Fa scorrere la coda.
          v[i].missile.goTo(v[i].missile.posX+stepSize,v[i].missile.posY,1);
          nproc++;
          frameCont=0;  
        }
    }
    else{//Coda di processi terminata
      fine = true;
      for(int i=0;i<v.length;i++){//Verifica se tutti i missili sono arrivati
        if(v[i].missile.thrown==true){
          fine = false;
          break;
        }
      }
      if(fine){//Tutti gli aerei sono arrivati a destinazione.
        tempoMedio=0.00;
        tempoMedio+=v[0].tempo;
        for(int i=1;i<v.length-1;i++)
          tempoMedio+=somVetInterval(0,i,v);
        tempoMedio=tempoMedio/nproc;
        play=false;
        menuChoice=3;//Carica schermata dei risultati
        nproc=0;
      }
      else{
        text("Processi serviti.",270,695);
      }
    }
  }
  else{//Servizio in pausa
    if(nproc<v.length){
      fill(255);
      text("Processo " + v[nproc].nome + " in pausa",14,596);
      text("Tempo trascorso: " + String.format("%.2f", (frameCont/fps)*boostTime) + " s" + " x " + boostTime,14,596+(textSize*1)+3);
      text("Tempo di servizio: "+v[nproc].tempo + " s",14,596+(textSize*2)+6);
      fill(0);
    }    
  } 
}
void writeFile(String fileName){
  table=new Table();
  table.addColumn("nome");
  table.addColumn("tempo");
  table.addColumn("x");
  table.addColumn("y");
  for(int i=0;i<processi.length;i++){
    TableRow newRow = table.addRow();
    println("linea aggiunta");
    newRow.setString("nome",processi[i].nome);
    newRow.setInt("tempo",processi[i].tempo);
    newRow.setInt("x",processi[i].missile.targetX);
    newRow.setInt("y",processi[i].missile.targetY);
  }
  saveTable(table,"input.csv");
}
void readFile(String fileName){
  table = loadTable(fileName, "header");
  int nRig = table.getRowCount();
  int som=0;
  processi = new Proc[nRig];
  processiSJF = new Proc[nRig];
  for(int row=0;row<nRig;row++){
    processi[row] = new Proc(table.getString(row,"nome"),table.getInt(row,"tempo"),codaX+som,codaY,table.getInt(row,"x"),table.getInt(row,"y"));
    processiSJF[row] = new Proc(processi[row]);
    som -=stepSize;
    //println(processi[row].nome + " : " + processi[row].tempo);  
  }
  ordinaVett(processiSJF);
  som=0;
  for(int i=0;i<processiSJF.length;i++){//Impostazioni delle x di partenza per la coda, dopo l'ordinamento.
    processiSJF[i].missile.posX=codaX+som;
    som -=stepSize;
  }
}
float somVetInterval(int from,int to,Proc[] v){
  float som=0;
  for(int i=from;i<=to;i++)som+=v[i].tempo;
  return som;
}
void mousePressed(){
  switch(menuChoice){
    case 0://Selezione metodo di gestione
      if(fcfs.pressedButton(mouseX,mouseY)){menuChoice=1;frameCont=0;}
      if(jsf.pressedButton(mouseX,mouseY)){menuChoice=2;frameCont=0;}
      if(edit.pressedButton(mouseX,mouseY)){menuChoice=4;frameCont=0;keyCode=' ';key=' ';}
    break;
    case 1://Gestione interfaccia di controllo della FCFS
      if(inc.pressedButton(mouseX,mouseY)){boostTime=addUpTo(boostTime,100,0.5);}
      if(dec.pressedButton(mouseX,mouseY)){boostTime=subUpTo(boostTime,0.5,0.5);}
      if(stopPlaySim.pressedButton(mouseX,mouseY)){
        if(stopPlaySim.getNumStates()!=0)stopPlaySim.changeState();
        if(play)play=false;
        else play=true;
      }
      if(sounds.pressedButton(mouseX,mouseY))
        sounds.changeState();      
    break;
    case 2://Gestione interfaccia di controllo della simulazione SJF
      if(inc.pressedButton(mouseX,mouseY)){boostTime=addUpTo(boostTime,5,0.5);}
      if(dec.pressedButton(mouseX,mouseY)){boostTime=subUpTo(boostTime,0,0.5);}
      if(stopPlaySim.pressedButton(mouseX,mouseY)){
        if(stopPlaySim.getNumStates()!=0)stopPlaySim.changeState();
        if(play)play=false;
        else play=true;
      }
      if(sounds.pressedButton(mouseX,mouseY))
        sounds.changeState();         
    break;
    case 3://Schermata dei risultati
      if(reload.pressedButton(mouseX,mouseY)){
        setUpSim();
      }
    break;
    case 4://Editor
      if(mouseY<=530){
        processi[p].missile.targetX=mouseX-(processi[p].missile.rocketImg.width);
        processi[p].missile.targetY=mouseY-(processi[p].missile.rocketImg.height);
        p++;
        println("FATTO");
      }
    break;
  }
}
void setUpSim(){
  readFile("input.csv");
  boostTime=1;
  play=false;
  fine=false;
  menuChoice=0;
  nproc=0;
  //Inizializzazione bottoni
  String[] s = {"../img/play.png","../img/stop.png"};
  stopPlaySim= new Button(s,353,597);
  String[] s2 = {"../img/soundOn.png","../img/soundOff.png"};
  sounds= new Button(s2,440,597);      
  fuel.update(0,1);  
}
float addUpTo(float n,float maxN,float som){
   if(n+som<=maxN)n+=som;
   if(n==0)n+=1;
   return n;
}
float subUpTo(float n,float minN,float dif){
   if(n-dif>=minN)n-=dif;
   return n;
}





