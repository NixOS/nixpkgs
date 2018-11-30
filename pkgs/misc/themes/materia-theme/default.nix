{ stdenv, fetchFromGitHub, gnome3, libxml2, gtk-engine-murrine, gdk_pixbuf, librsvg, bc }:

stdenv.mkDerivation rec {
  name = "materia-theme-${version}";
  version = "20181115";

  src = fetchFromGitHub {
    owner = "nana-4";
    repo = "materia-theme";
    rev = "v${version}";
    sha256 = "1vfwzvzbs4336vjg6y4asm21p64xc5f7cfsld5l159174ikcz5fp";
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
    ./install.sh --dest $out/share/themes
    rm $out/share/themes/*/COPYING
  '';

  meta = with stdenv.lib; {
    description = "A Material Design theme for GNOME/GTK+ based desktop environments";
    homepage = https://github.com/nana-4/materia-theme;
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.mounium ];
  };
}
