{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "figlet-2.2.4";

  # some tools can be found here ftp://ftp.figlet.org/pub/figlet/util/
  src = fetchurl {
    url = ftp://ftp.figlet.org/pub/figlet/program/unix/figlet-2.2.4.tar.gz;
    sha256 = "19qcmm9cmf78w1z7gbpyj9wmrfjzjl25sax9f2j37sijznrh263f";
  };

  preConfigure = ''
    mkdir -p $out/{man/man6,bin}
    makeFlags="DESTDIR=$out/bin MANDIR=$out/man/man6 DEFAULTFONTDIR=$out/share/figlet"
  '';

  meta = { 
    description = "Program for making large letters out of ordinary text";
    homepage = http://www.figlet.org/;
    license = "AFL-2.1";
  };
}
