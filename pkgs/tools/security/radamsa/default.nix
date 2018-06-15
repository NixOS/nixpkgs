{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "radamsa-${version}";
  version = "0.5";

  src = fetchurl {
    url = "https://github.com/aoh/radamsa/releases/download/v${version}/${name}.tar.gz";
    sha256 = "1d2chp45fbdb2v5zpsx6gh3bv8fhcjv0zijz10clcznadnm8c6p2";
  };

  patchPhase = ''
    substituteInPlace ./tests/bd.sh  \
      --replace "/bin/echo" echo
    substituteInPlace ./Makefile \
      --replace "PREFIX=/usr" "PREFIX=$out" \
      --replace "BINDIR=/bin" "BINDIR="
  '';
  
  meta = {
    description = "A general purpose fuzzer";
    longDescription = "Radamsa is a general purpose data fuzzer. It reads data from given sample files, or standard input if none are given, and outputs modified data. It is usually used to generate malformed data for testing programs.";
    homepage = https://github.com/aoh/radamsa;
    maintainers = [ stdenv.lib.maintainers.markWot ];
    platforms = stdenv.lib.platforms.all;
  };
}
