{ emacsPackages, writeScriptBin }:
let

  emacs = emacsPackages.emacsWithPackages (epkgs: [ epkgs.cask-package-toolset ]);
  cpt = emacsPackages.cask-package-toolset;

in writeScriptBin "cask" ''
#!/bin/sh

exec ${emacs}/bin/emacs --script ${cpt}/share/emacs/site-lisp/elpa/cask-package-toolset-${cpt.version}/cask-package-toolset.el -- "$@"
''
