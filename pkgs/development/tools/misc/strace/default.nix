{ stdenv, fetchurl, perl, libunwind }:

stdenv.mkDerivation rec {
  name = "strace-${version}";
  version = "4.17";

  src = fetchurl {
    url = "mirror://sourceforge/strace/${name}.tar.xz";
    sha256 = "06bl4dld5fk4a3iiq4pyrkm6sh63599ah8dmds0glg5vbw45pww1";
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
