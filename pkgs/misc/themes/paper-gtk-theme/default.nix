{ stdenv, fetchFromGitHub, gtk }:

stdenv.mkDerivation rec {
  version = "6a5f14cfe697b0a829456a1fd560acdcddc6043f";
  name = "paper-gtk-theme-${version}";

  src = fetchFromGitHub {
    owner = "snwh";
    repo = "paper-gtk-theme";
    sha256 = "0kyn3a6sq0z22vds6szl630jv20pjskjbdg0wc8abxzwg0vwxc5m";
    rev = version;
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/themes/Paper/
    cp -r ./Paper/ $out/share/themes/
  '';

  preferLocalBuild = true;

  meta = with stdenv.lib; {
    description = "A modern desktop theme suite featuring a mostly flat with a minimal use of shadows for depth";
    homepage = "http://snwh.org/paper/";
    license = licenses.gpl3;
    maintainers = [ maintainers.simonvandel ];
    platforms = platforms.linux;
  };
}
