{ fetchFromGitHub, perl, stdenv }:

stdenv.mkDerivation rec {
  name = "sec-${meta.version}";

  src = fetchFromGitHub {
    owner = "simple-evcorr";
    repo = "sec";
    rev = meta.version;
    sha256 = "17qzw7k1r3svagaf6jb7166grwqsyxwd6p23b2m9q9h3ggcwynp9";
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
    version = "2.8.1";
  };
}
