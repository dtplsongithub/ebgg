TextButton[] buttons = new TextButton[22];

public class TextButton {
  public String id, text;
  private int x, y, w, h, activeMenu;
  private float anim=0;
  public boolean active = true, toggle = false, toggler = false;
  public TextButton(String _id, int _x, int _y, int _w, int _h, String _text, int _menu) {
    this.id = _id;
    this.x = _x;
    this.y = _y;
    this.w = _w==0?ceil(textWidth(_text)+20):_w;
    this.h = _h;
    this.text = _text;
    this.activeMenu = _menu;
    log.created("button "+id);
  }
  public boolean checkIfHovered() {
    return editor.mouseX > this.x && editor.mouseX < this.x + this.w + anim && editor.mouseY > this.y - anim && editor.mouseY < this.y + this.h;
  }
  public void render() {
    float animTarget=0;
    boolean canDraw = this.activeMenu == menu && this.active;
    editor.fill(196,64);
    editor.noStroke();
    if (canDraw) editor.rect(this.x, this.y, this.w, this.h);
    editor.fill(255);
    if (this.checkIfHovered()) {
      if (config[8]==1) animTarget=8;
      if (config[3] == 1) editor.fill(192);
      else editor.fill(128, 192, 255);
    }
    if (canDraw) editor.rect(this.x+anim, this.y-anim, this.w, this.h);
    editor.fill(0);
    if (canDraw) editor.text(this.text, this.x+10+anim, this.y+20-anim);
    editor.fill(255);
    anim+=(animTarget-anim)/5;
    if (abs(animTarget - anim) < 0.5f || config[8]==0) anim = animTarget;
  }
}
public class ImageButton {
  public String id;
  public PImage img;
  private int x, y, w, h, scale = 1;
  public int activeMenu;
  public boolean active = true;
  public ImageButton(String _id, int _x, int _y, int _menu, String imgLocation, int imageScale) {
    img = loadImage(imgLocation);
    log.loaded("asset for imageButton "+imgLocation);
    this.id = _id;
    this.x = _x;
    this.y = _y;
    this.w = img.width;
    this.h = img.height;
    this.activeMenu = _menu;
    this.scale = imageScale;
    log.created("imageButton "+id);
  }
  public boolean checkIfHovered() {
    return editor.mouseX > this.x && editor.mouseX < this.x + this.w*scale && editor.mouseY > this.y && editor.mouseY < this.y + this.h*scale;
  }
  public void render() {
    if (this.activeMenu != menu || !this.active) return;
    editor.pushMatrix();
    editor.scale(this.scale);
    editor.image(this.img, x/scale, y/scale);
    if (this.checkIfHovered()) {
      if (config[3] == 1)
        editor.fill(127, 127);
      else
        editor.fill(0, 127, 255, 127);
      editor.rect(x/scale, y/scale, w, h);
    }
    editor.fill(255);
    editor.popMatrix();
  }
}

void renderButtons() {
  int idx = 0;
  for (TextButton i: buttons) {
    try {
      if ((idx>=12&&idx<=16)&&fullscreenModeEnabled) continue;
      i.render();
      idx++;
    } catch (NullPointerException e) {
      log.error(e+" on renderButtons()", true);
    }
  }
}

void checkButtons() {
  for (TextButton i: buttons) {
    if (i.activeMenu != menu || !i.active) continue; // god i love continue
    if (!i.checkIfHovered()) continue;
    
    switch (i.id) {
      case "editName": menu = 5; break;
      case "editPalette": menu = 6; break;
      case "editPaletteMap": menu = 7; toolbox.CANDRAW = false; break;
      case "goToLoader":
      case "saveBackground": {
        fileselector.setDialogTitle(i.id=="goToLoader"?"Please select file...":"Please select output file...");
        EventQueue.invokeLater(new Runnable() {
          @Override
          public void run() {
            int returnValue = fileselector.showDialog(errhandler, i.id=="goToLoader"?"Open":"Save");
            if (returnValue == JFileChooser.APPROVE_OPTION) {
              String path = fileselector.getSelectedFile().getPath(),
                ext = fileselector.getFileFilter().getDescription().split(" ")[0]; // to avoid copy+pasting code
              if (i.id=="goToLoader") {
                restoreDefaults();
                switch (ext) {
                  case ".deb":loadBackground(loadStrings(fileselector.getSelectedFile().getPath()));break;
                  case ".debc":loaddebcBackground(loadBytes(fileselector.getSelectedFile().getPath()));break;
                }
              } else {
                switch (ext) {
                  case ".deb":saveStrings(path+(path.endsWith(ext)?"":ext), getBackground());break;
                  case ".debc":saveBytes(path+(path.endsWith(ext)?"":ext), getdebcBackground());break;
                }
              }
            }
          }
        });
        break;
      }
      case "createPaletteColor": {
        menuSelection = pal.length;
        pal = append(pal, 0xFFFFFFFF);
        scrollY = -menuSelection*40+height/2-100;
        break;
      }
      case "savePaletteColor": {
        if (paletteEditTemp.length() != 7) {
          showInfo("please input a valid hex color. (#RRGGBB)");
        } else {
          menu = 6;
          pal[paletteIndexToEdit] = unhex(paletteEditTemp.substring(1, paletteEditTemp.length()))|0xFF000000;
        }
        break;
      }
      case "editPaletteColor": {
        menu = 8;
        paletteIndexToEdit = menuSelection;
        paletteEditTemp = "#"+hex(pal[menuSelection], 6);
        break;
      }
      case "deletePaletteColor": {
        if (pal.length>max(palssa, 2)) {
          arrayCopy(pal, menuSelection+1, pal, menuSelection, pal.length-menuSelection-1);
          pal = shorten(pal);
        };
        if (menuSelection>0)menuSelection--;
        break;
      }
      case "goToHelp": awt.window2.setVisible(true);awt.tabPanel.setSelectedIndex(1);break;
      case "goToChangelog": awt.window2.setVisible(true);awt.tabPanel.setSelectedIndex(0);break;
      case "goToSettings": awt2.settings.setVisible(true);break;
      case "goToEditor": menu=1;break;
      case "goToTitlescreen": menu=10;break;
      case "applyResize": ptm = new int[menu14tempValues[1]][menu14tempValues[0]]; menu=7;break;
      case "cancelResize": menu=7;break;
      case "goToAbout": menu=15;break;
    };
    break;
  }
  toolbox.checkPress();
}

boolean isButtonHovered() {
  for (TextButton i: buttons) {
    if (i.activeMenu != menu || !i.active) continue;
    if (i.checkIfHovered()) return true;
  }
  for (TextButton i: toolbox.b) {
    if (i.activeMenu != menu || !i.active) continue;
    if (i.checkIfHovered()) return true;
  }
  for (ImageButton i: toolbox.ib) {
    if (i.activeMenu != menu || !i.active) continue;
    if (i.checkIfHovered()) return true;
  }
  return false;
}
