{ lib
, stdenv
, fetchFromGitHub
, ensureNewerSourcesForZipFilesHook
, python3
, pkg-config
, wafHook
, SDL2
, libopus
, freetype
, fontconfig
, gamedir ? "valve"
, enableGl ? true # opengl renderer
# the features below were not tested
, dedicated ? false # dedicated server
, enableBsp2 ? false # bsp2 support (for quake)
, enableGles1 ? false # gles1 renderer (nanogl)
, enableGles2 ? false # gles2 renderer (glwes)
, enableGl4es ? false # gles2 renderer (gl4es)
, enableSoft ? false # soft renderer
, enableUtils ? false # mdldec
}:

stdenv.mkDerivation {
  pname = "xash3d-unwrapped";
  version = "unstable-2023-07-02";

  src = fetchFromGitHub {
    owner = "FWGS";
    repo = "xash3d-fwgs";
    rev = "5e878aae89ab1517eeeb259191bd6f2f88a6eccb";
    fetchSubmodules = true;
    sha256 = "IrKWF7TYL9QV5UCHjm1rxZ4ZGT+Hmoq0nOj+X+GoiPQ=";
  };

  nativeBuildInputs = [
    ensureNewerSourcesForZipFilesHook
    python3
    pkg-config
    wafHook
  ];

  buildInputs = [
    SDL2
    libopus
    freetype
    fontconfig
  ];

  wafConfigureFlags = [ "--enable-packaging" "--build-type=release" ]
    ++ lib.optional dedicated "-d"
    ++ lib.optionals (gamedir != "valve") [ "--gamedir" gamedir ]
    ++ lib.optional enableBsp2 "--enable-bsp2"
    ++ lib.optional enableGles1 "--enable-gles1"
    ++ lib.optional enableGles2 "--enable-gles2"
    ++ lib.optional enableGl4es "--enable-gl4es"
    ++ lib.optional (!enableGl) "--disable-gl"
    ++ lib.optional (!enableSoft) "--disable-soft"
    ++ lib.optional enableUtils "--enable-utils"
    ++ lib.optional stdenv.is64bit "-8"
  ;

  wafInstallFlags = [ "--destdir=/" ];

  postInstall = ''
    install -Dm644 game_launch/icon-xash-material.png $out/share/icons/hicolor/256x256/apps/xash3d.png
  '';

  meta = with lib; {
    description = "A reimplementation of the GoldSrc Engine capable of running Half-Life and more";
    homepage = "https://github.com/FWGS/xash3d-fwgs";
    # https://github.com/FWGS/xash3d-fwgs/issues/63
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ TheBrainScrambler ];
    platforms = platforms.linux;
    mainProgram = "xash3d";
  };
}
