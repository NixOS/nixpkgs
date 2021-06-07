{ lib, stdenv, fetchurl, makeWrapper, pkg-config, cmake, fcitx, gtk3, isocodes, gnome }:

stdenv.mkDerivation rec {
  name = "fcitx-configtool-0.4.10";

  meta = with lib; {
    description = "GTK-based config tool for Fcitx";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ cdepillabout ];
  };

  src = fetchurl {
    url = "https://download.fcitx-im.org/fcitx-configtool/${name}.tar.xz";
    sha256 = "1yyi9jhkwn49lx9a47k1zbvwgazv4y4z72gnqgzdpgdzfrlrgi5w";
  };

  nativeBuildInputs = [ cmake pkg-config makeWrapper ];
  buildInputs = [ fcitx isocodes gtk3 gnome.adwaita-icon-theme ];

  # Patch paths to `fcitx-remote`
  prePatch = ''
    for f in gtk{3,}/config_widget.c; do
      substituteInPlace $f \
        --replace 'EXEC_PREFIX "/bin/fcitx-remote"' '"${fcitx}/bin/fcitx-remote"'
    done
  '';

  preFixup = ''
    wrapProgram $out/bin/fcitx-config-gtk3 \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS";
  '';
}
