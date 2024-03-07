/*
DJV_EBG
*/

// variables
long t = 0;
int bgno = 0;
float Cx, Cy;
int paloffset = 0;


String bgname = "no background loaded...";
color[] pal;
int palf;
boolean palc;
boolean palcreverse;
int palssa;
float vCx, vCy;
int[][] ptm;
int scale; // why would there be a different scale on each axis?
float Mxscale;
double Mxtemp;
float Mxfreq;
int Mxinterl;
float Myscale;
double Mytemp;
float Myfreq;
int staticx;

int inactive = 0;

void setup() {
  size(960, 720);
  noStroke();
  textSize(15);
  frameRate(30);
  textFont(loadFont("MS-Gothic-20.vlw"));
  paloffset = 0;
  bglist = loadFilenames(sketchPath("")+"data/", "deb");
  try {
    bgno %= bglist.length;
  } catch (ArithmeticException e) {
    bgno = 0;
  }
  loadbg(bglist[bgno]);
}

void draw() {
  inactive++;
  background(0);
  for (int y = 0; y < 720/scale; y++){
    Mxtemp = Math.sin(Math.toRadians((y+t))*Mxfreq)*Mxscale*((int(y%2==0)*-Mxinterl*2+1));
    Mytemp = Math.sin(Math.toRadians((y+t))*Myfreq)*Myscale;
    for (int x = 0; x < 960/scale; x++){
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
  if(t%palf == 0){
    paloffset++;
    paloffset %= pal.length -1;
  }
  if (inactive<100){
    fill(0, (100-Math.max(inactive, 90))*25.5);
    rect(0, 0, textWidth(bgname) + 30, 30);
    fill(255, (100-Math.max(inactive, 90))*25.5);
    text(bgname, 10, 25); 
  }
}

void mousePressed() {
  bgno++;
  t = 0;
  Cx = 0;
  Cy = 0;
  paloffset = 0;
  bglist = loadFilenames(sketchPath("")+"data/", "deb");
  try {
    bgno %= bglist.length;
  } catch (ArithmeticException e) {
    bgno = 0;
  }
  loadbg(bglist[bgno]);
  inactive = 0;
}

void mouseMoved() {
  inactive = 0;
}
void keyPressed() {
  inactive = 0;
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
