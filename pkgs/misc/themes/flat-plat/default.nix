{ stdenv, fetchFromGitHub, gnome3, libxml2, gtk-engine-murrine, gdk_pixbuf, librsvg }:

stdenv.mkDerivation rec {
  name = "flat-plat-gtk-theme-${version}";
  version = "20170605";

  src = fetchFromGitHub {
    owner = "nana-4";
    repo = "Flat-Plat";
    rev = "v${version}";
    sha256 = "1vcd6mkkfk9a1n5hwpdigvsdsfd8df83kc94w53rs7gw9pqfygya";
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
