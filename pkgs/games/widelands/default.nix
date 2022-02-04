{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, SDL2
, SDL2_image
, SDL2_mixer
, SDL2_net
, SDL2_ttf
, boost
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
}:

stdenv.mkDerivation rec {
  pname = "widelands";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "widelands";
    repo = "widelands";
    rev = "v${version}";
    sha256 = "sha256-gNumYoeKePaxiAzrqEPKibMxFwv9vyBrCSoua+MKhcM=";
  };

  patches = [
    ./bincmake.patch
    # fix for building with Boost 1.77, https://github.com/widelands/widelands/pull/5025
    (fetchpatch {
      url = "https://github.com/widelands/widelands/commit/33981fda8c319c9feafc958f5f0b1670c48666ef.patch";
      sha256 = "sha256-FjxxCTPpg/Zp01XpNfgRXMMLJBfxAptkLpsLmnFXm2Q=";
    })
  ];

  postPatch = ''
    substituteInPlace xdg/org.widelands.Widelands.desktop \
      --replace 'Exec=widelands' "Exec=$out/bin/widelands"
  '';

  cmakeFlags = [
    "-Wno-dev" # dev warnings are only needed for upstream development
    "-DWL_INSTALL_BASEDIR=${placeholder "out"}"
    "-DWL_INSTALL_DATADIR=${placeholder "out"}/share/widelands"
    "-DWL_INSTALL_BINARY=${placeholder "out"}/bin"
  ];

  nativeBuildInputs = [ cmake doxygen gettext graphviz installShellFiles ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_net
    SDL2_ttf
    boost
    curl
    glew
    icu
    libpng
    lua
    python3
    zlib
  ];

  postInstall = ''
    install -Dm444 -t $out/share/applications ../xdg/org.widelands.Widelands.desktop

    for s in 16 32 48 64 128; do
      install -Dm444 ../data/images/logos/wl-ico-''${s}.png $out/share/icons/hicolor/''${s}x''${s}/org.widelands.Widelands.png
    done

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
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin jcumming ];
    platforms = platforms.linux;
    hydraPlatforms = [ ];
  };
}
