{ stdenv, fetchFromGitHub, gnome3, libxml2, gtk-engine-murrine, gdk_pixbuf, librsvg, bc }:

stdenv.mkDerivation rec {
  name = "equilux-theme-${version}";
  version = "20181029";

  src = fetchFromGitHub {
    owner = "ddnexus";
    repo = "equilux-theme";
    rev = "equilux-v${version}";
    sha256 = "0lv2yyxhnmnkwxp576wnb01id4fp734b5z5n0l67sg5z7vc2h8fc";
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
