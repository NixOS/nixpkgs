{ stdenv, fetchurl, libX11, xproto, xdotool, pkgs }:

stdenv.mkDerivation {
  name = "seturgent";

  src = fetchurl {
    url = "https://github.com/hiltjo/seturgent/archive/master.zip";
    sha256 = "c99d9164abd0e7fcb07d2f12dd4c32729f8dc16a4e197359ff09d7f448442990";
  };

  buildInputs = [
    libX11 xproto pkgs.unzip
  ];

  installPhase = ''
    mkdir -pv $out/bin
    mv seturgent $out/bin
  '';

  meta = {
      description = "Set an applications urgency hint (or not)";
      homepage = https://github.com/hiltjo/seturgent;
      license = stdenv.lib.licenses.mit;
  };
}
