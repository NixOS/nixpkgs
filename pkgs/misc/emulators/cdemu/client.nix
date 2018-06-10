{ callPackage, pythonPackages, intltool, makeWrapper }:
let pkg = import ./base.nix {
  version = "3.1.0";
  pkgName = "cdemu-client";
  pkgSha256 = "0s6q923g5vkahw5fki6c7a25f68y78zfx4pfsy0xww0z1f5hfsik";
};
in callPackage pkg {
  buildInputs = [ pythonPackages.python pythonPackages.dbus-python pythonPackages.pygobject3
                  intltool makeWrapper ];
  drvParams = {
    postFixup = ''
      wrapProgram $out/bin/cdemu \
        --set PYTHONPATH "$PYTHONPATH"
    '';
  };
}
