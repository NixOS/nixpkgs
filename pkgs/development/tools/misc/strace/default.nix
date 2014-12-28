{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "strace-4.9";

  src = fetchurl {
    url = "mirror://sourceforge/strace/${name}.tar.xz";
    sha256 = "0rbgznvrxzw7vfah7mwzb4j4mm9gp4hkpiyaghlivfa0qnjzwnq9";
  };

  nativeBuildInputs = [ perl ];

  meta = with stdenv.lib; {
    homepage = http://strace.sourceforge.net/;
    description = "A system call tracer for Linux";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.mornfall ];
  };
}
