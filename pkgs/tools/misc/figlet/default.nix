{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "figlet-222";

  # some tools can be found here ftp://ftp.figlet.org/pub/figlet/util/
  src = fetchurl {
    url = ftp://ftp.figlet.org/pub/figlet/program/unix/figlet222.tar.gz;
    sha256 = "1y22hhwxhnwd6yrjgl5p3p44r22xzrhv9cksj58n85laac6jdfhs";
  };

  preConfigure = ''
    ensureDir $out/{man/man6,bin}
    makeFlags="DESTDIR=$out/bin MANDIR=$out/man/man6 DEFAULTFONTDIR=$out/share/figlet"
  '';

  meta = { 
    description = "Program for making large letters out of ordinary text";
    homepage = http://www.figlet.org/;
    license = "AFL-2.1";
  };
}
