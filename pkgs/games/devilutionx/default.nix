{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, bzip2
, cmake
, pkg-config
, gettext
, libsodium
, SDL2
, SDL2_image
, SDL_audiolib
, flac
, fmt
, libpng
, smpq
}:

let
  # TODO: submit a PR upstream to allow system copies of these libraries where possible

  # fork with patches, far behind upstream
  asio = fetchurl {
    url = "https://github.com/diasurgical/asio/archive/bd1c839ef741b14365e77964bdd5a78994c05934.tar.gz";
    sha256 = "sha256-ePcdyvOfO5tyPVP+8t3+cS/XeEp47lfaE8gERRVoJSM=";
  };

  # fork with patches, upstream seems to be dead
  libmpq = fetchurl {
    url = "https://github.com/diasurgical/libmpq/archive/b78d66c6fee6a501cc9b95d8556a129c68841b05.tar.gz";
    sha256 = "sha256-NIzZwr6cBn38uKLWzW+Uet5QiOFUPB5dsf3FsS22ruo=";
  };

  # not "real" package with pkg-config or cmake file, just collection of source files
  libsmackerdec = fetchurl {
    url = "https://github.com/diasurgical/libsmackerdec/archive/91e732bb6953489077430572f43fc802bf2c75b2.tar.gz";
    sha256 = "sha256-5WXjfvGuT4hG2cnCS4YbxW/c4tek7OR95EjgCqkEi4c=";
  };

  # fork with patches, far behind upstream
  libzt = fetchFromGitHub {
    owner = "diasurgical";
    repo = "libzt";
    fetchSubmodules = true;
    rev = "d6c6a069a5041a3e89594c447ced3f15d77618b8";
    sha256 = "sha256-ttRJLfaGHzhS4jd8db7BNPWROCti3ZxuRouqsL/M5ew=";
  };

  # breaks without this version
  SDL_audiolib' = SDL_audiolib.overrideAttrs (oldAttrs: {
    src = fetchFromGitHub {
      owner = "realnc";
      repo = "SDL_audiolib";
      rev = "cc1bb6af8d4cf5e200259072bde1edd1c8c5137e";
      sha256 = "sha256-xP7qlwwOkqVeTlCEZLinnvmx8LbU2co5+t//cf4n190=";
    };

    buildInputs = oldAttrs.buildInputs ++ [ flac ];
  });

  # missing pkg-config and/or cmake file
  simpleini = fetchurl {
    url = "https://github.com/brofield/simpleini/archive/56499b5af5d2195c6acfc58c4630b70e0c9c4c21.tar.gz";
    sha256 = "sha256-29tQoz0+33kfwmIjCdnD1wGi+35+K0A9P6UE4E8K3g4=";
  };
in

stdenv.mkDerivation rec {
  pname = "devilutionx";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "diasurgical";
    repo = "devilutionX";
    rev = version;
    sha256 = "sha256-XILPpIYSC0+CbhyVXCNvAknAhqU7VW1dWZCh2BapQjs=";
  };

  postPatch = ''
    substituteInPlace 3rdParty/asio/CMakeLists.txt --replace-fail "${asio.url}" "${asio}"
    substituteInPlace 3rdParty/libmpq/CMakeLists.txt --replace-fail "${libmpq.url}" "${libmpq}"
    substituteInPlace 3rdParty/libsmackerdec/CMakeLists.txt --replace-fail "${libsmackerdec.url}" "${libsmackerdec}"
    substituteInPlace 3rdParty/libzt/CMakeLists.txt \
      --replace-fail "GIT_REPOSITORY https://github.com/diasurgical/libzt.git" "" \
      --replace-fail "GIT_TAG ${libzt.rev}" "SOURCE_DIR ${libzt}"
    substituteInPlace 3rdParty/simpleini/CMakeLists.txt --replace-fail "${simpleini.url}" "${simpleini}"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    gettext
    smpq # used to build devilutionx.mpq
  ];

  buildInputs = [
    bzip2
    fmt
    libpng
    libsodium
    SDL2
    SDL2_image
    SDL_audiolib'
  ];

  installPhase = ''
    runHook preInstall

  '' + (if stdenv.isDarwin then ''
    mkdir -p $out/Applications
    mv devilutionx.app $out/Applications
  '' else ''
    install -Dm755 -t $out/bin devilutionx
    install -Dm755 -t $out/bin devilutionx.mpq
    install -Dm755 -t $out/share/diasurgical/devilutionx devilutionx.mpq
    install -Dm755 -t $out/share/applications ../Packaging/nix/devilutionx-hellfire.desktop ../Packaging/nix/devilutionx.desktop
    install -Dm755 ../Packaging/resources/icon.png $out/share/icons/hicolor/512x512/apps/devilutionx.png
    install -Dm755 ../Packaging/resources/hellfire.png $out/share/icons/hicolor/512x512/apps/devilutionx-hellfire.png
    install -Dm755 ../Packaging/resources/icon_32.png $out/share/icons/hicolor/32x32/apps/devilutionx.png
    install -Dm755 ../Packaging/resources/hellfire_32.png $out/share/icons/hicolor/32x32/apps/devilutionx-hellfire.png
  '') + ''

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/diasurgical/devilutionX";
    description = "Diablo build for modern operating systems";
    mainProgram = "devilutionx";
    longDescription = "In order to play this game a copy of diabdat.mpq is required. Place a copy of diabdat.mpq in ~/.local/share/diasurgical/devilution before executing the game.";
    license = licenses.unlicense;
    maintainers = with maintainers; [ karolchmist aanderse ];
    platforms = platforms.linux ++ platforms.windows;
  };
}
