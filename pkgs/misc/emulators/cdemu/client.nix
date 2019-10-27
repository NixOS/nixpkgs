{ callPackage, python3Packages, intltool, makeWrapper }:
let pkg = import ./base.nix {
  version = "3.2.1";
  pkgName = "cdemu-client";
  pkgSha256 = "1d8m24qvv62xcwafw5zs4yf39vs64kxl4idqcngd8yyjhrb2ykg5";
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
