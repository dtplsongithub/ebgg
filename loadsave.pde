void loadBackground(String[] values){
  try {
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
    for (int y = 0; y<ptmheight; y++) {
      ptm[y] = int(values[8+y].split(","));
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
  } catch (Throwable e) {
    log.warn(e+". Failed to load background. Potential wrong background format.");
    restoreDefaults();
  }
}

void loaddebcBackground(byte[] data) { // are there binary streams in java? whatever i made my own
  try {
    BinaryInputStream file = new BinaryInputStream(data);
    file.reset();
    file.skipBytes(4); // "debc"
    file.skipBytes(1); // ebgg version, so far not really used, but will be useful later
    int nameLength = file.readUnsignedByte();
    String newBackgroundName = file.readString(nameLength);
    pal = new color[file.readInt(2)];
    for (int i=0;i<pal.length;i++) {
      int colore = file.readInt(3);
      pal[i] = colore|0xff000000;
    }
    palf = file.readUnsignedByte();
    int temp = file.readUnsignedByte();
    palc = boolean(temp&1);
    palcreverse = boolean(temp&2);
    Mxinterl = (temp&4)>0?1:0;
    println(boolean(temp&1), boolean(temp&2), boolean(temp&4));
    palssa = file.readUnsignedByte();
    vCx = file.readFloat();
    vCy = file.readFloat();
    int ptmwidth = file.readInt(2);
    int ptmheight = file.readInt(2);
    int ptmbitdepth = file.readUnsignedByte();
    ptm = new int[ptmheight][ptmwidth];
    for (int y = 0; y<ptmheight; y++) {
      for (int x = 0; x<ptmwidth; x++) {
        ptm[y][x] = file.readInt(ptmbitdepth);
      }
    }
    scale = file.readUnsignedByte();
    Mxscale = file.readFloat();
    Mxfreq = file.readFloat();
    Myscale = file.readFloat();
    Myfreq = file.readFloat();
    staticx = file.readUnsignedByte();
    palcmult = file.readUnsignedByte();
    backgroundName = newBackgroundName; // sometimes ebgg displays a background while its loading and its fuckin annoying so i did this because its restoring defaults before it loads and if the background name is "no background loaded..." it WONT actually display the background or else it would lag.
  } catch (ArrayIndexOutOfBoundsException | Error e) {
    log.warn(e+". Failed to load background. Potential wrong background format.");
    restoreDefaults();
  }
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
  out = concat(out, getBytes(pal.length, 2));
  for(color i: pal) {
    println(hex(i));
    out = append(out, (byte)i);
    out = append(out, (byte)(i>>8));
    out = append(out, (byte)(i>>16));
  }
  out = append(out, (byte)palf);
  out = append(out, (byte)((palc?1:0)+(palcreverse?2:0)+(Mxinterl<<2))); // <<2 because mxinterl is an int for some reason?? ask me from 8 months ago as to **why**
  out = append(out, (byte)palssa);
  out = concat(out, getBytes(vCx));
  out = concat(out, getBytes(vCy));
  out = concat(out, getBytes(ptm[0].length, 2));
  out = concat(out, getBytes(ptm.length, 2));
  int max = 1;
  for (int[] i: ptm) {
    for (int j: i) {
      if (max<j) max=j;
    }
  }
  int bitDepth = max>0xff?(max>0xffff?(max>0xffffff?4:3):2):1;
  println(bitDepth, max);
  out = append(out, (byte)bitDepth);
  for (int[] i: ptm) {
    for (int j: i) {
      out = concat(out, getBytes(j, bitDepth));
    }
  }
  out = append(out, (byte)scale);
  out = concat(out, getBytes(Mxscale));
  out = concat(out, getBytes(Mxfreq));
  out = concat(out, getBytes(Myscale));
  out = concat(out, getBytes(Myfreq));
  out = append(out, (byte)staticx);
  out = append(out, (byte)palcmult);
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

byte[] getBytes(int x, int bitDepth) {
  byte[] out = new byte[bitDepth];
  for (int i = 0; i<bitDepth;i++) out[i]=(byte)(x>>8*i);
  return out;
}

byte[] getBytes(String x) {
  byte[] out = new byte[x.length()];
  for (int i = 0; i<out.length;i++) out[i]=(byte)x.charAt(i);
  return out;
}

class BinaryInputStream { // when you dont understand the tutorials, make your own.
  public byte[] file;
  public int i;
  private int oldi;
  public BinaryInputStream(byte[] in) {
    file = new byte[in.length];
    arrayCopy(in, file);
  }
  
  public void reset() {
    i = 0;
  }
  
  public byte readByte() {
    oldi=i;
    i++;
    return file[oldi];
  }
  
  public int readUnsignedByte() {
    oldi=i;
    i++;
    return file[oldi]&0xFF;
  }
  
  public int readInt(int size) {
    int out = 0;
    for (int j = 0; j<size; j++) {
      out += readUnsignedByte()<<(8*j);
    }
    return out;
  }
  
  public float readFloat() {
    return Float.intBitsToFloat(readInt(4));
  }
  
  public String readString(int stringLength) {
    String out = "";
    for (int idx=0;idx<stringLength;idx++) {
      out += (char)file[i];
      i++;
    }
    return out;
  }
  
  public void skipBytes(int amount) {i+=amount;}
}
