{ lib
, stdenv
, fetchFromGitHub
, gtk3
, pcre2
, glib
, desktop-file-utils
, meson
, ninja
, pkg-config
, wrapGAppsHook
, gettext
, icu
}:

stdenv.mkDerivation rec {
  pname = "fsearch";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "cboxdoerfer";
    repo = pname;
    rev = version;
    hash = "sha256-VBcoDxh4ip2zLBcXVHDe9s1lVRQF4bZJKsGUt6sPcos=";
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
    pcre2
    icu
  ];

  preFixup = ''
    substituteInPlace $out/share/applications/io.github.cboxdoerfer.FSearch.desktop \
      --replace "Exec=fsearch" "Exec=$out/bin/fsearch"
  '';

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
