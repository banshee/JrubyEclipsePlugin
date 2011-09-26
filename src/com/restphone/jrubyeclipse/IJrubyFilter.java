package com.restphone.jrubyeclipse;

import org.eclipse.jface.viewers.ISelection;

public interface IJrubyFilter {
  String do_filter(ISelection s);

  Integer someOtherMethod();
}
