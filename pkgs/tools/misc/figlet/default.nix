{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "figlet-2.2.5";

  # some tools can be found here ftp://ftp.figlet.org/pub/figlet/util/
  src = fetchurl {
    url = ftp://ftp.figlet.org/pub/figlet/program/unix/figlet-2.2.5.tar.gz;
    sha256 = "0za1ax15x7myjl8jz271ybly8ln9kb9zhm1gf6rdlxzhs07w925z";
  };

  installPhase = "make prefix=$out install";

  preConfigure = ''
    mkdir -p $out/{man/man6,bin}
    makeFlags="DESTDIR=$out/bin MANDIR=$out/man/man6 DEFAULTFONTDIR=$out/share/figlet CC=cc LD=cc"
  '';

  meta = {
    description = "Program for making large letters out of ordinary text";
    homepage = http://www.figlet.org/;
    license = stdenv.lib.licenses.afl21;
    platforms = stdenv.lib.platforms.unix;
  };
}
