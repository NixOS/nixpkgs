{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pkgconf-1.5.4";

  src = fetchurl {
    url = "https://distfiles.dereferenced.org/pkgconf/${name}.tar.xz";
    sha256 = "0r26qmij9lxpz183na3dxj6lamcma94cjhasy19fya44w2j68n4w";
  };

  meta = with stdenv.lib; {
    description = "Package compiler and linker metadata toolkit";
    homepage = https://git.dereferenced.org/pkgconf/pkgconf;
    platforms = platforms.all;
    license = licenses.isc;
    maintainers = with maintainers; [ zaninime ];
  };
}
