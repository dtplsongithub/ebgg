void addLinkBehaviour(JEditorPane element){
  element.addHyperlinkListener(new HyperlinkListener() {
    @Override
      public void hyperlinkUpdate(HyperlinkEvent hle) {
      if (HyperlinkEvent.EventType.ACTIVATED.equals(hle.getEventType())) {
        Desktop desktop = Desktop.getDesktop();
        try {
          desktop.browse(hle.getURL().toURI());
        } catch (Exception e) {
          showError("Whoops! An error has occured while trying to redirect you to a webpage.\nLinux may not be entirely supported by Java and may be the cause of this issue.\nIf you are on a non-Linux operating system, check if your internet connection is working properly.\n\nTechnical information:\nLink: "+hle.getURL().toString()+"\nError: "+e+"", false);
        }
      }
    }
  });
}


class AwtProgram1 {
  JFrame window2;
  JTabbedPane tabPanel;
  public AwtProgram1() {
    window2 = new JFrame("ebgg");
    window2.setSize(800, 600);
    window2.setLocation(500, 100);
    window2.setResizable(false);
    window2.setAlwaysOnTop(true);

    tabPanel = new JTabbedPane();

    JPanel page1 = new JPanel(new BorderLayout());
    page1.setBorder(BorderFactory.createEmptyBorder());

    JTextPane textArea = new JTextPane();
    textArea.setContentType("text/html");
    textArea.setText(whatsnewText);
    textArea.setEditable(false);
    String cssRules = "body { font-family: "+ textArea.getFont().getFamily() +"; font-size: "+textArea.getFont().getSize()+";} "+
  "h1, h2 {color: #3300aa;}"+
  "h3 {color: #aa0000;}"+
  "strong, b {color: #330000}"+
  "a {color: #000077}";
    ((HTMLDocument)textArea.getDocument()).getStyleSheet().addRule(cssRules);
    textArea.setBackground(new Color(#EEFFFF));
    addLinkBehaviour(textArea);

    JScrollPane scrollPane = new JScrollPane(textArea);
    page1.add(scrollPane, BorderLayout.CENTER);

    // page 2 was about but has been moved to menu 15
    
    JPanel page3 = new JPanel(new BorderLayout());
    page3.setBorder(BorderFactory.createEmptyBorder());

    JTextPane textArea3 = new JTextPane();
    textArea3.setContentType("text/html");
    ((HTMLDocument)textArea3.getDocument()).getStyleSheet().addRule(cssRules);
    textArea3.setText(TFAQText);
    textArea3.setEditable(false);
    textArea3.setBackground(new Color(#EEFFEE));

    addLinkBehaviour(textArea3);

    JScrollPane scrollPane3 = new JScrollPane(textArea3);
    page3.add(scrollPane3, BorderLayout.CENTER);
    
    
    JPanel page4 = new JPanel(new BorderLayout());
    page4.setBorder(BorderFactory.createEmptyBorder());

    JTextPane textArea4 = new JTextPane();
    textArea4.setContentType("text/html");
    ((HTMLDocument)textArea4.getDocument()).getStyleSheet().addRule(cssRules);
    textArea4.setText(helpText);
    textArea4.setEditable(false);
    textArea4.setBackground(new Color(#FFEEFF));

    addLinkBehaviour(textArea4);

    JScrollPane scrollPane4 = new JScrollPane(textArea4);
    page4.add(scrollPane4, BorderLayout.CENTER);

    tabPanel.addTab("What's new", page1);
    // tabPanel.addTab("About", page2);
    tabPanel.addTab("Troubleshooting FAQ", page3);
    tabPanel.addTab("Miscellaneous help", page4);
    window2.add(tabPanel);


    window2.setVisible(false);
  }
}

class AwtProgramSettings {
  JFrame settings;
  Checkbox[] checkParameters = new Checkbox[7];
  JSlider[] sliderParameters = new JSlider[2];
  JLabel[] ttset = new JLabel[3];
  JLabel[] olset = new JLabel[1];
  public AwtProgramSettings() {
    settings = new JFrame("settings");
    settings.setSize(600, 450);
    settings.setLocation(500, 100);
    settings.setResizable(false);
    settings.setAlwaysOnTop(true);

    JPanel panel = new JPanel(new BorderLayout());
    panel.setBorder(BorderFactory.createEmptyBorder());

    int[] temporder = new int[4];
    int i = 0;
    int yoffset = 0;
    for (char s : settingsType.toCharArray()) {
      final int finali = i;
      switch (s) {
        case 'c':
          checkParameters[temporder[0]] = new Checkbox(settingsDescription[i], boolean(config[i+1]));
          checkParameters[temporder[0]].setBounds(30, 40+i*20+yoffset, 400, 20);
          checkParameters[temporder[0]].addItemListener(new ItemListener() {
            public void itemStateChanged(ItemEvent e) {
              config[finali+1] = byte(int(e.getStateChange()==1));
            }
          });
          settings.add(checkParameters[temporder[0]]);
          if (settingsHelp[i]!="") {
            ttset[temporder[2]] = new JLabel(settingsHelp[i].indexOf("!") == 0 ? "!" : "?");
            ttset[temporder[2]].setBounds(10, 40+i*20+yoffset, 200, 20);
            ttset[temporder[2]].setToolTipText(settingsHelp[i]);
            settings.add(ttset[temporder[2]]);
            temporder[2]++;
          };
          temporder[0]++;
          break;
        case 's':
          final int temporder1 = temporder[1];
          sliderParameters[temporder[1]] = new JSlider(o5[0], o5[1], o5[2]);
          sliderParameters[temporder[1]].setBounds(30, 60+i*20+yoffset, 300, 50);
          sliderParameters[temporder[1]].setPaintTrack(true);
          sliderParameters[temporder[1]].setPaintTicks(true);
          //sliderParameters[temporder[1]].setPaintLabels(true);
          sliderParameters[temporder[1]].setMajorTickSpacing(50);
          sliderParameters[temporder[1]].setMinorTickSpacing(10);
          sliderParameters[temporder[1]].addChangeListener(new ChangeListener() {
            public void stateChanged(ChangeEvent e) {
              config[finali+1] = byte(sliderParameters[temporder1].getValue());
            }
          });
          settings.add(sliderParameters[temporder[1]]);
          olset[temporder[1]] = new JLabel(settingsDescription[i]);
          olset[temporder[1]].setBounds(30, 40+i*20+yoffset, 200, 20);
          settings.add(olset[temporder[1]]);
          temporder[1]++;
          yoffset+=50;
          break;
      }
      i++;
    }
    
    JButton svset = new JButton("save");
    svset.setBounds(30, 350, 100, 20);
    svset.addActionListener(new ActionListener(){  
      public void actionPerformed(ActionEvent e){
        saveConfig();
        settings.setVisible(false); 
      }  
    });  
    
    settings.add(svset);
    
    JScrollPane spset = new JScrollPane(panel);

    settings.add(spset, BorderLayout.CENTER);
    settings.setVisible(false);
  }
}

JFrame errhandler = new JFrame();
void showError(String error, boolean critical) {
  errhandler.setVisible(true);
  if (errorIsBeingShown) return;
  errorIsBeingShown = true;
  EventQueue.invokeLater(new Runnable() {
    @Override
    public void run() {
      JOptionPane.showMessageDialog(errhandler, error+(critical?". The application will now close.":""), "Error", JOptionPane.ERROR_MESSAGE);
      errhandler.setVisible(false);
      errorIsBeingShown = false;
      if (critical) logexit();
    }
  });
}
void showWarning(String error) {
  errhandler.setVisible(true);
  if (warnIsBeingShown) return;
  warnIsBeingShown = true;
  EventQueue.invokeLater(new Runnable() {
    @Override
    public void run() {
      JOptionPane.showMessageDialog(errhandler, error, "Warning", JOptionPane.WARNING_MESSAGE);
      errhandler.setVisible(false);
      warnIsBeingShown = false;
    }
  });
}
void showInfo(String info) {
  errhandler.setVisible(true);
  if (warnIsBeingShown) return;
  warnIsBeingShown = true;
  EventQueue.invokeLater(new Runnable() {
    @Override
    public void run() {
      JOptionPane.showMessageDialog(errhandler, info, "Message", JOptionPane.PLAIN_MESSAGE);
      errhandler.setVisible(false);
      warnIsBeingShown = false;
    }
  });
}
