{ stdenv, fetchurl, perl, libunwind }:

stdenv.mkDerivation rec {
  name = "strace-${version}";
  version = "4.12";

  src = fetchurl {
    url = "mirror://sourceforge/strace/${name}.tar.xz";
    sha256 = "51144b78cb9ba22211b95a5aafe0af3694c0d575b25975d80ca9dd4dfd7c1e59";
  };

  nativeBuildInputs = [ perl ];

  buildInputs = [ libunwind ]; # support -k

  meta = with stdenv.lib; {
    homepage = http://strace.sourceforge.net/;
    description = "A system call tracer for Linux";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mornfall jgeerds globin ];
  };
}
