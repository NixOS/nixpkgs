{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "strace-4.5.20";

  src = fetchurl {
    url = "mirror://sourceforge/strace/${name}.tar.bz2";
    sha256 = "1gfakika8833373p09pfzn5y83kx4jmlxws6na8av9gad69hb37a";
  };

  meta = {
    homepage = http://strace.sourceforge.net/;
    description = "A system call tracer for Linux";
    license = "bsd";
  };
}
