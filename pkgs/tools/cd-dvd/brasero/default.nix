{ stdenv, fetchurl, pkgconfig, gtk3, itstool, gst_all_1, libxml2, libnotify
, libcanberra_gtk3, intltool, makeWrapper, dvdauthor, cdrdao
, dvdplusrwtools, cdrtools, libdvdcss, wrapGAppsHook }:

let
  major = "3.12";
  minor = "0";
  binpath = stdenv.lib.makeBinPath [ dvdauthor cdrdao dvdplusrwtools cdrtools ];

in stdenv.mkDerivation rec {
  version = "${major}.${minor}";
  name = "brasero-${version}";

  src = fetchurl {
    url = "http://download.gnome.org/sources/brasero/${major}/${name}.tar.xz";
    sha256 = "68fef2699b772fa262d855dac682100dbfea05563a7e4056eff8fe6447aec2fc";
  };

  nativeBuildInputs = [ pkgconfig itstool intltool wrapGAppsHook ];

  buildInputs = [ gtk3 libxml2 libnotify libcanberra_gtk3 libdvdcss
                  gst_all_1.gstreamer gst_all_1.gst-plugins-base
                  gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad
                  gst_all_1.gst-plugins-ugly gst_all_1.gst-libav ];

  # brasero checks that the applications it uses aren't symlinks, but this
  # will obviously not work on nix
  patches = [ ./remove-symlink-check.patch ];

  configureFlags = [
    "--with-girdir=$out/share/gir-1.0"
    "--with-typelibdir=$out/lib/girepository-1.0" ];

  NIX_CFLAGS_LINK = [ "-ldvdcss" ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${binpath}")
  '';

  meta = with stdenv.lib; {
    description = "A Gnome CD/DVD Burner";
    homepage = https://wiki.gnome.org/Apps/Brasero;
    maintainers = [ maintainers.bdimcheff ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
