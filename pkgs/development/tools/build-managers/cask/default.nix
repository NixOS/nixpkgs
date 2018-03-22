{ emacsPackagesNg, writeScriptBin }:
let

  emacs = emacsPackagesNg.emacsWithPackages (epkgs: [ epkgs.cask-package-toolset ]);
  cpt = emacsPackagesNg.cask-package-toolset;

in writeScriptBin "cask" ''
#!/bin/sh

exec ${emacs}/bin/emacs --script ${cpt}/share/emacs/site-lisp/elpa/cask-package-toolset-${cpt.version}/cask-package-toolset.el -- "$@"
''
