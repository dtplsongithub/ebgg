void loadbg(String which){
  String[] values = loadStrings(which);
  backgroundName = values[0];
  pal = new color[values[1].split(",").length];
  for (int i = 0; i<pal.length; i++){
    pal[i] = unhex("ff"+values[1].split(",")[i].trim());
  }
  palf = int(values[2]);
  palc = boolean(int(values[3]));
  palcreverse = boolean(int(values[4]));
  palssa = int(values[5]);
  vCx = float(values[6]);
  vCy = float(values[7]);
  int ptmwidth = values[8].split(",").length-1;
  int ptmheight = 0;
  for (int i = 0; true; i++) {
    if(8+i>values.length-1)break;
    if(values[8+i].indexOf("-") >= 0)break;
    ptmheight = i+1;
  }
  ptm = new int[ptmheight][ptmwidth];
  for (int x = 0; x<ptmwidth; x++) {
    for (int y = 0; y<ptmheight; y++) {
      ptm[y] = int(values[8+y].split(","));
    }
  }
  scale = int(values[9+ptmheight]);
  Mxscale = float(values[10+ptmheight]);
  Mxfreq = float(values[11+ptmheight]);
  Mxinterl = int(values[12+ptmheight]);
  Myscale = float(values[13+ptmheight]);
  Myfreq = float(values[14+ptmheight]);
  staticx = int(values[15+ptmheight]);
  log.log("succesfully loaded background "+which);
}

void savebg() {
  
}

String[] bglist;
void loadbglist(){
  bglist = loadStrings("bglist");
  log.log("succesfully loaded background list");
}

boolean fileExists(String filename) {
  byte[] file = loadBytes(filename);
  return file!=null;
}

String[] saveBackground() {
  String[] backgroundTemp = new String[15+ptm.length];
  return backgroundTemp;
  
}

boolean checkSave() {
  boolean problem = false;
  if (!fileExists("config.dat")) {
    saveBytes("config.dat", defaultSettings);
    config = defaultSettings;
    problem = true;
  }
  
  if (config.length<settingsLength) {
    config = expand(config, settingsLength);
    problem = true;
  } else if (config[0] != version) {
    config[0] = version;
    problem = true;
  }
  
  if (config[1] > 1) {
    config[1] = 0;
    problem = true;
  }
  
  saveBytes("config.dat", config);
  return problem;
}
