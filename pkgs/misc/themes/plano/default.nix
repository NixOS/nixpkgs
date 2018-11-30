{ stdenv, fetchFromGitHub, gdk_pixbuf, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "plano-theme-${version}";
  version = "3.28-3";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "plano-theme";
    rev = "v${version}";
    sha256 = "0k9jgnifc2s8vsw9fanknx1mg8vlh6qa1cbb910nm4vgrxsbrc74";
  };

  buildInputs = [ gdk_pixbuf gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/themes/Plano
    cp -a * $out/share/themes/Plano/
    rm $out/share/themes/Plano/LICENSE
  '';

  meta = with stdenv.lib; {
    description = "Flat theme for GNOME & Xfce4";
    homepage = https://github.com/lassekongo83/plano-theme;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
