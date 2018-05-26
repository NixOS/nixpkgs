{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "lsscsi-0.29";

  src = fetchurl {
    url = "http://sg.danny.cz/scsi/lsscsi-0.29.tgz";
    sha256 = "0538fjgxky03yn7mzyslkyi2af3yy5llsnjjcgjx73x08wd6hv5n";
  };

  preConfigure = ''
    substituteInPlace Makefile.in --replace /usr "$out"
  '';

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
