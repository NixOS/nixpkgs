{ stdenv, fetchFromGitHub, gnome3 }:

stdenv.mkDerivation rec {
  name = "e17gtk-${version}";
  version = "${gnome3.version}.1";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "E17gtk";
    rev = "V${version}";
    sha256 = {
      "3.22" = "0y1v5hamssgzgcmwbr60iz7wipb9yzzj3ypzkc6i65mp4pyazrv8";
    }."${gnome3.version}";
  };

  installPhase = ''
    mkdir -p $out/share/{doc,themes}/E17gtk
    cp -va index.theme gtk-2.0 gtk-3.0 metacity-1 $out/share/themes/E17gtk/
    cp -va README.md WORKAROUNDS screenshot.jpg $out/share/doc/E17gtk/
  '';

  meta = {
    description = "An Enlightenment-like GTK+ theme with sharp corners";
    homepage = https://github.com/tsujan/E17gtk;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
