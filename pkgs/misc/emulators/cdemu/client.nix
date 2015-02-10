{ callPackage, python, dbus_python, intltool, makeWrapper }:
let pkg = import ./base.nix {
  version = "3.0.0";
  pkgName = "cdemu-client";
  pkgSha256 = "125f6j7c52a0c7smbx323vdpwhx24yl0vglkiyfcbm92fjji14rm";
};
in callPackage pkg {
  buildInputs = [ python dbus_python intltool makeWrapper ];
  drvParams = {
    postFixup = ''
      wrapProgram $out/bin/cdemu \
        --set PYTHONPATH "$PYTHONPATH"
    '';
  };
}
