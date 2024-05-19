void keyboardDetection(int kc, char k) { // keyboard detection for input
  //     ------numbers------                  ------alphabet------                space
  if (((kc >= 48 && kc <= 57) || (kc >= 65 && kc <= 90) || kc == 32) && backgroundName.length() < 32) {
    backgroundName += k;
  }
  //                       vvv !dont delete! vvv
  if (kc == BACKSPACE && backgroundName.length() > 0) { // or just 8 but eh
    backgroundName = backgroundName.substring(0, backgroundName.length()-1);
  }
}
