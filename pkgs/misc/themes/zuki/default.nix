{ stdenv, fetchFromGitHub, gdk_pixbuf, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "zuki-themes-${version}";
  version = "3.24-2";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "zuki-themes";
    rev = "v${version}";
    sha256 = "1js92qq1zi3iq40nl6n0m52hhhn9ql9i7y8ycg8vw3w0v8xyb4km";
  };

  buildInputs = [ gdk_pixbuf gtk_engines gtk-engine-murrine ];

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/themes
    cp -va Zuki* $out/share/themes/
  '';

  meta = {
    description = "A selection of themes for GTK3, gnome-shell and more";
    homepage = https://github.com/lassekongo83/zuki-themes;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
