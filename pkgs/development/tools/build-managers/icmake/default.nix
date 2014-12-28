{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "icmake-${version}";
  version = "7.21.01";

  src = fetchurl {
    url = "mirror://sourceforge/icmake/icmake_${version}.orig.tar.gz";
    sha256 = "0jx547bb0h1z5f3v9kvjiq5bgarbrcs1h47y1nnwdkg0q1mqma1h";
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