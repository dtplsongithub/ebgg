Button[] buttons = new Button[12];

class Button {
  String id, text;
  int x, y, w, h, menu;
  boolean active = true;
  public Button(String _id, int _x, int _y, int _w, int _h, String _text, int _menu) {
    this.id = _id;
    this.x = _x;
    this.y = _y;
    this.w = _w;
    this.h = _h;
    this.text = _text;
    this.menu = _menu;
    log.log("succesfully created button "+id);
  }
  public boolean checkIfHovered() {
    return editor.mouseX > this.x && editor.mouseX < this.x + this.w && editor.mouseY > this.y && editor.mouseY < this.y + this.h;
  }
}

void renderButtons() {
  for (Button i: buttons) { 
    if (i.menu != menu || !i.active) continue;
    if (i.checkIfHovered()) {
      editor.fill(200);
    } else {
      editor.fill(255);
    }
    editor.rect(i.x, i.y, i.w, i.h);
    editor.fill(0);
    editor.text(i.text, i.x+10, i.y+20);
    editor.fill(255);
  }
}

void checkButtons() {
  for (Button i: buttons) {
    if (i.menu != menu || !i.active) continue;
    if (!i.checkIfHovered()) continue;
    switch (i.id) {
      case "01_name": menu = 5; break;
      case "01_pal": menu = 6; break;
      case "01_ptm": menu = 7; break;
      case "save": menu = 1; break;
      case "saveBackground": {
        if (fileExists(backgroundName+".deb")) {
          buttons[6].id = "confirmOverwrite";
          buttons[6].text = backgroundName+".deb already exists. overwrite?";
          buttons[6].w = ceil(textWidth(backgroundName+".deb already exists. overwrite?"))+30;
          buttons[7].active = true;
        } else {
          saveStrings("data/"+backgroundName+".deb", saveBackground());
          loadbglist();
        }
        break;
      }
      case "confirmOverwrite": {
        saveStrings("data/"+backgroundName+".deb", saveBackground());
        buttons[6].id = "saveBackground";
        buttons[6].text = "save";
        buttons[6].w = 100;
        buttons[7].active = false;
        loadbglist();
        break;
      }
      case "cancelOverwrite": {
        buttons[6].id = "saveBackground";
        buttons[6].text = "save";
        buttons[6].w = 100;
        buttons[7].active = false;
        break;
      }
      case "createPaletteColor": {
        menuselect = pal.length;
        pal = append(pal, 0xFFFFFFFF);
        scrollY = -menuselect*40+height/2-100;
        break;
      }
      case "savePaletteColor": {
        if (paletteEditTemp.length() != 7) {
          menutitle[8] = "please input a valid hex color. (#RRGGBB)";
        } else {
          menu = 6;
          pal[paletteIndexToEdit] = unhex(paletteEditTemp.substring(1, paletteEditTemp.length()))|0xFF000000;
          menutitle[8] = "edit palette color";
        }
        break;
      }
      case "editPaletteColor": {
        menu = 8;
        paletteIndexToEdit = menuselect;
        paletteEditTemp = "#"+hex(pal[menuselect], 6);
        break;
      }
      case "deletePaletteColor": {
        if (pal.length>max(palssa, 2)) {
          arrayCopy(pal, menuselect+1, pal, menuselect, pal.length-menuselect-1);
          pal = shorten(pal);
        };
        if (menuselect>0)menuselect--;
        break;
      }
    }
  }
}
