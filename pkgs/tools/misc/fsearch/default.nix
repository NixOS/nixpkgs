{ lib
, stdenv
, fetchFromGitHub
, gtk3
, pcre
, glib
, desktop-file-utils
, meson
, ninja
, pkg-config
, wrapGAppsHook
, unstableGitUpdater
, gettext
}:

stdenv.mkDerivation {
  pname = "fsearch";
  version = "unstable-2021-06-23";

  src = fetchFromGitHub {
    owner = "cboxdoerfer";
    repo = "fsearch";
    rev = "9300cc03ab2f0cea3a70abb5477bda8b52c4afd1";
    sha256 = "16qh2si48j113yhay5wawr7dvldks6jb32za41j2sng7n4ryw221";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook
    gettext
  ];

  buildInputs = [
    glib
    gtk3
    pcre
  ];

  preFixup = ''
    substituteInPlace $out/share/applications/io.github.cboxdoerfer.FSearch.desktop \
      --replace "Exec=fsearch" "Exec=$out/bin/fsearch"
  '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/cboxdoerfer/fsearch.git";
  };

  meta = with lib; {
    description = "A fast file search utility for Unix-like systems based on GTK+3";
    homepage = "https://github.com/cboxdoerfer/fsearch.git";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ artturin ];
    platforms = platforms.unix;
    mainProgram = "fsearch";
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/fsearch.x86_64-darwin
  };
}
