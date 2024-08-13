/*
DJV_EBG
 */

import java.awt.BorderLayout;
import java.awt.Checkbox;
import java.awt.Color;
import java.awt.Desktop;
import java.awt.EventQueue;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JEditorPane;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSlider;
import javax.swing.JTabbedPane;
import javax.swing.JTextPane;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import javax.swing.event.HyperlinkEvent;
import javax.swing.event.HyperlinkListener;
import javax.swing.text.html.HTMLDocument;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.filechooser.FileSystemView;

ChildAppletEditor editor;
AwtProgram1 awt;
AwtProgramSettings awt2;

JFileChooser fileselector; // am i inconsistent with where i define things?

boolean errorIsBeingShown = false, warnIsBeingShown = false;

// settings-related things
byte version = (byte)175;
String versionString = "v1.75";
byte[] defaultSettings = {version, 1, 30, 0, 0, 1, 0, 0, 1}, config;
String settingsType = "cscccccc";
String[] settingsDescription = {
  "show big steps tip",
  "scroll sensitivity",
  "enable beta buttons",
  "enable java default window look and feel (requires restart)",
  "enable custom cursors (requires restart if disabling)",
  "fullscreen mode",
  "render when window is not active",
  "enable menu and button animations"
}, settingsHelp = {
  "",
  "",
  "when hovered/selected button will turn gray instead of blue like in beta versions of v1.3.0",
  "",
  "",
  "",
  "if no windows are active, the window will still render. if this option is disabled, the background window will not render when all ebgg windows are inactive for better performance.",
  ""
};
int[] o5 = {5, 255, 30};

// variables
long t = 0, realt = 0;
int bgno = 0, widthf, heightf;
float Cx=0, Cy=0;
int paloffset = 0;

// backgrouns settings
String backgroundName;
color[] pal = new color[2];
int palf, palssa, scale, Mxinterl, staticx, palcmult;
float vCx, vCy, Mxscale, Mxfreq, Myscale, Myfreq;
boolean palc, palcreverse;
int[][] ptm = new int[2][2];

int inactive = 0;

// fonts
PFont MSGothic20, MSGothic32;

PImage tile;

// other
int paletteIndexToEdit;
String paletteEditTemp = "";
double Mxtemp, Mytemp;
int scrollY = 0;
boolean fullscreenModeEnabled;

void settings() {
  size(960, 720, P2D);
}
void setup() {
  log = new LOGFILE();
  log.created("LOGFILE");

  log.log("checking save...");
  boolean saveFileExists = fileExists("config.dat");
  config = loadBytes("config.dat");
  boolean saveFileValid = checkSave();
  
  if (saveFileValid && saveFileExists) log.warn("config.dat problems were found and fixed.");
  log.log(saveFileValid?"config.dat problems were found and fixed.":"No config.dat problems found.");
  fullscreenModeEnabled = args!=null&&((String)args[0]).startsWith("--fullscreen");
  if (fullscreenModeEnabled) {
    this.windowResize(displayWidth, displayHeight);
  } else {
    widthf = config[6]==1?displayWidth:960; heightf=config[6]==1?displayHeight:720;
    updateSize();
  }
  editor = new ChildAppletEditor();
  frameRate(30);
  
  noStroke();
  background(0);
  hint(DISABLE_OPENGL_ERRORS);
  
  MSGothic20 = loadFont("MS-Gothic-20.vlw");
  log.loaded("font MSGothic20");
  MSGothic32 = loadFont("MS-Gothic-32.vlw");
  log.loaded("font MSGothic32");
  textFont(MSGothic20);

  buttons[0] = new TextButton("editName", 600, 75, 150, 30, "click to edit", 1);
  buttons[1] = new TextButton("editPalette", 600, 105, 150, 30, "click to edit", 1);
  buttons[2] = new TextButton("editPaletteMap", 600, 135, 150, 30, "click to edit", 1);
  
  buttons[3] = new TextButton("goToEditor", 30, 680, 60, 30, "back", 5);
  buttons[4] = new TextButton("goToEditor", 30, 680, 60, 30, "back", 6);
  buttons[5] = new TextButton("goToEditor", 30, 680, 60, 30, "back", 7);
  
  buttons[6] = new TextButton("saveBackground", 30, 650, 60, 30, "save", 1);
  
  buttons[7] = new TextButton("editPaletteColor", 600, 620, 0, 30, "edit this palette color", 6);
  buttons[8] = new TextButton("deletePaletteColor", 600, 650, 0, 30, "delete this palette color", 6);
  buttons[9] = new TextButton("savePaletteColor", 600, 680, 0, 30, "save palette color", 8);
  buttons[10] = new TextButton("createPaletteColor", 600, 680, 0, 30, "create new palette color", 6);
  
  buttons[11] = new TextButton("goToLoader", 385, 200, 0, 30,  "load a background", 10);
  buttons[12] = new TextButton("goToEditor", 440, 250, 0, 30,  "editor", 10);
  buttons[13] = new TextButton("goToSettings", 430, 300, 0, 30, "settings", 10);
  buttons[14] = new TextButton("goToChangelog", 425, 350, 0, 30, "changelog", 10);
  buttons[15] = new TextButton("goToAbout", 445, 400, 0, 30, "about", 10);
  buttons[16] = new TextButton("goToHelp", 450, 450, 0, 30, "help", 10);
  
  buttons[17] = new TextButton("goToTitlescreen", 30, 680, 0, 30, "back", 0);
  buttons[18] = new TextButton("goToTitlescreen", 30, 680, 0, 30, "back", 1);
  buttons[19] = new TextButton("goToTitlescreen", 50, 640, 0, 30, "back", 15);
  
  buttons[20] = new TextButton("applyResize", 30, 680, 0, 30, "resize", 14);
  buttons[21] = new TextButton("cancelResize", 110, 680, 0, 30, "cancel", 14);

  // load assets
  bigsteps = new MaskImage("assets/bigsteps", ".png");
  cursor = new MaskImage("assets/arrow_r", ".png");
  tile = loadImage("assets/tile.png");

  toolbox = new Toolbox();
  
  JFrame.setDefaultLookAndFeelDecorated(boolean(config[4]));
  
  awt = new AwtProgram1();
  awt2 = new AwtProgramSettings();
  errhandler.setLocation(-100, -100);
  errhandler.setAlwaysOnTop(true);
  fileselector = new JFileChooser(FileSystemView.getFileSystemView().getHomeDirectory());
  fileselector.setAcceptAllFileFilterUsed(false);
  fileselector.addChoosableFileFilter(new FileNameExtensionFilter(".deb (default format)", "deb"));
  fileselector.addChoosableFileFilter(new FileNameExtensionFilter(".debc (compressed format)", "debc")); // soon't

  restoreDefaults();
  
  log.loaded("finished loading");
}

void draw() {
  inactive++;
  realt++;
  background(0);
  boolean editorFocused;
  if (fullscreenModeEnabled) editorFocused = true;
  else editorFocused = editor.focused; // to prevent NullPointerException
  if (backgroundName != "no background loaded...") {
    if((config[7]==0)&&(!(focused||editorFocused))){
      fill(255);
      text("Please click on any ebgg window to resume.", 0, 380);
      return;
    }
    try {
      for (int y = 0; y < height/scale; y++) {
        Mxtemp = Math.sin(Math.toRadians((y+t))*Mxfreq)*Mxscale*((int(y%2==0)*-Mxinterl*2+1));
        Mytemp = Math.sin(Math.toRadians((y+t))*Myfreq)*Myscale;
        int ptmy = rem(Math.round(y+Cy+(int)(Math.round(Mytemp))), ptm.length);
        for (int x = 0; x < width/scale; x++) {
          int ptmx = rem(Math.round(x+Cx+(int)(Math.round(Mxtemp))+random(0, staticx)), ptm[0].length);
          if (ptm[ptmy][ptmx] < palssa) {
            fill(pal[ptm[ptmy][ptmx]]);
          } else {
            fill(pal[rem(ptm[ptmy][ptmx]+paloffset, pal.length-palssa)+palssa]);
          }
          rect(x*scale, y*scale, scale, scale);
        }
      }
    } catch (ArithmeticException e) {
      log.error(e+"", true);
    }
    Cx += vCx;
    Cy += vCy;
    t++;
    if (t%palf == 0 && palc) {
      paloffset += palcreverse ? -palcmult : palcmult;
      paloffset = rem(paloffset, pal.length - 1);
    }
  }
  if (inactive<100) {
    fill(0, (100-Math.max(inactive, 90))*25.5);
    rect(0, 0, textWidth(backgroundName) + 30, 30);
    rect(0, 30, textWidth("press backspace to toggle fullscreen mode") + 30, 30);
    fill(255, (100-Math.max(inactive, 90))*25.5);
    text(backgroundName, 10, 25);
    text("press backspace to toggle fullscreen mode", 10, 50);
  }
}

void mouseMoved() {
  inactive = 0;
}
void keyPressed() {
  if (key == BACKSPACE)  {
    config[6] = (byte)(config[6]==(byte)1?0:1);
    saveConfig(); // also calls updateSize() and remembers for when program is being started again.
  }
  inactive = 0;
  optionsCheckKeyPress(keyCode);
  if (menu == 5 || menu == 8 ) keyboardDetection(keyCode, key);
  if (key == ESC) logexit();
}

int rem(int x, int n) {
  if (x>0) return (int)(x%n);
  return (int)(Math.floor(x + (Math.ceil(Math.abs(x)/n+1)*n))%n);
}

String[] loadFilenames(String path, String filename) {
  File folder = new File(path);
  String[] files = new String[1];
  files = folder.list();
  String[] filteredfiles = {};
  for (int i = 0; i<files.length; i++) if (files[i].toLowerCase().endsWith("."+filename)) filteredfiles = append(filteredfiles, files[i]);
  return filteredfiles;
}

void optionsCheckKeyPress(int kc) {
  switch (kc) {
  case UP: {
      menuselect--;
      switch (menu) {
      case 1:
        if (menuselect==-1)menuselect=1;
        if (edopname[menuselect].charAt(0)=='\0') menuselect--;
        break;
      case 6: // palette editor
        if (menuselect<0) menuselect=pal.length-1;
        scrollY = -menuselect*40+height/2-100;
        break;
      case 14:
        if (menuselect<0) menuselect=menu14.length-1;
        break;
      }
      break;
    }
  case DOWN: {
      menuselect++;
      switch (menu) {
      case 1:
        if (menuselect>edopname.length-1)menuselect=edopname.length-1;
        if (edopname[menuselect].charAt(0)=='\0') menuselect++;
        break;
      case 6:
        if (menuselect>pal.length-1) menuselect=0;
        scrollY = -menuselect*40+height/2-100;
        break;
      case 14:
        if (menuselect>menu14.length-1) menuselect=0;
        break;
      }
      break;
    }
  case RIGHT:
  case 65:
  case 68:
  case LEFT: {
      if (menu == 1) {
        if (kc>60)bigstepsappear=false;
        switch (menuselect) {
        case 5:
          if (kc>60)return;
          if ((palf<=edopset[menuselect][0] && kc==LEFT) || (palf>=edopset[menuselect][2] && kc==RIGHT)) return;
          palf += edopset[3][1]*((kc==LEFT)?-1 :1);
          break;
        case 6:
          if (kc>60)return;
          palc = kc==RIGHT;
          break;
        case 7:
          if (kc>60)return;
          palcreverse = kc==RIGHT;
          break;
        case 8:
          if (kc>60)return;
          if ((palssa<=edopset[menuselect][0] && kc==LEFT) || (palssa>=edopset[menuselect][2] && kc==RIGHT)) return;
          palssa += edopset[menuselect][1]*((kc==LEFT)?-1 :1);
          break;
        case 9:
          if (kc>60)return;
          if ((palcmult<=edopset[menuselect][0] && kc==LEFT) || (palcmult>=edopset[menuselect][2] && kc==RIGHT)) return;
          palcmult += edopset[menuselect][1]*((kc==LEFT)?-1 :1);
          break;
        case 11:
          if ((vCx<=edopset[menuselect][0] && (kc==LEFT || kc==65)) || (vCx>=edopset[menuselect][2] && (kc==RIGHT || kc==68))) return;
          vCx += edopset[menuselect][1]*(kc>60?10:1)*((kc==LEFT||kc==65)?-1 :1);
          if (vCx<=edopset[menuselect][0]) vCx=(edopset[menuselect][0]);
          if (vCx>=edopset[menuselect][2]) vCx=(edopset[menuselect][2]);
          break;
        case 12:
          if ((vCy<=edopset[menuselect][0] && (kc==LEFT || kc==65)) || (vCy>=edopset[menuselect][2] && (kc==RIGHT || kc==68))) return;
          vCy += edopset[menuselect][1]*(kc>60?10:1)*((kc==LEFT||kc==65)?-1 :1);
          if (vCy<=edopset[menuselect][0]) vCy=(edopset[menuselect][0]);
          if (vCy>=edopset[menuselect][2]) vCy=(edopset[menuselect][2]);
          break;
        case 13:
          if (kc>60)return;
          if ((scale<=edopset[menuselect][0] && kc==LEFT) || (scale>=edopset[menuselect][2] && kc==RIGHT)) return;
          scale += edopset[menuselect][1]*((kc==LEFT)?-1 :1);
          break;
        case 14:
          if ((Mxscale<=edopset[menuselect][0] && (kc==LEFT || kc==65)) || (Mxscale>=edopset[menuselect][2] && (kc==RIGHT || kc==68))) return;
          Mxscale += edopset[menuselect][1]*(kc>60?10:1)*((kc==LEFT||kc==65)?-1 :1);
          if (Mxscale<=edopset[menuselect][0]) Mxscale=(edopset[menuselect][0]);
          if (Mxscale>=edopset[menuselect][2]) Mxscale=(edopset[menuselect][2]);
          break;
        case 15:
          if ((Mxfreq<=edopset[menuselect][0] && (kc==LEFT || kc==65)) || (Mxfreq>=edopset[menuselect][2] && (kc==RIGHT || kc==68))) return;
          Mxfreq += edopset[menuselect][1]*(kc>60?10:1)*((kc==LEFT||kc==65)?-1 :1);
          if (Mxscale<=edopset[menuselect][0]) Mxscale=(edopset[menuselect][0]);
          if (Mxscale>=edopset[menuselect][2]) Mxscale=(edopset[menuselect][2]);
          break;
        case 16:
          if (kc>60)return;
          if ((Mxinterl<=edopset[menuselect][0] && kc==LEFT) || (Mxinterl>=edopset[menuselect][2] && kc==RIGHT)) return;
          Mxinterl += edopset[menuselect][1]*((kc==LEFT)?-1 :1);
          break;
        case 17:
          if ((Myscale<=edopset[menuselect][0] && (kc==LEFT || kc==65)) || (Myscale>=edopset[menuselect][2] && (kc==RIGHT || kc==68))) return;
          Myscale += edopset[menuselect][1]*(kc>60?10:1)*((kc==LEFT||kc==65)?-1 :1);
          if (Myscale<=edopset[menuselect][0]) Myscale=(edopset[menuselect][0]);
          if (Myscale>=edopset[menuselect][2]) Myscale=(edopset[menuselect][2]);
          break;
        case 18:
          if ((Myfreq<=edopset[menuselect][0] && (kc==LEFT || kc==65)) || (Myfreq>=edopset[menuselect][2] && (kc==RIGHT || kc==68))) return;
          Myfreq += edopset[menuselect][1]*(kc>60?10:1)*((kc==LEFT||kc==65)?-1 :1);
          if (Myfreq<=edopset[menuselect][0]) Myfreq=(edopset[menuselect][0]);
          if (Myfreq>=edopset[menuselect][2]) Myfreq=(edopset[menuselect][2]);
          break;
        case 19:
          if (kc>60)return;
          if ((staticx<=edopset[menuselect][0] && kc==LEFT) || (staticx>=edopset[menuselect][2] && kc==RIGHT)) return;
          staticx += edopset[menuselect][1]*((kc==LEFT)?-1 :1);
          break;
        }
      }
      if (menu==14) {
        if (menu14tempValues[menuselect]<=1 && kc==LEFT) return;
        menu14tempValues[menuselect] += ((kc==LEFT)?-1 :1);
      }
      break;
    }
  case ENTER: {
      if (menu == 6) {
        menu = 8;
        paletteIndexToEdit = menuselect;
        paletteEditTemp = "#"+hex(pal[menuselect], 6);
      }
      break;
    }
  }
}
void updateSize() {
  widthf = config[6]==1?displayWidth:960; heightf = config[6]==1?displayHeight:720;
  this.windowResize(widthf, heightf);
}
void saveConfig() {
  updateSize();
  saveBytes("config.dat", config);
}
void restoreDefaults() {
  backgroundName = "no background loaded...";
  t = 0;Cx=0;Cy=0;paloffset=0;
  pal = new color[2];
  palf = 1; palssa = 0; scale = 6; Mxinterl = 0; staticx = 0; palcmult = 1;
  vCx = 0; vCy = 0; Mxscale = 0; Mxfreq = 0; Myscale = 0; Myfreq = 0;
  palc = false; palcreverse = false;
  ptm = new int[2][2];
}
color lerpRGBAColor(float r0, float g0, float b0, float a0, float r1, float g1, float b1, float a1, float amt) {
  return color(lerp(r0, r1, amt), lerp(g0, g1, amt), lerp(b0, b1, amt), lerp(a0, a1, amt));
}
void gradient(int x, int y, int w, int h, float r0, float g0, float b0, float a0, float r1, float g1, float b1, float a1) { // vertical only because yes
  editor.pushStyle();
  editor.noStroke();
  for (int i = 1; i<h;  i++) {
    editor.fill(lerpRGBAColor(r0, g0, b0, a0, r1, g1, b1, a1, (float)i/h));
    editor.rect(x, y+i-1, w, 1);
  }
  editor.popStyle();
}
