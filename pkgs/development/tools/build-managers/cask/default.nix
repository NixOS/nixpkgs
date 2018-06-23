{ emacsPackages, writeScriptBin }:
let

  cask = emacsPackages.cask;

in writeScriptBin "cask" ''
#!/bin/sh

exec ${cask}/bin/cask $@
''
