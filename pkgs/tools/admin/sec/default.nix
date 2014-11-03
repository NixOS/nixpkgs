{ fetchurl, perl, stdenv }:

stdenv.mkDerivation rec {
  name = "sec-2.7.6";

  src = fetchurl {
    url = "mirror://sourceforge/simple-evcorr/${name}.tar.gz";
    sha256 = "1lrssln55p3bmn3d2hl8c5l5ix32bn8065w1cgycwsf7r6fww51p";
  };

  buildInputs = [ perl ];

  configurePhase = ":";
  buildPhase = ":";
  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp sec $out/bin
    cp sec.man $out/share/man/man1/sec.1
  '';
  doCheck = false;

  meta = {
    homepage = "http://simple-evcorr.sourceforge.net/";
    license = "GPLv2";
    description = "Simple Event Correlator";
    maintainers = [ stdenv.lib.maintainers.tv ];
    platforms = stdenv.lib.platforms.all;
  };

}
