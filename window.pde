class AwtProgram1 {
  JFrame window2;
  public AwtProgram1() {
    window2 = new JFrame("ebgg");
    window2.setSize(800, 600);
    window2.setLocation(500, 500);
    window2.setResizable(false);

    JTabbedPane tabPanel = new JTabbedPane();
    
    JPanel page1 = new JPanel(new BorderLayout());
    page1.setBorder(BorderFactory.createEmptyBorder());
    
    JTextPane textArea = new JTextPane();
    textArea.setContentType("text/html");
    textArea.setText(whatsnew);
    textArea.setEditable(false);
    textArea.setBackground(new Color(#EEEEFF));

    JScrollPane scrollPane = new JScrollPane(textArea);
    page1.add(scrollPane, BorderLayout.CENTER);

    JPanel page2 = new JPanel(new BorderLayout());
    page1.setBorder(BorderFactory.createEmptyBorder());
    
    JTextPane textArea2 = new JTextPane();
    textArea2.setContentType("text/html");
    textArea2.setText(about);
    textArea2.setEditable(false);
    textArea2.setBackground(new Color(#FFEEFF));

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
  EventQueue.invokeLater(new Runnable() {
    @Override
    public void run() {
      JOptionPane.showMessageDialog(errhandler, error, "Error", JOptionPane.ERROR_MESSAGE);
      errhandler.setVisible(false);
    }
  });
  log.error(error);
  if (critical) logexit();
}

/*
void showError(String error, boolean critical) {
  errhandler.setVisible(true);
  EventQueue.invokeLater(new Runnable() {
    @Override
    public void run() {
      JOptionPane.showMessageDialog(errhandler, error, "Error", JOptionPane.ERROR_MESSAGE);
    }
  });
  log.error(error);
  if (critical) logexit();
}

*/
