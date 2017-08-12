{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, parallel, sassc, inkscape, libxml2, glib, gdk_pixbuf, librsvg, gtk-engine-murrine, gnome3 }:

stdenv.mkDerivation rec {
  name = "adapta-gtk-theme-${version}";
  version = "3.91.1.47";

  src = fetchFromGitHub {
    owner = "tista500";
    repo = "Adapta";
    rev = version;
    sha256 = "1w41xwhb93p999g0835cmlax55a5fyz9j4m5nn6nss2d6g6nrxap";
  };

  preferLocalBuild = true;

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    parallel
    sassc
    inkscape
    libxml2
    glib.dev
    gnome3.gnome_shell
  ];

  buildInputs = [
    gdk_pixbuf
    librsvg
    gtk-engine-murrine
  ];

  postPatch = "patchShebangs .";

  configureFlags = [
    "--disable-gtk_legacy"
    "--disable-gtk_next"
    "--disable-unity"
    "--disable-parallel" # parallel build is not finishing
  ];

  meta = with stdenv.lib; {
    description = "An adaptive Gtk+ theme based on Material Design";
    homepage = https://github.com/tista500/Adapta;
    license = with licenses; [ gpl2 cc-by-sa-30 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
