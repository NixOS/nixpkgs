{ lib
, stdenv
, fetchFromGitHub
, pkg-config # needed to find minizip
, SDL2
, SDL2_image
, SDL2_mixer
, SDL2_net
, SDL2_ttf
, cmake
, curl
, doxygen
, gettext
, glew
, graphviz
, icu
, installShellFiles
, libpng
, lua
, python3
, zlib
, minizip
, asio
, libSM
, libICE
, libXext
, darwin
}:

stdenv.mkDerivation rec {
  pname = "widelands";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "widelands";
    repo = "widelands";
    rev = "v${version}";
    sha256 = "sha256-V7eappIMEQMNbf9EGQhv71Fwz0wH679ifi/qAHWwMNU=";
  };

  postPatch = ''
    substituteInPlace xdg/org.widelands.Widelands.desktop \
      --replace 'Exec=widelands' "Exec=$out/bin/widelands"
  '';

  cmakeFlags = [
    "-Wno-dev" # dev warnings are only needed for upstream development
    "-DCMAKE_BUILD_TYPE=Release"
    "-DWL_INSTALL_BASEDIR=${placeholder "out"}/share/widelands" # for COPYING, Changelog, etc.
    "-DWL_INSTALL_DATADIR=${placeholder "out"}/share/widelands" # for game data
    "-DWL_INSTALL_BINDIR=${placeholder "out"}/bin"
  ];

  nativeBuildInputs = [ cmake doxygen gettext graphviz installShellFiles pkg-config ];

  enableParallelBuilding = true;

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_net
    SDL2_ttf
    curl
    glew
    icu
    libpng
    lua
    python3
    zlib
    minizip
    asio
    libSM  # XXX: these should be propagated by SDL2?
    libICE
  ]
  ++ lib.optional stdenv.isLinux libXext
  ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Cocoa
  ]);

  postInstall = lib.optionalString stdenv.isLinux ''
    install -Dm444 -t $out/share/applications ../xdg/org.widelands.Widelands.desktop

    for s in 16 32 48 64 128; do
      install -Dm444 ../data/images/logos/wl-ico-''${s}.png $out/share/icons/hicolor/''${s}x''${s}/org.widelands.Widelands.png
    done
  '' + ''
    installManPage ../xdg/widelands.6
  '';

  meta = with lib; {
    description = "RTS with multiple-goods economy";
    homepage = "https://widelands.org/";
    longDescription = ''
      Widelands is a real time strategy game based on "The Settlers" and "The
      Settlers II". It has a single player campaign mode, as well as a networked
      multiplayer mode.
    '';
    changelog = "https://github.com/widelands/widelands/releases/tag/v${version}";
    mainProgram = "widelands";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin jcumming ];
    platforms = platforms.linux ++ platforms.darwin;
    hydraPlatforms = [ ];
  };
}
