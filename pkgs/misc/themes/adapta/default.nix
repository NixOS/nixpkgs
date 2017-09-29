{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, parallel, sassc, inkscape, libxml2, glib, gdk_pixbuf, librsvg, gtk-engine-murrine, gnome3 }:

stdenv.mkDerivation rec {
  name = "adapta-gtk-theme-${version}";
  version = "3.91.2.147";

  src = fetchFromGitHub {
    owner = "tista500";
    repo = "Adapta";
    rev = version;
    sha256 = "1sv4s8rcc40v4lanapdqanlqf1l60rbc5wd7h73l5cigbqxxgda9";
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
  ];

  meta = with stdenv.lib; {
    description = "An adaptive Gtk+ theme based on Material Design";
    homepage = https://github.com/tista500/Adapta;
    license = with licenses; [ gpl2 cc-by-sa-30 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
