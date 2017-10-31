{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "radamsa-${version}";
  version = "0.4";

  src = fetchurl {
    url = "http://haltp.org/download/${name}.tar.gz";
    sha256 = "1xs9dsrq6qrf104yi9x21scpr73crfikbi8q9njimiw5c1y6alrv";
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
    homepage = http://github.com/aoh/radamsa;
    maintainers = [ stdenv.lib.maintainers.markWot ];
    platforms = stdenv.lib.platforms.all;
  };
}
