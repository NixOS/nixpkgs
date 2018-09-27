{ stdenv, fetchFromGitHub, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "zuki-themes-${version}";
  version = "3.28-3";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "zuki-themes";
    rev = "v${version}";
    sha256 = "0sgp41fpd8lyyb0v82y41v3hmb0ayv3zqqrv0m3ln0dzkr7ym9g7";
  };

  buildInputs = [ gdk_pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    install -dm 755 $out/share/themes
    cp -a Zuki* $out/share/themes/
  '';

  meta = with stdenv.lib; {
    description = "Themes for GTK3, gnome-shell and more";
    homepage = https://github.com/lassekongo83/zuki-themes;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
