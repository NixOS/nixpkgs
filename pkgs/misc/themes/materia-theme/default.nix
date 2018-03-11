{ stdenv, fetchFromGitHub, gnome3, libxml2, gtk-engine-murrine, gdk_pixbuf, librsvg }:

stdenv.mkDerivation rec {
  name = "materia-theme-${version}";
  version = "20180110";

  src = fetchFromGitHub {
    owner = "nana-4";
    repo = "materia-theme";
    rev = "v${version}";
    sha256 = "1knfcc4bqibshbk5s4461brzw780gj7c1i42b168c6jw9p6br6bf";
  };

  nativeBuildInputs = [ gnome3.glib libxml2 ];

  buildInputs = [ gnome3.gnome-themes-standard gdk_pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

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
    description = "A Material Design theme for GNOME/GTK+ based desktop environments (formerly Flat-Plat)";
    homepage = https://github.com/nana-4/materia-theme;
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.mounium ];
  };
}
