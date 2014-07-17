{ fetchurl, perl, stdenv }:

stdenv.mkDerivation rec {
  name = "sec-2.7.5";

  src = fetchurl {
    url = "mirror://sourceforge/simple-evcorr/${name}.tar.gz";
    sha256 = "a21dcbb61aa99930f911b79e9412b875af12b08722a78295d210b896f23a0301";
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
