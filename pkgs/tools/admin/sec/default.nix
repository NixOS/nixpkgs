{ fetchurl, perl, stdenv }:

stdenv.mkDerivation rec {
  name = "sec-2.8.0";

  src = fetchurl {
    url = "mirror://sourceforge/simple-evcorr/${name}.tar.gz";
    sha256 = "0q9fhkkh0n0jya4kf5c54smk4xbnv01hqhip2y6fnnj9imwskymz";
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
