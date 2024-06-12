class AwtProgram1 {
  JFrame window2;
  public AwtProgram1() {
    
    window2 = new JFrame("ebgg");
    window2.setSize(800, 600);
    window2.setLocation(500, 100);
    window2.setResizable(false);
    window2.setAlwaysOnTop(true);

    JTabbedPane tabPanel = new JTabbedPane();

    JPanel page1 = new JPanel(new BorderLayout());
    page1.setBorder(BorderFactory.createEmptyBorder());

    JEditorPane textArea = new JEditorPane();
    textArea.setContentType("text/html");
    textArea.setText(whatsnew);
    textArea.setEditable(false);
    textArea.setBackground(new Color(#EEEEFF));

    textArea.addHyperlinkListener(new HyperlinkListener() {
      @Override
        public void hyperlinkUpdate(HyperlinkEvent hle) {
        if (HyperlinkEvent.EventType.ACTIVATED.equals(hle.getEventType())) {
          Desktop desktop = Desktop.getDesktop();
          try {
            desktop.browse(hle.getURL().toURI());
          }
          catch (Exception e) {
            showError(e+"", true);
          }
        }
      }
    });


    JScrollPane scrollPane = new JScrollPane(textArea);
    page1.add(scrollPane, BorderLayout.CENTER);




    JPanel page2 = new JPanel(new BorderLayout());
    page1.setBorder(BorderFactory.createEmptyBorder());

    JTextPane textArea2 = new JTextPane();
    textArea2.setContentType("text/html");
    textArea2.setText(about);
    textArea2.setEditable(false);
    textArea2.setBackground(new Color(#FFEEFF));

    textArea2.addHyperlinkListener(new HyperlinkListener() {
      @Override
        public void hyperlinkUpdate(HyperlinkEvent hle) {
        if (HyperlinkEvent.EventType.ACTIVATED.equals(hle.getEventType())) {
          Desktop desktop = Desktop.getDesktop();
          try {
            desktop.browse(hle.getURL().toURI());
          }
          catch (Exception e) {
            showError(e+"", true);
          }
        }
      }
    });

    JScrollPane scrollPane2 = new JScrollPane(textArea2);
    page2.add(scrollPane2, BorderLayout.CENTER);

    tabPanel.addTab("What's new", page1);
    tabPanel.addTab("About", page2);

    window2.add(tabPanel);


    window2.setVisible(false);
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
