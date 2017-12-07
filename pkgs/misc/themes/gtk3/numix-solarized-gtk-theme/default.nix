{ stdenv, fetchFromGitHub, sass, glib, gdk_pixbuf }:

stdenv.mkDerivation rec {
  version = "20160919";
  name = "numix-solarized-gtk-theme-${version}";

  src = fetchFromGitHub {
    owner = "Ferdi265";
    repo = "numix-solarized-gtk-theme";
    rev = version;
    sha256 = "0243w918ycmf9vnkzfvwnrxz9zc6xxk7167h8ywxj901pqy59kad";
  };

  postPatch = ''
    substituteInPlace Makefile --replace \
      'INSTALL_DIR=$(DESTDIR)/usr/share/themes' "INSTALL_DIR=$out/share/themes"
    patchShebangs .
  '';

  buildInputs = [sass glib gdk_pixbuf];

  meta = with stdenv.lib; {
    description = "GTK3.20-compatible version of bitterologist's Numix Solarized from deviantart";
    longDescription = ''
      This is a fork of the Numix GTK theme that replaces the colors of the theme
      and icons to use the solarized theme with a solarized green accent color.
      This theme supports both the dark and light theme, just as Numix proper.
    '';
    homepage = https://github.com/Ferdi265/numix-solarized-gtk-theme;
    downloadPage = https://github.com/Ferdi265/numix-solarized-gtk-theme/releases;
    license = licenses.gpl3;
    maintainers = [ maintainers.offline ];
    platforms = platforms.linux;
  };
}
