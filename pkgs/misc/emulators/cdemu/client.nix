{ callPackage, python3Packages, intltool, makeWrapper }:
let pkg = import ./base.nix {
  version = "3.2.3";
  pkgName = "cdemu-client";
  pkgSha256 = "1bvc2m63fx03rbp3ihgl2n7k24lwg5ydwkmr84gsjfcxp46q10zq";
};
in callPackage pkg {
  buildInputs = [ python3Packages.python python3Packages.dbus-python python3Packages.pygobject3
                  intltool makeWrapper ];
  drvParams = {
    postFixup = ''
      wrapProgram $out/bin/cdemu \
        --set PYTHONPATH "$PYTHONPATH"
    '';
  };
}
