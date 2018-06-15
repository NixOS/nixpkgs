{ fetchurl, perl, stdenv }:

stdenv.mkDerivation rec {
  name = "sec-2.7.12";

  src = fetchurl {
    url = "mirror://sourceforge/simple-evcorr/${name}.tar.gz";
    sha256 = "0f5a2nkd5cmg1rziizz2gmgdwb5dz99x9pbxw30p384rjh79zcaa";
  };

  buildInputs = [ perl ];

  dontBuild = false;
  doCheck = false;

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp sec $out/bin
    cp sec.man $out/share/man/man1/sec.1
  '';

  meta = {
    homepage = http://simple-evcorr.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    description = "Simple Event Correlator";
    maintainers = [ stdenv.lib.maintainers.tv ];
    platforms = stdenv.lib.platforms.all;
  };
}
