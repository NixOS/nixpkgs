{ stdenv, lib, fetchurl, pkgconfig, gtk3, itstool, gst_all_1, libxml2, libnotify
, libcanberra-gtk3, intltool, dvdauthor, libburn, libisofs
, vcdimager, wrapGAppsHook, hicolor-icon-theme }:

let
  major = "3.12";
  minor = "2";
  binpath = lib.makeBinPath [ dvdauthor vcdimager ];

in stdenv.mkDerivation rec {
  version = "${major}.${minor}";
  pname = "brasero";

  src = fetchurl {
    url = "http://download.gnome.org/sources/brasero/${major}/${pname}-${version}.tar.xz";
    sha256 = "0h90y674j26rvjahb8cc0w79zx477rb6zaqcj26wzvq8kmpic8k8";
  };

  nativeBuildInputs = [ pkgconfig itstool intltool wrapGAppsHook ];

  buildInputs = [ gtk3 libxml2 libnotify libcanberra-gtk3 libburn libisofs
                  hicolor-icon-theme
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
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
