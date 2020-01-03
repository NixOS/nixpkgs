{ lib, stdenv, fetchurl, perl, pkgconfig, wrapGAppsHook
, SDL, bzip2, glib, gtk3, libgcrypt, libpng, libspectrum, libxml2, zlib
}:

stdenv.mkDerivation rec {
  pname = "fuse-emulator";
  version = "1.5.7";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/fuse-${version}.tar.gz";
    sha256 = "0kaynjr28w42n3iha60mgr7nxm49w8j0v49plyrc7ka24qzmiqph";
  };

  nativeBuildInputs = [ perl pkgconfig wrapGAppsHook ];

  buildInputs = [ SDL bzip2 glib gtk3 libgcrypt libpng libspectrum libxml2 zlib ];

  configureFlags = [ "--enable-desktop-integration" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = http://fuse-emulator.sourceforge.net/;
    description = "ZX Spectrum emulator";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
