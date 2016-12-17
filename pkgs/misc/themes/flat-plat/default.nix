{ stdenv, fetchFromGitHub, gnome3, libxml2, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "flat-plat-gtk-theme-${version}";
  version = "2016-12-03";

  src = fetchFromGitHub {
    owner = "nana-4";
    repo = "Flat-Plat";
    rev = "49a5a51ec1a5835ff04ba2c62c9bccbd3f49bbe6";
    sha256 = "1w4b16cp2yv5rpijcqywlzrs3xjkvg8ppp2rfls1kvxq12rz4jkb";
  };

  nativeBuildInputs = [ gnome3.glib libxml2 ];

  buildInputs = [ gnome3.gnome_themes_standard gtk-engine-murrine ];

  dontBuild = true;

  installPhase = ''
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
