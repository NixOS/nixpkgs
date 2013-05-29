{ stdenv, fetchurl, bison, flex }:

stdenv.mkDerivation rec {
  name = "olsrd-0.6.5.4";

  src = fetchurl {
    url = "http://www.olsr.org/releases/0.6/${name}.tar.bz2";
    sha256 = "757327b9a22b066bd0cab2a8e1cdd1c462f474bb99864a175388aa5f0c70504c";
  };

  buildInputs = [ bison flex ];

  preConfigure = ''
    makeFlags="prefix=$out ETCDIR=$out/etc"
  '';

  meta = {
    description = "An adhoc wireless mesh routing daemon";
    license = "BSD";
    homepage = "http://olsr.org/";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
