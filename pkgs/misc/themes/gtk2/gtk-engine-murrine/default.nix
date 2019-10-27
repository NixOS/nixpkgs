{ stdenv, fetchurl, pkgconfig, intltool, gtk2 }:

stdenv.mkDerivation rec {
  pname = "gtk-engine-murrine";
  version = "0.98.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "129cs5bqw23i76h3nmc29c9mqkm9460iwc8vkl7hs4xr07h8mip9";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool gtk2 ];

  meta = {
    description = "A very flexible theme engine";
    homepage = "https://gitlab.gnome.org/Archive/murrine";
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
