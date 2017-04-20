{ stdenv, fetchFromGitHub, gnome3, libxml2, gtk-engine-murrine, gdk_pixbuf, librsvg }:

stdenv.mkDerivation rec {
  name = "flat-plat-gtk-theme-${version}";
  version = "20170323";

  src = fetchFromGitHub {
    owner = "nana-4";
    repo = "Flat-Plat";
    rev = "v${version}";
    sha256 = "18s05x5qkl9cwywd01498xampyya1lnpjyyknj61qxxw5rsgay9y";
  };

  nativeBuildInputs = [ gnome3.glib libxml2 ];

  buildInputs = [ gnome3.gnome_themes_standard gtk-engine-murrine gdk_pixbuf librsvg ];

  dontBuild = true;

  installPhase = ''
    patchShebangs install.sh
    sed -i install.sh \
      -e "s|^gnomever=.*$|gnomever=${gnome3.version}|" \
      -e "s|/usr||"
    destdir="$out" ./install.sh
    rm $out/share/themes/*/COPYING
  '';

  meta = with stdenv.lib; {
    description = "A Material Design-like theme for GTK+ based desktop environments";
    homepage = https://github.com/nana-4/Flat-Plat;
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.mounium ];
  };
}
