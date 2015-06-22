{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "strace-4.10";

  src = fetchurl {
    url = "mirror://sourceforge/strace/${name}.tar.xz";
    sha256 = "1qhfwijxvblwdvvm70f8bhzs4fpbzqmwwbkfp636brzrds30s676";
  };

  nativeBuildInputs = [ perl ];

  meta = with stdenv.lib; {
    homepage = http://strace.sourceforge.net/;
    description = "A system call tracer for Linux";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mornfall jgeerds ];
  };
}
