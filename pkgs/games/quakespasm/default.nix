{
  lib,
  stdenv,
  SDL,
  SDL2,
  fetchurl,
  gzip,
  libGL,
  libGLU,
  libvorbis,
  libmad,
  flac,
  libopus,
  opusfile,
  libogg,
  libxmp,
  copyDesktopItems,
  makeDesktopItem,
  pkg-config,
  useSDL2 ? stdenv.hostPlatform.isDarwin, # TODO: CoreAudio fails to initialize with SDL 1.x for some reason.
}:

stdenv.mkDerivation rec {
  pname = "quakespasm";
  version = "0.96.3";

  src = fetchurl {
    url = "mirror://sourceforge/quakespasm/quakespasm-${version}.tar.gz";
    sha256 = "sha256-tXjWzkpPf04mokRY8YxLzI04VK5iUuuZgu6B2V5QGA4=";
  };

  sourceRoot = "${pname}-${version}/Quake";

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    # Makes Darwin Makefile use system libraries instead of ones from app bundle
    ./quakespasm-darwin-makefile-improvements.patch
  ];

  # Quakespasm tries to set a 10.6 deployment target, but that’s too low for SDL2.
  postPatch = ''
    sed -i Makefile.darwin -e '/-mmacosx-version-min/d'
  '';

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
  ];

  buildInputs = [
    gzip
    libGL
    libGLU
    libvorbis
    libmad
    flac
    libopus
    opusfile
    libogg
    libxmp
    (if useSDL2 then SDL2 else SDL)
  ];

  buildFlags = [
    "DO_USERDIRS=1"
    # Makefile defaults, set here to enforce consistency on Darwin build
    "USE_CODEC_WAVE=1"
    "USE_CODEC_MP3=1"
    "USE_CODEC_VORBIS=1"
    "USE_CODEC_FLAC=1"
    "USE_CODEC_OPUS=1"
    "USE_CODEC_MIKMOD=0"
    "USE_CODEC_UMX=0"
    "USE_CODEC_XMP=1"
    "MP3LIB=mad"
    "VORBISLIB=vorbis"
  ]
  ++ lib.optionals useSDL2 [
    "SDL_CONFIG=sdl2-config"
    "USE_SDL2=1"
  ];

  makefile = if (stdenv.hostPlatform.isDarwin) then "Makefile.darwin" else "Makefile";

  preInstall = ''
    mkdir -p "$out/bin"
    substituteInPlace Makefile --replace "/usr/local/games" "$out/bin"
    substituteInPlace Makefile.darwin --replace "/usr/local/games" "$out/bin"
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Let's build app bundle
    mkdir -p $out/Applications/Quake.app/Contents/MacOS
    mkdir -p $out/Applications/Quake.app/Contents/Resources
    cp ../MacOSX/Info.plist $out/Applications/Quake.app/Contents/
    cp ../MacOSX/QuakeSpasm.icns $out/Applications/Quake.app/Contents/Resources/
    cp -r ../MacOSX/English.lproj $out/Applications/Quake.app/Contents/Resources/
    ln -sf $out/bin/quake $out/Applications/Quake.app/Contents/MacOS/quake

    substituteInPlace $out/Applications/Quake.app/Contents/Info.plist \
      --replace '>''${EXECUTABLE_NAME}' '>quake'
    substituteInPlace $out/Applications/Quake.app/Contents/Info.plist \
      --replace '>''${PRODUCT_NAME}' '>QuakeSpasm'
  '';

  enableParallelBuilding = true;

  desktopItems = [
    (makeDesktopItem {
      name = "quakespasm";
      exec = "quake";
      desktopName = "Quakespasm";
      categories = [ "Game" ];
    })
  ];

  meta = with lib; {
    description = "Engine for iD software's Quake";
    homepage = "https://quakespasm.sourceforge.net/";
    longDescription = ''
      QuakeSpasm is a modern, cross-platform Quake 1 engine based on FitzQuake.
      It includes support for 64 bit CPUs and custom music playback, a new sound driver,
      some graphical niceities, and numerous bug-fixes and other improvements.
      Quakespasm utilizes either the SDL or SDL2 frameworks, so choose which one
      works best for you. SDL is probably less buggy, but SDL2 has nicer features
      and smoother mouse input - though no CD support.
    '';

    platforms = platforms.unix;
    maintainers = with maintainers; [ mikroskeem ];
    mainProgram = "quake";
  };
}
