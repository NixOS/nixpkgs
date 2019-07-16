{ fetchFromGitHub, perl, stdenv }:

stdenv.mkDerivation rec {
  name = "sec-${meta.version}";

  src = fetchFromGitHub {
    owner = "simple-evcorr";
    repo = "sec";
    rev = meta.version;
    sha256 = "025cz3mr5yrdgs0i3h8v2znhvjkyh78kba1rzvl03ns2b1c49168";
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
    homepage = https://simple-evcorr.github.io;
    license = stdenv.lib.licenses.gpl2;
    description = "Simple Event Correlator";
    maintainers = [ stdenv.lib.maintainers.tv ];
    platforms = stdenv.lib.platforms.all;
    version = "2.8.2";
  };
}
