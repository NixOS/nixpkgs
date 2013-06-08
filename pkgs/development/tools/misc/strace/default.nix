{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "strace-4.7";

  src = fetchurl {
    url = "mirror://sourceforge/strace/${name}.tar.xz";
    sha256 = "158iwk0pl2mfw93m1843xb7a2zb8p6lh0qim07rca6f1ff4dk764";
  };

  nativeBuildInputs = [ perl ];

  meta = {
    homepage = http://strace.sourceforge.net/;
    description = "A system call tracer for Linux";
    license = "bsd";
  };
}
