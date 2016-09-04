{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "flat-plat-gtk-theme-eba3be5";

  src = fetchFromGitHub {
    owner = "nana-4";
    repo = "Flat-Plat";
    rev = "eba3be5eafd1140e1edb8b02411edb2f6c78b0ca";
    sha256 = "0vfdnrxspdwg4jr025dwjmdcrqnblhlw666v5b7qhkxymibp5j7h";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/themes/Flat-Plat
    rm .gitignore COPYING README.md
    cp -r . $out/share/themes/Flat-Plat
  '';

  meta = with stdenv.lib; {
    description = "A Material Design-like flat theme for GTK3, GTK2, and GNOME Shell";
    homepage = https://github.com/nana-4/Flat-Plat;
    licence = licenses.gpl2;
    maintainers = [ maintainers.mounium ];
    platforms = platforms.all;
  };
}

