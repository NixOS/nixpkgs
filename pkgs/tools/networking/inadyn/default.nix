{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "inadyn-1.98.1";

  src = fetchurl {
    url = "https://github.com/downloads/troglobit/inadyn/${name}.tar.bz2";
    sha256 = "1qkwmln9ccqbs5cldwximi1maapvzkm7mssxgff71n981d8ad83j";
  };

  preConfigure = ''
    export makeFlags=prefix=$out
  '';

  meta = {
    homepage = http://inadyn.sourceforge.net/;
    description = "Free dynamic DNS client";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
