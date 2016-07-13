{ stdenv, lib, fetchurl, pkgconfig, gtk3, itstool, gst_all_1, libxml2, libnotify
, libcanberra_gtk3, intltool, makeWrapper, dvdauthor, libburn, libisofs
, vcdimager, wrapGAppsHook, hicolor_icon_theme }:

# libdvdcss is "too old" (in fast "too new"), see https://bugs.launchpad.net/ubuntu/+source/brasero/+bug/611590

let
  major = "3.12";
  minor = "1";
  binpath = lib.makeBinPath [ dvdauthor vcdimager ];

in stdenv.mkDerivation rec {
  version = "${major}.${minor}";
  name = "brasero-${version}";

  src = fetchurl {
    url = "http://download.gnome.org/sources/brasero/${major}/${name}.tar.xz";
    sha256 = "09vi2hyhl0bz7imv3ky6h7x5m3d546n968wcghydwrkvwm9ylpls";
  };

  nativeBuildInputs = [ pkgconfig itstool intltool wrapGAppsHook ];

  buildInputs = [ gtk3 libxml2 libnotify libcanberra_gtk3 libburn libisofs
                  hicolor_icon_theme
                  gst_all_1.gstreamer gst_all_1.gst-plugins-base
                  gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad
                  gst_all_1.gst-plugins-ugly gst_all_1.gst-libav ];

  # brasero checks that the applications it uses aren't symlinks, but this
  # will obviously not work on nix
  patches = [ ./remove-symlink-check.patch ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-girdir=$out/share/gir-1.0"
    "--with-typelibdir=$out/lib/girepository-1.0"
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${binpath}" --prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH")
  '';

  meta = with stdenv.lib; {
    description = "A Gnome CD/DVD Burner";
    homepage = https://wiki.gnome.org/Apps/Brasero;
    maintainers = [ maintainers.bdimcheff ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
