package com.restphone.jrubyeclipse;

import java.io.File;
import java.io.IOException;
import java.net.URL;

import org.eclipse.core.runtime.FileLocator;
import org.eclipse.core.runtime.Platform;
import org.eclipse.jface.action.Action;
import org.eclipse.jface.action.IMenuManager;
import org.eclipse.jface.text.TextSelection;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.osgi.service.datalocation.Location;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Text;
import org.eclipse.ui.ISelectionListener;
import org.eclipse.ui.IWorkbenchPart;
import org.eclipse.ui.part.ViewPart;

public class RubyOutputView extends ViewPart implements ISelectionListener {
  @Override
  public void createPartControl(Composite parent) {
    jrubyPluginController = new JrubyPluginController();
    textControl = new Text(parent, SWT.BORDER);
    try {
      buildJrubyFilename();
      addMenus();
      createJrubyFilter();
      getSite().getPage().addSelectionListener(new ISelectionListener() {
        @Override
        public void selectionChanged(IWorkbenchPart part, ISelection selection) {
          textControl.setText(jrubyFilter.do_filter(selection));
        }
      });
    } catch (Exception e) {
      String localizedMessage = e.getLocalizedMessage();
      textControl.setText(localizedMessage);
    }
  }

  @Override
  public void selectionChanged(IWorkbenchPart part, ISelection selection) {
    textControl.setText(selection.toString());
  }

  @Override
  public void setFocus() {
  }

  private void addMenus() {
    IMenuManager dropDownMenu = getViewSite().getActionBars().getMenuManager();
    dropDownMenu.add(new Action("Reload jruby file " + rubyFilterFile.getName()) {
      @Override
      public void run() {
        createJrubyFilter();
      }
    });
  }

  private String buildJrubyFilename() throws IOException {
    Location instanceLocation = Platform.getInstanceLocation();
    URL find = FileLocator.toFileURL(instanceLocation.getURL());
    String workspaceDirectory = find.getFile();
    rubyFilterFile = new File(workspaceDirectory, "ruby_filter.rb");
    return rubyFilterFile.getName();
  }

  private void createJrubyFilter() {
    jrubyFilter = (IJrubyFilter) jrubyPluginController.create_filter(rubyFilterFile.toString());
  }

  public static final String ID = "com.restphone.jrubyeclipse.RubyOutputView";
  private IJrubyFilter jrubyFilter;
  private JrubyPluginController jrubyPluginController;
  private File rubyFilterFile;
  private Text textControl;
}