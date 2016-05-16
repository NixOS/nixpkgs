{ stdenv, fetchurl }:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "lsscsi-0.28";

  src = fetchurl {
    url = "http://sg.danny.cz/scsi/lsscsi-0.28.tgz";
    sha256 = "0l6xz8545lnfd9f4z974ar1pbzfdkr6c8r56zjrcaazl3ad00p82";
  };

  preConfigure = ''
    substituteInPlace Makefile.in --replace /usr "$out"
  '';
}
