int oldmenu = -1;
class ChildApplet extends PApplet {
  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    log.log("succesfully created childapplet");
  }

  public void settings() {
    size(400, 720, P3D);
  }
  public void setup() { 
    windowTitle("editor");
    windowMove(150, 200);
    windowResizable(false);
    textFont(MSG20);
    log.log("succesfully configured childapplet");
  }

  public void draw() {
    if (oldmenu != menu) {
      windowTitle(menutitle[menu]);
      log.log("switched to menu "+menu);
      oldmenu = menu;
    }
    background(0);
    renderButtons();
    switch (menu) {
      case 0: {
        textSize(32);
        fill(255);
        text(menutitle[menu], 20, 20, 380, 999);
        textSize(20);
        for (int i = 0; i<bglist.length; i++){
          if (i==menuselect) {
            fill(0, 255, 0);
          } else {
            fill(255);
          }
          if (i == bgno) {
            text(">", 10, i*30+100, 380, 999);
          }
          text(bglist[i], 30, i*30+100, 380, 999);
        }
          text("press e to go to the editor", 30, 700 ,380, 999);
        break;
      }
      case 1: {
        textSize(32);
        fill(255);
        text(menutitle[menu], 20, 20, 380, 999);
        textSize(20);
        text("press backspace to go to the", 30, 680 ,380, 999);
        text("background selector menu", 30, 700, 380, 999);
        
        // EDITOR MENU
        
        fill(255);
        for (int i = 0; i<edopname.length; i++) {
          int y = 100+i*30;
          if (i==menuselect) {
            fill(0, 255, 0);
          } else {
            fill(255);
          }
          text(edopname[i], 30, y);
          fill(255);
          if (edopset[i].length != 1) {
            switch (i) {
              case 2: {
                option(int(palf), i, y);
                break;
              }
              case 3: {
                option(int(palc), i, y);
                break;
              }
              case 4: {
                option(int(palcreverse), i, y);
                break;
              }
              case 5: {
                option(palssa, i, y);
                break;
              }
              case 6: {
                option(vCx, i, y);
                break;
              }
              case 7: {
                option(vCy, i, y);
                break;
              }
              case 9: {
                option(scale, i, y);
                break;
              }
              case 10: {
                option(Mxscale, i, y);
                break;
              }
              case 11: {
                option(Mxfreq, i, y);
                break;
              }
              case 12: {
                option(Mxinterl, i, y);
                break;
              }
              case 13: {
                option(Myscale, i, y);
                break;
              }
              case 14: {
                option(Myfreq, i, y);
                break;
              }
              case 15: {
                option(staticx, i, y);
                break;
              }
              default: {
                log.error("unknown editor option "+i);
                logexit();
              }
            }
          } else {
            switch (floor(edopset[i][0])) {
              default: {
                //log.error("unknown special editor option "+i);
                //logexit();
              }
            }
          }
        }
        break;
      }
      case 2: {
        surface.setSize(960, 720);
        windowMove(0, 200);
        break;
      }
      case 3: {
        surface.setSize(400, 720);
        windowMove(150, 200);
        break;
      }
    }
  }
  public void keyPressed() {
    if (key == ENTER && menu == 0) {
      loadbg();
    }
    if ((key == 'e'||key=='E') && menu == 0) {
      menu = 2;
      menuselect = 0;
        surface.setSize(960, 720);
        windowMove(0, 200);
    }
    if ((key == BACKSPACE) && menu == 1) {
      menu = 3;
      menuselect = 0;
        surface.setSize(400, 720);
        windowMove(150, 200);
    }
    optioncheckkeypress();
  }
  void option(float what, int i, int y) {
    if (!(what <= edopset[i][0])) text("<", 600, y);
    String[] bool = {"no", "yes"};
    if (edopset[i][0] == 0 &&edopset[i][2] == 1) {
      text(bool[int(what)], 620, y);
    } else {
      text(nf(what, 1, 0), 620, y);
    }
    if (!(what >= edopset[i][2])) text(">", 700, y);
  }
  public void mousePressed() {
    checkButtons();
  }
}
