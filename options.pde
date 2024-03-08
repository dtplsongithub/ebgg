int menuselect = 0;
int menu = 0;
String[] menutitle = {"","choose a background"};

void options() {
  push();
  textSize(32);
  fill(255);
  text(menutitle[menu], 20, 40);
  textSize(20);
  for (int i = 0; i<bglist.length; i++){
    if (i==menuselect) {
      fill(0, 255, 0);
    } else {
      fill(255);
    }
    text(bglist[i], 20, i*30+100);
  }
  pop();
}
