{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, fetchurl
, bzip2
, cmake
, pkg-config
, gettext
, libsodium
, SDL2
, SDL_audiolib
, SDL2_image
, fmt
, libpng
, smpq
}:

let
  # TODO: submit a PR upstream to allow system copies of these libraries where possible

  # fork with patches, far behind upstream
  asio = fetchurl {
    url = "https://github.com/diasurgical/asio/archive/ebeff99f539da23d27c2e8d4bdbc1ee011968644.tar.gz";
    sha256 = "0vhb4cig40mm0a98i74grpmfkcmby8zxg6vqa38dpryxpgvp5fw8";
  };

  # fork with patches, upstream seems to be dead
  libmpq = fetchurl {
    url = "https://github.com/diasurgical/libmpq/archive/0f10bd1600f406b13932bf5351ba713361262184.tar.gz";
    sha256 = "sha256-7hc/Xtsg8WJIJljLydS7hLZA9lEEHWhsCteyrxK68qE=";
  };

  # not "real" package with pkg-config or cmake file, just collection of source files
  libsmackerdec = fetchurl {
    url = "https://github.com/diasurgical/libsmackerdec/archive/2997ee0e41e91bb723003bc09234be553b190e38.tar.gz";
    sha256 = "sha256-QMDcIZQ94i4VPVanmSxiGkKgxWx82DP4uE+Q5I2nU+o=";
  };

  # fork with patches, far behind upstream
  libzt = fetchFromGitHub {
    owner = "diasurgical";
    repo = "libzt";
    fetchSubmodules = true;
    rev = "a34ba7f1cc2e41b05badd25d1b01fdc5fd2f4e02";
    sha256 = "sha256-tyIPt+7OTi5W+5X/ixQP1puOKdhrqRZtpwXlWFBFpc8=";
  };

  # missing pkg-config and/or cmake file
  simpleini = fetchurl {
    url = "https://github.com/brofield/simpleini/archive/9b3ed7ec815997bc8c5b9edf140d6bde653e1458.tar.gz";
    sha256 = "sha256-93kuyp8/ew7okW/6ThJMtLMZsR1YSeFcXu9Y65ELBFE==";
  };
in

stdenv.mkDerivation rec {
  pname = "devilutionx";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "diasurgical";
    repo = "devilutionX";
    rev = version;
    sha256 = "sha256-uuIPTdgGpHA8j1M8b+kfnBuiJ5mdS9rckvEfn2h7lmo=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/diasurgical/devilutionX/commit/03b22352fc9e1ecb88b20a053c90c04a50717267.patch";
      sha256 = "sha256-5aAwi1NV8P+nLLbEEnlwLGNQCQBb0nQkIVe5tR5Shsw=";
    })
  ];

  postPatch = ''
    substituteInPlace Source/init.cpp --replace "/usr/share/diasurgical/devilutionx/" "${placeholder "out"}/share/diasurgical/devilutionx/"

    # download dependencies ahead of time
    substituteInPlace 3rdParty/asio/CMakeLists.txt --replace "${asio.url}" "${asio}"
    substituteInPlace 3rdParty/libmpq/CMakeLists.txt --replace "${libmpq.url}" "${libmpq}"
    substituteInPlace 3rdParty/libsmackerdec/CMakeLists.txt --replace "${libsmackerdec.url}" "${libsmackerdec}"
    substituteInPlace 3rdParty/libzt/CMakeLists.txt \
      --replace "GIT_REPOSITORY https://github.com/diasurgical/libzt.git" "" \
      --replace "GIT_TAG ${libzt.rev}" "SOURCE_DIR ${libzt}"
    substituteInPlace 3rdParty/simpleini/CMakeLists.txt --replace "${simpleini.url}" "${simpleini}"
  '';

  cmakeFlags = [
    "-DBINARY_RELEASE=ON"
    "-DVERSION_NUM=${version}"
  ];

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
    SDL_audiolib
    SDL2_image
  ];

  installPhase = ''
    runHook preInstall

  '' + (if stdenv.isDarwin then ''
    mkdir -p $out/Applications
    mv devilutionx.app $out/Applications
  '' else ''
    install -Dm755 -t $out/bin devilutionx
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
    longDescription = "In order to play this game a copy of diabdat.mpq is required. Place a copy of diabdat.mpq in ~/.local/share/diasurgical/devilution before executing the game.";
    license = licenses.unlicense;
    maintainers = with maintainers; [ karolchmist aanderse ];
    platforms = platforms.linux ++ platforms.windows;
  };
}
