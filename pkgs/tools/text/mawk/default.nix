{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mawk-1.3.4-20141206";

  src = fetchurl {
    url = "ftp://invisible-island.net/mawk/${name}.tgz";
    sha256 = "1j49ffl8gpfaq99hkylf3fjiygq74w1kpfp8f52xbpx57vn9587g";
  };

  meta = with stdenv.lib; {
    description = "Interpreter for the AWK Programming Language";
    homepage = http://invisible-island.net/mawk/mawk.html;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ehmry ];
    platforms = with platforms; unix;
  };
}
