/*
DJV_EBG
*/

ChildApplet editor;

// variables
long t = 0;
long realt = 0;
int bgno = 0;
float Cx, Cy;
int paloffset = 0;
double Mytemp;
double Mxtemp;

// backgrouns settings
String backgroundName = "no background loaded...";
color[] pal;
int palf;
boolean palc;
boolean palcreverse;
int palssa;
float vCx, vCy;
int[][] ptm;
int scale; // why would there be a different scale on each axis?
float Mxscale;
float Mxfreq;
int Mxinterl;
float Myscale;
float Myfreq;
int staticx;

int inactive = 0;

// fonts
PFont MSG20;

void setup() {
  log = new LOGFILE();
  log.created("LOGFILE");
  size(960, 720, P3D);
  noStroke();
  frameRate(30);
  MSG20 = loadFont("MS-Gothic-20.vlw");
  textFont(MSG20);
  log.loaded("font MSG20");
  loadbg();
  editor = new ChildApplet();
  
  windowMove(600, 200);
  windowResizable(false);
  
  buttons[0] = new Button("01_name", 600, 75, 160, 30, "click to edit", 1);
  buttons[1] = new Button("01_pal", 600, 105, 160, 30, "click to edit", 1);
  buttons[2] = new Button("01_ptm", 600, 315, 160, 30, "click to edit", 1);
  buttons[3] = new Button("save", 30, 200, 100, 30, "go back", 5);
  buttons[4] = new Button("save", 30, 680, 100, 30, "go back", 6);
  buttons[5] = new Button("save", 30, 680, 100, 30, "go back", 7);
  
  log.loaded("configured parent");
}

void draw() {
  inactive++;
  realt++;
  background(0);
  for (int y = 0; y < height/scale; y++){
    Mxtemp = Math.sin(Math.toRadians((y+t))*Mxfreq)*Mxscale*((int(y%2==0)*-Mxinterl*2+1));
    Mytemp = Math.sin(Math.toRadians((y+t))*Myfreq)*Myscale;
    for (int x = 0; x < width/scale; x++){
      int ptmy = rem(Math.round(y+Cy+(int)(Math.round(Mytemp))),ptm.length);
      int ptmx = rem(Math.round(x+Cx+(int)(Math.round(Mxtemp))+random(0, staticx)),ptm[0].length);
      if (ptm[ptmy][ptmx] < palssa) {
        fill(pal[ptm[ptmy][ptmx]]);
      } else {
        fill(pal[rem(ptm[ptmy][ptmx]+paloffset,pal.length-palssa)+palssa]);
      }
      rect(x*scale, y*scale, scale, scale);
    }
  }
  Cx += vCx;
  Cy += vCy;
  t++;
  if(t%palf == 0 && palc){
    paloffset += int(!palcreverse)*2-1;
    paloffset = rem(paloffset, pal.length - 1);
  }
  if (!palc) paloffset = 0;
  if (menu == 2){
    windowMove(960, 200);
    menu = 1;
  }
  if (menu == 3){
    windowMove(600, 200);
    menu = 0;
  }
  if (inactive<100){
    fill(0, (100-Math.max(inactive, 90))*25.5);
    rect(0, 0, textWidth(backgroundName) + 30, 30);
    fill(255, (100-Math.max(inactive, 90))*25.5);
    text(backgroundName, 10, 25); 
  }
}

void mouseMoved() {
  inactive = 0;
}
void keyPressed() {
  if (key == ENTER && menu == 0) {
    loadbg();
  }
  inactive = 0;
  if ((key == 'e'||key=='E') && menu == 0) {
    menu = 2;
    menuselect = 0;
  }
  if ((key == BACKSPACE) && menu == 1) {
    menu = 3;
  }
  optionsCheckKeyPress(keyCode);
  if (menu == 5) keyboardDetection(keyCode, key);
  if (key == ESC) logexit();
}

int rem(int x, int n) {
  if (x>0) return (int)(x%n);
  return (int)(Math.floor(x + (Math.ceil(Math.abs(x)/n+1)*n))%n);
}
 
String[] loadFilenames(String path, String filename) {
  File folder = new File(path);
  String[] files = folder.list();
  String[] filteredfiles = {};
  for (int i = 0; i<files.length; i++){
    if (files[i].toLowerCase().endsWith("."+filename)) filteredfiles = append(filteredfiles, files[i]);
  }
  return filteredfiles;
}

void loadbg() {
  menu = 0;
  t = 0;
  Cx = 0;
  Cy = 0;
  paloffset = 0;
  bglist = loadFilenames(sketchPath("")+"data/", "deb");
  loadbg(bglist[menuselect]);
  inactive = 0;
  bgno = menuselect;
}

void optionsCheckKeyPress(int kc) {
  switch (kc) {
    case UP: {
      menuselect--;
      if (menu == 0) {
        if (menuselect<0) menuselect=bglist.length-1;
      } else {
        if (menuselect<0) menuselect=edopname.length-1;
      }
      break;
    }
    case DOWN: {
      menuselect++;
      if (menu == 0) {
        if (menuselect>bglist.length-1) menuselect=0;
      } else {
        if (menuselect>edopname.length-1) menuselect=0;
      }
      break;
    }
    case +RIGHT:
    case LEFT: {
      if (menu == 1) {
        switch (menuselect) {
          case 2:
            if ((palf<=edopset[2][0] && kc==LEFT) || (palf>=edopset[2][2] && kc==RIGHT)) return;
            palf += edopset[2][1]*((kc==LEFT)?-1 :1); break;
          case 3:
            palc = kc==RIGHT; break;
          case 4:
            palcreverse = kc==RIGHT; break;
          case 5:
            if ((palssa<=edopset[menuselect][0] && kc==LEFT) || (palssa>=edopset[menuselect][2] && kc==RIGHT)) return;
            palssa += edopset[menuselect][1]*((kc==LEFT)?-1 :1); break;
          case 6:
            if ((vCx<=edopset[menuselect][0] && kc==LEFT) || (vCx>=edopset[menuselect][2] && kc==RIGHT)) return;
            vCx += edopset[menuselect][1]*((kc==LEFT)?-0.5 :0.5); break;
          case 7:
            if ((vCy<=edopset[menuselect][0] && kc==LEFT) || (vCy>=edopset[menuselect][2] && kc==RIGHT)) return;
            vCy += edopset[menuselect][1]*((kc==LEFT)?-0.5 :0.5); break;
          case 9:
            if ((scale<=edopset[menuselect][0] && kc==LEFT) || (scale>=edopset[menuselect][2] && kc==RIGHT)) return;
            scale += edopset[menuselect][1]*((kc==LEFT)?-0.5 :0.5); break;
          case 10:
            if ((Mxscale<=edopset[menuselect][0] && kc==LEFT) || (Mxscale>=edopset[menuselect][2] && kc==RIGHT)) return;
            Mxscale += edopset[menuselect][1]*((kc==LEFT)?-0.5 :0.5); break;
          case 11:
            if ((Mxfreq<=edopset[menuselect][0] && kc==LEFT) || (Mxfreq>=edopset[menuselect][2] && kc==RIGHT)) return;
            Mxfreq += edopset[menuselect][1]*((kc==LEFT)?-0.5 :0.5); break;
          case 12:
            if ((Mxinterl<=edopset[menuselect][0] && kc==LEFT) || (Mxinterl>=edopset[menuselect][2] && kc==RIGHT)) return;
            Mxinterl += edopset[menuselect][1]*((kc==LEFT)?-1 :1); break;
          case 13:
            if ((Myscale<=edopset[menuselect][0] && kc==LEFT) || (Myscale>=edopset[menuselect][2] && kc==RIGHT)) return;
            Myscale += edopset[menuselect][1]*((kc==LEFT)?-0.5 :0.5); break;
          case 14:
            if ((Myfreq<=edopset[menuselect][0] && kc==LEFT) || (Myfreq>=edopset[menuselect][2] && kc==RIGHT)) return;
            Myfreq += edopset[menuselect][1]*((kc==LEFT)?-0.5 :0.5); break;
          case 15:
            if ((staticx<=edopset[menuselect][0] && kc==LEFT) || (staticx>=edopset[menuselect][2] && kc==RIGHT)) return;
            staticx += edopset[menuselect][1]*((kc==LEFT)?-0.5 :0.5); break;
        }
      }
    }
  }
}
