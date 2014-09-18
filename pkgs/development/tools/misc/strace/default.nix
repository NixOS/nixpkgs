{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "strace-4.8";

  src = fetchurl {
    url = "mirror://sourceforge/strace/${name}.tar.xz";
    sha256 = "1y6pw4aj4rw5470lqks1ml0n8jh5xbhwr5c3gb00bj570wgjk4pl";
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
