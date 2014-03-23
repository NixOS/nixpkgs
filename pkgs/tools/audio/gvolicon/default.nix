{ stdenv, makeWrapper, alsaLib, pkgconfig, fetchgit, gnome3, hicolor_icon_theme, gdk_pixbuf, librsvg }:

stdenv.mkDerivation {
  name = "gvolicon";
  src = fetchgit {
    url = "https://github.com/Unia/gvolicon";
    rev = "26343415de836e0b05aa0b480c0c69cc2ed9e419";
    sha256 = "68858840a45b5f74803e85116c6219f805d6d944c00354662889549910856cdd";
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
    homepage = "https://github.com/Unia/gvolicon";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainer = stdenv.lib.maintainers.bennofs;
  };
}