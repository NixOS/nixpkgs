{ stdenv, fetchurl, intltool, gtk3, librsvg, pkgconfig, pango, atk, gtk2, gdk_pixbuf }:
stdenv.mkDerivation {
  name = "gnome-themes-standard";
  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/gnome-themes-standard/3.7/gnome-themes-standard-3.7.92.tar.xz";
    sha256 = "0a1ed83c07f57b5b45b8f3817ca0ca14feecb56de505243c086fb306c88da8de";
  };
  
  buildInputs = [ intltool gtk3 librsvg pkgconfig pango atk gtk2 gdk_pixbuf ];

  preConfigure = ''
    cat ${gdk_pixbuf}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache ${librsvg}/lib/gdk-pixbuf/loaders.cache > loaders.cache
    export GDK_PIXBUF_MODULE_FILE=`readlink -e loaders.cache`
  '';
}