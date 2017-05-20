{ stdenv, makeWrapper, alsaLib, pkgconfig, fetchgit, gnome3, gdk_pixbuf, librsvg, wrapGAppsHook }:

stdenv.mkDerivation {
  name = "gvolicon-2014-04-28";
  src = fetchgit {
    url = "https://github.com/Unia/gvolicon";
    rev = "0d65a396ba11f519d5785c37fec3e9a816217a07";
    sha256 = "1sr9wyy7w898vq63yd003yp3k66hd4vm8b0qsm9zvmwmpiz4wvln";
  };

  buildInputs = [
    pkgconfig makeWrapper alsaLib gnome3.gtk gdk_pixbuf gnome3.defaultIconTheme
    librsvg wrapGAppsHook
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  NIX_CFLAGS_COMPILE = [ "-D_POSIX_C_SOURCE" ];

  meta = {
    description = "A simple and lightweight volume icon that sits in your system tray";
    homepage = https://github.com/Unia/gvolicon;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.bennofs ];
  };
}
