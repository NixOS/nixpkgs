{ stdenv, fetchurl, perl, libunwind }:

stdenv.mkDerivation rec {
  name = "strace-${version}";
  version = "4.19";

  src = fetchurl {
    url = "mirror://sourceforge/strace/${name}.tar.xz";
    sha256 = "10bjh2mrkvx41fk60b2iqv5b5k4r7a3qdsx04iyg904jqb3fp4vw";
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
