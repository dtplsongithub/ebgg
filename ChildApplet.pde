int oldmenu = -1;
float menuselectAnim = 0;
boolean mouseHold = false;
class ChildAppletEditor extends PApplet {
  public ChildAppletEditor() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    log.created("childapplet");
  }

  public void settings() {
    size(960, 720, P2D);
  }
  public void setup() { 
    windowTitle("editor");
    textFont(MSGothic20);
    editor.background(0);
    ((PGraphicsOpenGL)g).textureSampling(3); // disable antialiasing on images (magic)
    log.loaded("childapplet");
  }

  public void draw() {
    if (oldmenu != menu && menu>=0) {
      try {
        menuselect=0; //<>//
        windowTitle(menutitle[menu]);
      } catch (ArrayIndexOutOfBoundsException e) {
        log.error(e+" on changing window title", true);
      }
      log.log("switched to menu "+menu);
      oldmenu = menu;
    }
    background(0);
    
    menuselectAnim+=(((float)menuselect)-menuselectAnim)/5;
    
    String[] menulist={};
    switch (menu) {
      case 0: menulist=bglist;break;
      case 1: menulist=edopname;break;
      case 14: menulist=menu14;break;
    };
    
    switch(menu) {
      case 0:
      case 1:
      case 14: {
        for (int i = 0; i<menulist.length; i++){
          float chance = max(1-abs((min(menuselectAnim-(float)i,1)+1)%2-1),0);
          fill((1-chance)*255, 255, (1-chance)*255);
          text(menulist[i], (int)(30+chance*6), i*30+100+scrollY);
        }
        break;
      }
    }
    
    switch (menu) {
      case 0: {
        fill(255);
        text(">", 10, bgno*30+100+scrollY);
        break;
      }
      case 1: {
        fill(255);
        for (int i = 0; i<edopname.length; i++) {
          int y = 100+i*30+scrollY;
          if (edopset[i].length != 1) {
            switch (i) {
              case 3:
                option(int(palf), i, y);
                break;
              case 4: 
                option(int(palc), i, y);
                break;
              case 5: 
                option(int(palcreverse), i, y);
                break;
              case 6: 
                option(palssa, i, y);
                break;
              case 7:
                option(palcmult, i, y);
                break;
              case 8: 
                option(vCx, i, y, true);
                break;
              case 9: 
                option(vCy, i, y, true);
                break;
              case 10: 
                option(scale, i, y);
                break;
              case 11: 
                option(Mxscale, i, y, true);
                break;
              case 12: 
                option(Mxfreq, i, y, true);
                break;
              case 13: 
                option(Mxinterl, i, y);
                break;
              case 14: 
                option(Myscale, i, y, true);
                break;
              case 15: 
                option(Myfreq, i, y, true);
                break;
              case 16: 
                option(staticx, i, y);
                break;
            }
          }
        }        
        if (bigstepsappear && boolean(config[1])) image(bigsteps.image, 717, 178);
        break;
      }
      case 5: {
        pushStyle();
        text(backgroundName, 30, 100);
        strokeWeight(2);
        stroke(255);
        if ( realt % 60 < 30 ) line(textWidth(backgroundName)+30, 100, textWidth(backgroundName)+30, 80);
        line(0, 101, width, 101);
        popStyle();
        break;
      }
      case 6: {
        noStroke();
        for (int i = 0; i<pal.length; i++) {
          if (i == menuselect) {
            fill(0x77FFFFFF);
            rect(170, 100+i*40+scrollY, 800, 40);
          }
          fill(pal[i]);
          rect(170, 100+i*40+scrollY, 40, 40);
          fill(255);
          text("#"+hex(pal[i], 6), 220, 130+i*40+scrollY);
        }
        text("paloffset >", 20, 130+(paloffset+palssa)*40+scrollY);
        stroke(0);
        break;
      }
      case 7: {
        toolbox.checkDraw();
        toolbox.render();
        break;
      }
      case 8: {
        pushStyle();
        text(paletteEditTemp, 30, 100);
        strokeWeight(2);
        stroke(255);
        if ( realt % 60 < 30 ) line(textWidth(paletteEditTemp)+30, 100, textWidth(paletteEditTemp)+30, 80);
        line(0, 101, width, 101);
        popStyle();
        if(paletteEditTemp.length()==7){
          fill(unhex(paletteEditTemp.substring(1, paletteEditTemp.length()))|0xFF000000);
          rect(50,120,50,50);
        } else {
          fill(255);
          noStroke();
          text("?",70,150);
        }
        break;
      }
      case 10: {
        text(versionString, 30, 700);
        text(fullscreenModeEnabled?"fullscreen mode is enabled":"", 30, 670);
        break;
      }
      case 14: { // RESIZE PTM
        for (int i = 0; i<menu14.length; i++){
          this.option(menu14tempValues[i], 3, i*30+100);
        }
        fill(255);
        text("!!NOTICE!! changing size will clear ptm!", 30, 400);
        break;
      }
      case 15: {
        for (int y = -2; y<ceil(this.height/tile.height)+2; y++) {
          for (int x = -2; x<ceil(this.width/tile.width)+2; x++) {
            image(tile, x*tile.width-int((float)realt/5)%tile.width, y*tile.height-int((float)realt/5)%tile.height);
          }
        }
        stroke(255, 127);
        noFill();
        rect(30, 30, 900, 660);
        fill(255);
        noStroke();
        textFont(MSGothic32);
        wavyText("ebgg "+versionString, (int)(width/2-textWidth("ebgg "+versionString)/2), 66, 5, 5, 0.1, 0.1, 0, HALF_PI, 16, 0, 3);
        textFont(MSGothic20);
        wavyText("by dtpls and Ponali", 385, 94, 3, 0, 0.15, 0, 0, 0, 10, 0, 2);
        boldText("coders:", 50, 125);
        wavyText("dtpls, Ponali", 130, 125, 0, 3, 0.14, 0.13, 0, 0, 10, 0, 2);
        boldText("bug fixers:", 50, 156);
        wavyText("dtpls, Ponali", 170, 156, 0, 3, 0.14, 0.14, 0, 0, 10, 0, 2);
        boldText("backgrounds:", 50, 187);
        wavyText("dtpls, Ponali, slinx92, hexahedron1", 180, 187, 0, 3, 0.14, 0.134, 0, 0, 10, 0, 2);
        boldText("assets:", 50, 218);
        wavyText("dtpls", 130, 218, 0, 3, 0.14, 0.12, 0, 0, 10, 0, 2);
        boldText("beta testers:", 50, 249);
        wavyText("slinx92", 190, 249, 0, 3, 0.14, 0.12, 0, 0, 10, 0, 2);
        boldText("special thanks to:", 50, 400);
        wavyText("hexahedron1, slinx92 , Restart, tom1212 (aka potato camputerr), ", 240, 400, 2, 4, 0.11, 0.02, 0, 0, 10, 0, 2);
        wavyText("laf9769, Shigesato Itoi, Retro Game Mechanics Explained,", 240, 425, 2, 4, 0.11, 0.02, 0, 0, 10, 0, 2);
        boldText("and you for using ebgg! :D", 240, 450);
        wavyText("Written in Processing 4.3", 355, 660, 3, 5, 0.11, 0.02, 0, 0, 10, 0, 2); //<>//
        break;
      }
      default: {
        log.error("Unknown menu: " + menu + " or missing break", false);
        menu = 10;
      }
    }
    textFont(MSGothic32);
    fill(0);
    if (menutitle[menu] != "") rect(0, 0, 999, 50);
    fill(255);
    if (menu>=0) {
      try {
        text(menutitle[menu], 20, 40);
      } catch (ArrayIndexOutOfBoundsException e) {
        log.error("ArrayIndexOutOfBoundsException on rendering title", true);
      }
    }
    textFont(MSGothic20);
    renderButtons();
    mouseHold = editor.mousePressed;
  }
  public void keyPressed() {
  if (menu == 5 || menu == 8 ) keyboardDetection(editor.keyCode, editor.key);
    optionsCheckKeyPress(editor.keyCode);
    if (key == ESC) logexit();
    if (key == 's') {
      image(cursor.image, this.mouseX, this.mouseY);
      saveFrame("screenshot.png");
    }
  }
  void option(float what, int i, int y) {
    if( what == -0 ) what = 0;
    if (!(what <= edopset[i][0])) text("<", 600, y);
    String[] bool = {"no", "yes"};
    if (edopset[i][0] == 0 && edopset[i][2] == 1) {
      text(bool[int(what)], 620, y);
    } else {
      text(nf(what, 1, 0), 620, y);
    }
    if (!(what >= edopset[i][2])) text(">", 700, y);
  }
  void option(float what, int i, int y, boolean hasBigSteps) {
    if( what == -0 ) what = 0;
    fill(255, 255, 0);
    if (!(what <= edopset[i][0]) && hasBigSteps) text("<<", 570, y);
    fill(255);
    if (!(what <= edopset[i][0])) text("<", 600, y);
    String[] bool = {"no", "yes"};
    if (edopset[i][0] == 0 && edopset[i][2] == 1) {
      text(bool[int(what)], 620, y);
    } else {
      text(nf(what, 1, 0), 620, y);
    }
    if (!(what >= edopset[i][2])) text(">", 700, y);
    fill(255, 255, 0);
    if (!(what >= edopset[i][2]) && hasBigSteps) text(">>", 720, y);
    fill(255);
  }
  public void mousePressed() {
    checkButtons();
  }
  public void mouseWheel(processing.event.MouseEvent e) {
    if (menu == 0 || menu == 6) scrollY -= e.getCount()*(config[2]&0xFF);
  }
  public void mouseMoved() {
    if (boolean(config[5])) {
      if (isButtonHovered()) cursor(HAND); 
      else if (menu == 5 || menu == 8) cursor(TEXT);
      else cursor(ARROW);
    }
  }
  public void mouseReleased() {
    this.mouseMoved();
  }
  // xm/ym - x/y modifier (how much it moves)
  // xf/yf - x/y frequency (how fast it moves)
  // xo/yo - x/o offset (you can probably figure it out by yourself idk how to explain it)
  // xs/ys - x/y spacing (isnt it obvious?)
  public void wavyText(String text, int x, int y, float xm, float ym, float xf, float yf, float xo, float yo, int xs, int ys, float sm) {
    for (int i = 0; i < text.length(); i++) text(text.charAt(i), (int)(x+sin((realt+sm*i)*xf+xo)*xm+i*xs), (int)(y+sin((realt+sm*i)*yf+yo)*ym+i*ys));
  }
  public void boldText(String text, int x, int y) {
    text(text, x, y);
    fill(255, 127);
    text(text, x, y+1);
    text(text, x, y-1);
    text(text, x+1, y);
    text(text, x-1, y);
    fill(255);
  }
}
