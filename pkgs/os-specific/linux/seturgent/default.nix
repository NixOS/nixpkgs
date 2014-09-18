{ stdenv, fetchurl, libX11, xproto, xdotool, unzip }:

stdenv.mkDerivation {
  name = "seturgent";

  src = fetchurl {
    url = "https://github.com/hiltjo/seturgent/archive/master.zip";
    sha256 = "c99d9164abd0e7fcb07d2f12dd4c32729f8dc16a4e197359ff09d7f448442990";
  };

  buildInputs = [
    libX11 xproto unzip
  ];

  installPhase = ''
    mkdir -pv $out/bin
    mv seturgent $out/bin
  '';

  meta = {
      description = "Set an application's urgency hint (or not)";
      maintainers = [ stdenv.lib.maintainers.yarr ];
      homepage = https://github.com/hiltjo/seturgent;
      license = stdenv.lib.licenses.mit;
  };
}
