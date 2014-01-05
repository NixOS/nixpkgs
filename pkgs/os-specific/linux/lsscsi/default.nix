{ stdenv, fetchurl }:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "lsscsi-0.27";

  src = fetchurl {
    url = "http://sg.danny.cz/scsi/lsscsi-0.27.tgz";
    sha256 = "1d6rl2jwpd6zlqymmp9z4ri5j43d44db2s71j0v0rzs1nbvm90kb";
  };

  preConfigure = ''
    substituteInPlace Makefile.in --replace /usr "$out"
  '';
}
