{ stdenv, fetchFromGitHub, gnome3 }:

stdenv.mkDerivation rec {
  name = "e17gtk-${version}";
  version = "${gnome3.version}.0";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "E17gtk";
    rev = "V${version}";
    sha256 = {
      "3.20" = "1dbhwsqqk12rff1971q2snvg38dx2y33dxr2l9yvwrhrhsgmc2v7";
      "3.22" = "17ir1f7ka765m57bdx3knq4k1837p118a384qnmsj83bz15k39i3";
    }."${gnome3.version}";
  };

  installPhase = ''
    mkdir -p $out/share/{doc,themes}/E17gtk
    cp -a index.theme gtk-2.0 gtk-3.0 metacity-1 $out/share/themes/E17gtk/
    cp -a README.md WORKAROUNDS screenshot.jpg $out/share/doc/E17gtk/
  '';

  meta = {
    description = "An Enlightenment-like GTK+ theme with sharp corners";
    homepage = https://github.com/tsujan/E17gtk;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
