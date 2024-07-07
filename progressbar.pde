class ProgressBar {
  public int x, y, w, h, borderColor = 0xFF00FF00, progressColor = 0xFF00FF00, interiorColor = 0xFF003300;
  public boolean visible = true, appendProgressToText = true;
  public byte progress = 0, indentation = 2, borderSize = 1, maxSteps = 100;
  public String text = "";
  private int interiorW, interiorH;
  public ProgressBar(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  public void render() {
    if (!visible) return;
    background(0);
    this.interiorW = this.w-this.indentation*2;
    this.interiorH = this.h-this.indentation*2;
    byte oldProgress = this.progress;
    this.progress *= 100/int(maxSteps);
    fill(0, 0);
    stroke(this.borderColor);
    strokeWeight(this.borderSize);
    rect(this.x, this.y, this.w, this.h);
    noStroke();
    fill(this.interiorColor);
    rect(this.x+this.indentation, this.y+this.indentation, this.w-this.indentation*2, this.h-this.indentation*2);
    textAlign(CENTER, CENTER);
    fill(this.progressColor);
    text(this.text + (this.appendProgressToText ? + this.progress + "%" : ""), this.w/2+this.x, this.h/2+this.y);
    loadPixels();
    try { 
      for (int y = 0; y < this.interiorH; y++) {
        for (int x = 0; x < int(lerp(0, this.interiorW, float(this.progress)/100)); x++) {
          int i = x+this.x+this.indentation+(y+this.y+this.indentation)*width;
          if (pixels[i] == this.progressColor) pixels[i] = this.interiorColor;
          else if (pixels[i] == this.interiorColor) pixels[i] = this.progressColor;
        }
      }
    } catch (ArrayIndexOutOfBoundsException e) {
      log.error(e+" on rendering progressBar", false);
    }
    updatePixels();
    textAlign(LEFT, BOTTOM);
    this.progress = byte(oldProgress+1);
    println(this.text);
  }
}

// ProgressBar progressBar;
