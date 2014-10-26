{ stdenv, makeWrapper, alsaLib, pkgconfig, fetchgit, gnome3, hicolor_icon_theme, gdk_pixbuf, librsvg }:

stdenv.mkDerivation {
  name = "gvolicon";
  src = fetchgit {
    url = "https://github.com/Unia/gvolicon";
    rev = "c04cafb88124e1e5edc61dd52f76bf13381d5167";
    sha256 = "31cf770dca0d216e3108b258b4c150cbeb3b127002d53fd6ddddfcf9e3e293aa";
  };

  buildInputs = [ pkgconfig makeWrapper alsaLib gnome3.gtk ];
  propagatedBuildInputs = [ gnome3.gnome_icon_theme gnome3.gnome_icon_theme_symbolic hicolor_icon_theme gdk_pixbuf librsvg ];
  installPhase = ''
    make install PREFIX=$out
    wrapProgram "$out/bin/gvolicon" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gtk}/share:${gnome3.gnome_themes_standard}/share:${gnome3.gsettings_desktop_schemas}/share:$out/share:$out/share/gvolicon:$XDG_ICON_DIRS"
    '';

  meta = {
    description = "A simple and lightweight volume icon that sits in your system tray.";
    homepage = https://github.com/Unia/gvolicon;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.bennofs ];
  };
}
