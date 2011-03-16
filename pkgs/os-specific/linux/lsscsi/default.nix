{ stdenv, fetchurl }:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "lsscsi-0.24";

  src = fetchurl {
    url = "http://sg.danny.cz/scsi/lsscsi-0.24.tgz";
    sha256 = "0c718w80vi9a0w48q8xmlnbyqzxfd8lax5dcbqg8gvg4l2zaba2c";
  };

  preConfigure = ''
    substituteInPlace Makefile.in --replace /usr "$out"
  '';
}
