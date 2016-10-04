{ stdenv, fetchurl, unzip, zlib }:

stdenv.mkDerivation rec {
  nameNoVer = "uif2iso";
  name = "${nameNoVer}-0.1.7";

  src = fetchurl {
    url = "http://aluigi.altervista.org/mytoolz/${nameNoVer}.zip";
    sha256 = "1v18fmlzhkkhv8xdc9dyvl8vamwg3ka4dsrg7vvmk1f2iczdx3dp";
  };

  buildInputs = [unzip zlib];

  installPhase = ''
    make -C . prefix="$out" install;
  '';

  meta = {
    description = "Tool for converting single/multi part UIF image files to ISO";
    homepage = "http://aluigi.org/mytoolz.htm#uif2iso";
    license = stdenv.lib.licenses.gpl1Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
