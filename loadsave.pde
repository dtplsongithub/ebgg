void loadbg(String selection){ // yes
  if (selection == null) return;
  try {
    String[] values;
    values = loadStrings(selection);
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
    if (ptmwidth<1) throw new Error("Invalid pattern width "+ptmwidth);
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
    palcmult = int(values[16+ptmheight]);
    println(backgroundName+": ");
    println(".deb file size: "+ join(values, '\n').length());
    println(".debc file size: "+ (39+pal.length*3+ptmwidth*ptmheight));
  } catch (ArrayIndexOutOfBoundsException | NumberFormatException | Error e) {
    log.warn(e+". Failed to fully load background. Potential wrong background format.");
    restoreDefaults();
  }
}

String[] bglist;
void loadbglist(){
  bglist = loadFilenames(sketchPath("")+"backgrounds", "deb");
  log.log("succesfully loaded background list");
}

boolean fileExists(String filename) {
  byte[] file = loadBytes(filename);
  return file!=null;
}

String[] getBackground() {
  String[] backgroundTemp = new String[17+ptm.length];
  backgroundTemp[0] = backgroundName;
  String[] paltemp = new String[0];
  for (int i = 0; i<pal.length; i++) {
    paltemp = append(paltemp, hex(pal[i],6));
  }
  backgroundTemp[1] = join(paltemp, ",");
  backgroundTemp[2] = palf+"";
  backgroundTemp[3] = int(palc)+"";
  backgroundTemp[4] = int(palcreverse)+"";
  backgroundTemp[5] = palssa+"";
  backgroundTemp[6] = vCx+"";
  backgroundTemp[7] = vCy+"";
  for (int i = 0; i<ptm.length; i++) {
    backgroundTemp[8+i] = join(nf(ptm[i], 0), ",");
  }
  backgroundTemp[8+ptm.length] = "-ptmend";
  backgroundTemp[9+ptm.length] = scale+"";
  backgroundTemp[10+ptm.length] = Mxscale+"";
  backgroundTemp[11+ptm.length] = Mxfreq+"";
  backgroundTemp[12+ptm.length] = Mxinterl+"";
  backgroundTemp[13+ptm.length] = Myscale+"";
  backgroundTemp[14+ptm.length] = Myfreq+"";
  backgroundTemp[15+ptm.length] = staticx+"";
  backgroundTemp[16+ptm.length] = palcmult+"";
  return backgroundTemp;
}

byte[] getdebcBackground() {
  byte[] out = new byte[0];
  out = concat(out, getBytes("debc"));
  out = append(out, version);
  out = append(out, (byte)backgroundName.length());
  out = concat(out, getBytes(backgroundName));
  out = concat(out, getBytes((short)pal.length));
  for(color i: pal) {
    out = append(out, (byte)red(i));
    out = append(out, (byte)green(i));
    out = append(out, (byte)blue(i));
  }
  out = append(out, (byte)palf);
  out = append(out, (byte)(palc?1:0|(palcreverse?2:0)|(Mxinterl<<2))); // <<2 because mxinterl is an int for some reason?? ask me from 8 months ago as to **why**
  out = append(out, (byte)palssa);
  out = concat(out, getBytes(vCx));
  out = concat(out, getBytes(vCy));
  out = append(out, (byte)ptm[0].length);
  out = append(out, (byte)ptm.length);
  for (int[] i: ptm) {
    for (int j: i) {
      out = append(out, (byte)j);
    }
  }
  out = concat(out, getBytes(Mxscale));
  out = concat(out, getBytes(Mxfreq));
  out = concat(out, getBytes(Myscale));
  out = concat(out, getBytes(Myfreq));
  out = append(out, (byte)staticx);
  return out;
}

boolean checkSave() {
  boolean problem = false;
  
  if (!fileExists("config.dat")) {
    saveBytes("config.dat", defaultSettings);
    config = defaultSettings;
    problem = true;
  }
  
  if (config.length!=defaultSettings.length) {
    int originalConfigLength = config.length;
    config = expand(config, defaultSettings.length);
    if (config.length<defaultSettings.length) arrayCopy(defaultSettings, originalConfigLength, config, originalConfigLength, defaultSettings.length-originalConfigLength);
    problem = true;
  } else if (config[0] != version) {
    config[0] = version;
    problem = true;
  }
  if (config[1] > 1) { config[1] = 0; problem = true; }
  
  if (config[2] < 5) {
    config[2] = 30;
    problem = true;
  }
  
  if (config[3] > 1) { config[3] = 0; problem = true; }
  if (config[4] > 1) { config[4] = 0; problem = true; }
  if (config[5] > 1) { config[5] = 0; problem = true; }
  
  saveBytes("config.dat", config);
  return problem;
}

byte[] getBytes(float x) {
  byte[] out = new byte[4];
  int xint = Float.floatToIntBits(x);
  for (int i = 0; i<4;i++) out[i]=(byte)((xint>>8*i)%256);
  return out;
}

byte[] getBytes(int x) {
  byte[] out = new byte[4];
  for (int i = 0; i<4;i++) out[i]=(byte)((x>>8*i)%256);
  return out;
}

byte[] getBytes(short x) {
  byte[] out = new byte[2];
  for (int i = 0; i<2;i++) out[i]=(byte)((x>>8*i)%256);
  return out;
}

byte[] getBytes(String x) {
  byte[] out = new byte[x.length()];
  for (int i = 0; i<out.length;i++) out[i]=(byte)x.charAt(i);
  return out;
}
