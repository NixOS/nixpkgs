{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "watch-0.2.0";

  src = fetchurl {
    url = http://procps.sourceforge.net/procps-3.2.8.tar.gz;
    sha256 = "0d8mki0q4yamnkk4533kx8mc0jd879573srxhg6r2fs3lkc6iv8i";
  };

  buildInputs = [ ncurses ];

  makeFlags = "watch usrbin_execdir=$(out)/bin" +
              (if stdenv.isDarwin then " PKG_LDFLAGS=" else "");

  enableParallelBuilding = true;

  installPhase = "mkdir $out; mkdir -p $out/bin; cp -p watch $out/bin";

  meta = {
    homepage = http://sourceforge.net/projects/procps/;
    description = "Utility for watch the output of a given command at intervals";
    platforms = stdenv.lib.platforms.unix;
  };
}
