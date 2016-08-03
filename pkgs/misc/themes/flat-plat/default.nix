{ stdenv, fetchurl, pkgs }:

stdenv.mkDerivation rec {
  name = "flat-plat-gtk-theme-${version}";
  version = "3.20.20160404";

  src = fetchurl {
    url = "https://github.com/nana-4/Flat-Plat/releases/download/${version}/Flat-Plat-${version}.tar.gz";
    md5 = "32716d645a2d4524dffba78c10b7d294";
  };

  buildInputs = [ pkgs.gnome3.gnome_themes_standard ];

  preferLocalBuild = true;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/themes
    cp -r .. $out/share/themes
  '';

  meta = {
    description = "A Material Design-like flat theme for GTK3, GTK2, and GNOME Shell";
    homepage = https://github.com/nana-4/Flat-Plat;
    licence = stdenv.lib.licenses.gpl2;
    maintainers = [ "Mounium <muoniurn@gmail.com>" ];
    platforms = stdenv.lib.platforms.all;
  };
}

