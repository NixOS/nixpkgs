{
  lib,
  mkKdeDerivation,
  substituteAll,
  qttools,
  xdpyinfo,
  systemsettings,
  libusb1,
}:
mkKdeDerivation {
  pname = "kinfocenter";

  patches = [
    (substituteAll {
      src = ./0001-tool-paths.patch;
      qdbus = "${lib.getBin qttools}/bin/qdbus";
      xdpyinfo = lib.getExe xdpyinfo;
    })
  ];

  # fix wrong symlink of infocenter pointing to a 'systemsettings5' binary in
  # the same directory, while it is actually located in a completely different
  # store path
  preFixup = ''
    ln -sf ${systemsettings}/bin/systemsettings $out/bin/kinfocenter
  '';

  extraBuildInputs = [ libusb1 ];
  meta.mainProgram = "kinfocenter";
}
