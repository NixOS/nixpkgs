{ stdenv, fetchFromGitHub, gdk_pixbuf, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "plano-theme-${version}";
  version = "3.28-2";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "plano-theme";
    rev = "v${version}";
    sha256 = "1xd8xpd8pxxsx6nqrxv2scm9fy6vig8qyxdydgkzhpscrjg9iq9f";
  };

  buildInputs = [ gdk_pixbuf gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/themes/Plano
    cp -a * $out/share/themes/Plano/
    rm $out/share/themes/Plano/LICENSE
  '';

  meta = {
    description = "Flat theme for GNOME & Xfce4";
    homepage = https://github.com/lassekongo83/plano-theme;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
