{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "icmake-${version}";
  version = "7.22.01";

  src = fetchurl {
    url = "mirror://sourceforge/icmake/icmake_${version}.orig.tar.gz";
    sha256 = "1iv6p9cyvr9i2sjhklplr65llg1ycxqy7z4dfgn0nkwxgs9yf8mm";
  };

  preConfigure = ''
    patchShebangs ./
    sed -i "s;usr/;;g" INSTALL.im
  '';

  buildPhase = "./icm_bootstrap $out";

  installPhase = "./icm_install all /";

  meta = with stdenv.lib; {
    description = "A program maintenance (make) utility using a C-like grammar";
    homepage = http://icmake.sourceforge.net/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
