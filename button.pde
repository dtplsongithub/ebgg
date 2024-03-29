Button[] buttons = new Button[2];

class Button {
  String id, text;
  int x, y, w, h, emenu;
  public Button(String _id, int _x, int _y, int _w, int _h, String _text, int _menu) {
    this.id = _id;
    this.x = _x;
    this.y = _y;
    this.w = _w;
    this.h = _h;
    this.text = _text;
    this.emenu = _menu;
    log.log("succesfully created button "+id);
  }
  public boolean checkIfHovered() {
    return editor.mouseX > this.x && editor.mouseX < this.x + this.w && editor.mouseY > this.y && editor.mouseY < this.y + this.h;
  }
}

void renderButtons() {
  for (Button i: buttons) { 
    if (i.emenu != menu) continue;
    if (i.checkIfHovered()) {
      editor.fill(200);
    } else {
      editor.fill(255);
    }
    editor.rect(i.x, i.y, i.w, i.h);
    editor.fill(0);
    editor.text(i.text, i.x+10, i.y+20);
  }
}

void checkButtons() {
  for (Button i: buttons) {
    if (i.emenu != menu) continue;
    if (!i.checkIfHovered()) continue;
    switch (i.id) {
      
    }
  }
}
