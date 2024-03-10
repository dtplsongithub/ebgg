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
          if (i==menuselect) {
            fill(0, 255, 0);
          } else {
            fill(255);
          }
          text(edopname[i], 30, 100+i*30);
          if (edopset[i].length != 1) {
          } else {
            switch (floor(edopset[i][0])) {
              default: {
                
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
    println(menu);
    switch (keyCode) {
      case 38: {
        menuselect--;
        if (menuselect<0) menuselect=bglist.length-1;
        break;
      }
      case 40: {
        menuselect++;
        if (menuselect>bglist.length-1) menuselect=0;
        break;
      }
    }
  }
}
