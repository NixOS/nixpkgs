{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, fetchurl
, fetchzip
, cmake
, pkg-config
, gettext
, SDL2
, SDL2_image
, fmt
, libpng
, smpq
}:

let
  # TODO: submit a PR upstream to allow system copies of these libraries where possible
  asio = fetchurl {
    url = "https://github.com/diasurgical/asio/archive/ebeff99f539da23d27c2e8d4bdbc1ee011968644.tar.gz";
    sha256 = "0vhb4cig40mm0a98i74grpmfkcmby8zxg6vqa38dpryxpgvp5fw8";
  };

  SDL_audiolib = fetchurl {
    url = "https://github.com/realnc/SDL_audiolib/archive/aa79660eba4467a44f9dcaecf26b0f0a000abfd7.tar.gz";
    sha256 = "0z4rizncp6gqsy72b3709zc9fr915wgcwnlx1fhhy7mrczsly630";
  };

  simpleini = fetchzip {
    url = "https://github.com/brofield/simpleini/archive/7bca74f6535a37846162383e52071f380c99a43a.zip";
    sha256 = "07kf1jjbc9v04hsysa6v2wh1m9csf5qz0b1wmlkf9sj00kf47zj7";
  };
in

stdenv.mkDerivation rec {
  pname = "devilutionx";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "diasurgical";
    repo = "devilutionX";
    rev = version;
    sha256 = "0acrkqi0pr3cbr5i1a1vfrnxv1n3xmql5d86bm2gywvpdb94xads";
  };

  patches = [
    # allow building with system SDL2_image instead of vendored version
    # this patch can be removed on the next release of devilutionx
    # see https://github.com/diasurgical/devilutionX/pull/3386
    (fetchpatch {
      url = "https://github.com/diasurgical/devilutionX/commit/41ff03e94c02477bffb2d62764e8624c0e06854d.patch";
      sha256 = "1lrnb9d0dcdyd78rix5rl4p8kkwbnl91llr9fgb86ysm3q58qkvj";
    })
  ];

  postPatch = ''
    substituteInPlace Source/init.cpp --replace "/usr/share/diasurgical/devilutionx/" "${placeholder "out"}/share/diasurgical/devilutionx/"

    # download dependencies ahead of time
    substituteInPlace 3rdParty/asio/CMakeLists.txt --replace "https://github.com/diasurgical/asio/archive/ebeff99f539da23d27c2e8d4bdbc1ee011968644.tar.gz" "${asio}"
    substituteInPlace 3rdParty/SDL_audiolib/CMakeLists.txt --replace "https://github.com/realnc/SDL_audiolib/archive/aa79660eba4467a44f9dcaecf26b0f0a000abfd7.tar.gz" "${SDL_audiolib}"
    substituteInPlace 3rdParty/simpleini/CMakeLists.txt --replace "https://github.com/brofield/simpleini/archive/7bca74f6535a37846162383e52071f380c99a43a.zip" "${simpleini}"
  '';

  cmakeFlags = [
    "-DBINARY_RELEASE=ON"
    "-DVERSION_NUM=${version}"
    "-DPACKET_ENCRYPTION=OFF" # FIXME: build with libsodium
    "-DDISABLE_ZERO_TIER=ON" # FIXME: build with libzt
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    gettext
    smpq # used to build devilutionx.mpq
  ];

  buildInputs = [
    fmt
    libpng
    SDL2
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
