{ stdenv, fetchurl, makeWrapper, pkgconfig, cmake, fcitx, gtk3, isocodes, gnome3 }:

stdenv.mkDerivation rec {
  name = "fcitx-configtool-0.4.10";

  meta = with stdenv.lib; {
    description = "GTK-based config tool for Fcitx";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ cdepillabout ];
  };

  src = fetchurl {
    url = "https://download.fcitx-im.org/fcitx-configtool/${name}.tar.xz";
    sha256 = "1yyi9jhkwn49lx9a47k1zbvwgazv4y4z72gnqgzdpgdzfrlrgi5w";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ makeWrapper fcitx cmake isocodes gtk3
    gnome3.defaultIconTheme ];

  preFixup = ''
    wrapProgram $out/bin/fcitx-config-gtk3 \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS";
  '';
}

