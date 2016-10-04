{ callPackage, pythonPackages, intltool, makeWrapper }:
let pkg = import ./base.nix {
  version = "3.0.1";
  pkgName = "cdemu-client";
  pkgSha256 = "1kg5m7npdxli93vihhp033hgkvikw5b6fm0qwgvlvdjby7njyyyg";
};
in callPackage pkg {
  buildInputs = [ pythonPackages.python pythonPackages.dbus-python intltool makeWrapper ];
  drvParams = {
    postFixup = ''
      wrapProgram $out/bin/cdemu \
        --set PYTHONPATH "$PYTHONPATH"
    '';
  };
}
