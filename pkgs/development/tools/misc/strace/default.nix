{ stdenv, fetchurl, perl, libunwind }:

stdenv.mkDerivation rec {
  name = "strace-${version}";
  version = "4.20";

  src = fetchurl {
    url = "mirror://sourceforge/strace/${name}.tar.xz";
    sha256 = "08y5b07vb8jc7ak5xc3x2kx1ly6xiwv1gnppcqjs81kks66i9wsv";
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
