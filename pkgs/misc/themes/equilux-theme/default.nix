{ stdenv, fetchFromGitHub, gnome3, libxml2, gtk-engine-murrine, gdk_pixbuf, librsvg, bc }:

stdenv.mkDerivation rec {
  name = "equilux-theme-${version}";
  version = "20180927";

  src = fetchFromGitHub {
    owner = "ddnexus";
    repo = "equilux-theme";
    rev = "equilux-v${version}";
    sha256 = "1j7ykygmwv3dmzqdc9byir86sjz6ykhv9bv1pll1bjvvnaalyzgk";
  };

  nativeBuildInputs = [ gnome3.glib libxml2 bc ];

  buildInputs = [ gnome3.gnome-themes-extra gdk_pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontBuild = true;

  installPhase = ''
    patchShebangs install.sh
    sed -i install.sh \
      -e "s|if .*which gnome-shell.*;|if true;|" \
      -e "s|CURRENT_GS_VERSION=.*$|CURRENT_GS_VERSION=${stdenv.lib.versions.majorMinor gnome3.gnome-shell.version}|"
    mkdir -p $out/share/themes
    ./install.sh --dest $out/share/themes
    rm $out/share/themes/*/COPYING
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A Material Design theme for GNOME/GTK+ based desktop environments";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.fpletz ];
  };
}
