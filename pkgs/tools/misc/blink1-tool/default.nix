{ stdenv, fetchurl, libusb1, pkgconfig, ... }:

stdenv.mkDerivation rec {
  name = "blink1-${version}";
  version = "1.98";

  src = fetchurl {
    url = "https://github.com/todbot/blink1/archive/v${version}.tar.gz";
    sha256 = "05hbnp20cdvyyqf6jr01waz1ycis20qzsd8hn27snmn6qd48igrb";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb1 ];

  configurePhase = ''
    cd commandline
  '';

  installPhase = ''
    PREFIX=$out make install
  '';

  meta = {
    description = "Command line client for the blink(1) notification light";
    homepage = https://blink1.thingm.com/;
    license = stdenv.lib.licenses.cc-by-sa-30;
    maintainers = [ stdenv.lib.maintainers.cransom ];
    platforms = stdenv.lib.platforms.linux;
  };
}
