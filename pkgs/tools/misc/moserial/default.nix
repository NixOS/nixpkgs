{ lib
, stdenv
, fetchFromGitLab
, autoreconfHook
, intltool
, itstool
, pkg-config
, vala
, glib
, graphviz
, yelp-tools
, gtk3
, lrzsz
}:

stdenv.mkDerivation rec {
  pname = "moserial";
  version = "3.0.21";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "moserial_${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "sha256-wfdI51ECqVNcUrIVjYBijf/yqpiwSQeMiKaVJSSma3k=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
    itstool
    pkg-config
    vala
  ];

  buildInputs = [
    glib
    graphviz
    yelp-tools
    gtk3
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ lrzsz ]}
    )
  '';

  meta = with lib; {
    description = "Clean, friendly gtk-based serial terminal for the gnome desktop";
    homepage = "https://gitlab.gnome.org/GNOME/moserial";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ linsui ];
    platforms = platforms.linux;
    mainProgram = "moserial";
  };
}
