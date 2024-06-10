{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, gtk3, libepoxy, wayland, wrapGAppsHook3 }:

stdenv.mkDerivation (finalAttrs: {
  pname = "wdisplays";
  version = "1.1.1";

  nativeBuildInputs = [ meson ninja pkg-config wrapGAppsHook3 ];

  buildInputs = [ gtk3 libepoxy wayland ];

  src = fetchFromGitHub {
    owner = "artizirk";
    repo = "wdisplays";
    rev = finalAttrs.version;
    sha256 = "sha256-dtvP930ChiDRT60xq6xBDU6k+zHnkrAkxkKz2FxlzRs=";
  };

  meta = with lib; {
    description = "Graphical application for configuring displays in Wayland compositors";
    homepage = "https://github.com/luispabon/wdisplays";
    maintainers = with maintainers; [ lheckemann ma27 ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "wdisplays";
  };
})
