{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "gnome-breeze";
  src = fetchgit {
    url = "https://github.com/dirruk1/gnome-breeze";
    sha256 = "0hkk0gqlnrs1m4rb5r84f5y96qfamrbiwm09z89yc32124x1a1lm";
    rev = "49a5cd67a270e13a4c04a4b904f126ef728e9221";
  };
  installPhase = ''
    mkdir -p $out/share/themes
    cp -r Breeze* $out/share/themes
  '';

  meta = {
    description = "A GTK theme built to match KDE's breeze theme";
    homepage = "https://github.com/dirruk1/gnome-breeze";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ bennofs ];
    platforms = stdenv.lib.platforms.all;
    hydraPlatforms = [];
    preferLocalBuild = true;
  };
}
