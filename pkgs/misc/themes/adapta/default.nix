{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, parallel, sassc, inkscape, libxml2, glib, gdk_pixbuf, librsvg, gtk-engine-murrine, gnome3 }:

stdenv.mkDerivation rec {
  name = "adapta-gtk-theme-${version}";
  version = "3.92.1.72";

  src = fetchFromGitHub {
    owner = "adapta-project";
    repo = "adapta-gtk-theme";
    rev = version;
    sha256 = "19kav8m6aj4h7qg0z92k09lppzdgy6h9lxxv3qqqrl3hmg7bn0sx";
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
    homepage = https://github.com/adapta-project/adapta-gtk-theme;
    license = with licenses; [ gpl2 cc-by-sa-30 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
