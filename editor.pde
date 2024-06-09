float[][] edopset = {{1}, {2}, {1, 1, 999}, {0, 1, 1}, {0, 1, 1}, {0, 1, 999}, {-50, 0.05, 50}, {-50, 0.05, 50}, {3}, {1, 1, 16}, {0, 0.1, 40}, {-300, 0.1, 300}, {0, 1, 1}, {-400, 0.1, 400}, {-30, 0.1, 30}, {0, 1, 400}};
final String[] edopname = {
  "name",
  "palette",
  "switch pal colors every n frames",
  "switch pal colors?",
  "switch pal colors in reverse?",
  "dont switch the first n items",
  "camera x velocity",
  "camera y velocity",
  "pallete map (or ptm)",
  "scale",
  "x wavyness frequency",
  "interleaved x wavyness?",
  "y wavyness scale",
  "y wavyness frequency",
  "x static effect"
};
Toolbox toolbox;

class Toolbox {
  ImageButton[] ib;
  Button[] b;
  int currentToolSelected = 0;
  public Toolbox() {
    ib = new ImageButton[6];
    b = new Button[4];
    ib[0] = new ImageButton("editorPencil", 30, 100, 7, "assets/pencil.png", 2);
    ib[1] = new ImageButton("editorLine", 62, 100, 7, "assets/line.png", 2);
    ib[2] = new ImageButton("editorRect", 94, 100, 7, "assets/rectangle.png", 2);
    ib[3] = new ImageButton("editorFillRect", 126, 100, 7, "assets/filledRectangle.png", 2);
    ib[4] = new ImageButton("editorCircle", 158, 100, 7, "assets/circle.png", 2);
    ib[5] = new ImageButton("editorFillCircle", 190, 100, 7, "assets/filledCircle.png", 2);
    b[0] = new Button("editorGrid", 222, 100, 110, 32, "Show grid", 7);
    b[0].toggler = true;
    b[1] = new Button("editorStatusBar", 332, 100, 180, 32, "Show status bar", 7);
    b[1].toggler = true;
    b[1].toggle = true;
    b[2] = new Button("editorPreviewMode", 512, 100, 230, 32, "Show numbers", 7);
    b[2].toggler = true;
    b[3] = new Button("editorUsePaloffset", 742, 100, 160, 32, "Use paloffset", 7);
    b[3].toggler = true;
  }
  public void render() {
    for (ImageButton i: ib) i.render();
    for (Button i: b) i.render();
    editor.fill(0, 127, 255, 64);
    editor.rect(this.currentToolSelected*32+30, 100, 32, 32);
    int rs = floor(min(930/ptm[0].length, 440/ptm.length));
    editor.noStroke();
    for (int y = 0; y<ptm.length; y++) {
      for (int x = 0; x<ptm[0].length; x++) {
        if (b[3].toggle) {
          if (ptm[y][x] < palssa) {
            editor.fill(pal[ptm[y][x]]);
          } else {
            editor.fill(pal[rem(ptm[y][x]+paloffset, pal.length-palssa)+palssa]);
          }
        } else if (!b[2].toggle){
          editor.fill(pal[ptm[y][x]]);
        } else {
          editor.colorMode(HSB, 100);
          editor.fill(ptm[y][x]*4, 100, 70);
          editor.colorMode(RGB, 255);
        }
        editor.rect(x*rs, y*rs+150, rs-int(b[0].toggle), rs-int(b[0].toggle));
      }
    }
    editor.stroke(0);
  }
  public void checkPress() {
    for (int i = 0; i<ib.length; i++) {
      ImageButton temp = ib[i];
      if (temp.activeMenu != menu || !temp.active) continue;
      if (!temp.checkIfHovered()) continue;
      if (i != 6) currentToolSelected = i;
    }
    for (int i = 0; i<b.length; i++) {
      Button temp = b[i];
      if (temp.activeMenu != menu || !temp.active) continue;
      if (!temp.checkIfHovered()) continue;
      if (b[i].toggler) b[i].toggle=!b[i].toggle;
    }
  }
}
