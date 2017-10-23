{ stdenv, fetchurl, libX11, libXaw }:

stdenv.mkDerivation rec {
  name = "xbomb-2.2b";
  src = fetchurl {
    url    = "http://www.gedanken.org.uk/software/xbomb/download/${name}.tgz";
    sha256 = "0692gjw28qvh8wj9l58scjw6kxj7jdyb3yzgcgs9wcznq11q839m";
  };

  buildInputs = [ libX11 libXaw ];

  preBuild = ''
    substituteInPlace Makefile \
      --replace /usr/local $out
  '';

  meta = with stdenv.lib; {
    homepage = http://www.gedanken.org.uk/software/xbomb/;
    description = "Minesweeper for X11 with various grid sizes and shapes";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
