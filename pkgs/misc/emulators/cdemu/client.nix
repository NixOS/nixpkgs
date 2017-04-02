{ callPackage, pythonPackages, intltool, makeWrapper }:
let pkg = import ./base.nix {
  version = "3.0.3";
  pkgName = "cdemu-client";
  pkgSha256 = "1bfj7bc10z20isdg0h8sfdvnwbn6c49494mrmq6jwrfbqvby25x9";
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
