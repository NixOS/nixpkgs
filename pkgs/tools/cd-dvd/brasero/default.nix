{ stdenv, fetchurl, pkgconfig, gtk3, itstool, gst_all_1, libxml2, libnotify
, libcanberra_gtk3, intltool, gnome3, makeWrapper, dvdauthor, cdrdao
, dvdplusrwtools, cdrtools, libdvdcss }:

let
  major = "3.12";
  minor = "0";
  GST_PLUGIN_PATH = stdenv.lib.makeSearchPath "lib/gstreamer-1.0" [
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav ];

in stdenv.mkDerivation rec {
  version = "${major}.${minor}";
  name = "brasero-${version}";

  src = fetchurl {
    url = "http://download.gnome.org/sources/brasero/${major}/${name}.tar.xz";
    sha256 = "68fef2699b772fa262d855dac682100dbfea05563a7e4056eff8fe6447aec2fc";
  };

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard dvdauthor
    cdrdao dvdplusrwtools cdrtools ];

  buildInputs = [ pkgconfig gtk3 itstool libxml2 libnotify libcanberra_gtk3
                  intltool gnome3.gsettings_desktop_schemas makeWrapper libdvdcss
                  gst_all_1.gstreamer gst_all_1.gst-plugins-base gnome3.dconf
                  gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad ];

  # brasero checks that the applications it uses aren't symlinks, but this
  # will obviously not work on nix
  patches = [ ./remove-symlink-check.patch ];

  configureFlags = [
    "--with-girdir=$out/share/gir-1.0"
    "--with-typelibdir=$out/lib/girepository-1.0" ];

  preFixup = ''
    for f in $out/bin/* $out/libexec/*; do
      wrapProgram "$f" \
        --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0" \
        --prefix GST_PLUGIN_PATH : "${GST_PLUGIN_PATH}" \
        --prefix GIO_EXTRA_MODULES : "${gnome3.dconf}/lib/gio/modules" \
        --prefix LD_LIBRARY_PATH : ${libdvdcss}/lib
    done
    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  meta = with stdenv.lib; {
    description = "A Gnome CD/DVD Burner";
    homepage = https://wiki.gnome.org/Apps/Brasero;
    maintainers = [ maintainers.bdimcheff ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
