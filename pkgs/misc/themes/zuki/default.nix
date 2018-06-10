{ stdenv, fetchFromGitHub, gdk_pixbuf, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "zuki-themes-${version}";
  version = "3.28-1";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "zuki-themes";
    rev = "v${version}";
    sha256 = "1if39k8vgk4cpshl625vdf8lz6jgicgybd5nilycj66sf1k5jgb9";
  };

  buildInputs = [ gdk_pixbuf gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/themes
    cp -a Zuki* $out/share/themes/
  '';

  meta = {
    description = "Themes for GTK3, gnome-shell and more";
    homepage = https://github.com/lassekongo83/zuki-themes;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
