{ fetchFromGitHub, fetchpatch, lib, stdenv, cmake, pkg-config, python3, alsa-lib
, libX11, libGLU, SDL2, lua5_3, zlib, freetype, wavpack, icoutils
, nixosTests
, Cocoa
, buildClient ? true
}:

stdenv.mkDerivation rec {
  pname = "teeworlds";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "teeworlds";
    repo = "teeworlds";
    rev = version;
    sha256 = "1l19ksmimg6b8zzjy0skyhh7z11ql7n5gvilkv7ay5x2b9ndbqwz";
    fetchSubmodules = true;
  };

  patches = [
    # Can't use fetchpatch or fetchpatch2 because of https://github.com/NixOS/nixpkgs/issues/32084
    # Using fetchurl instead is also not a good idea, see https://github.com/NixOS/nixpkgs/issues/32084#issuecomment-727223713
    ./rename-VERSION-to-VERSION.txt.patch
    (fetchpatch {
      name = "CVE-2021-43518.patch";
      url = "https://salsa.debian.org/games-team/teeworlds/-/raw/a6c4b23c1ce73466e6d89bccbede70e61e8c9cba/debian/patches/CVE-2021-43518.patch";
      hash = "sha256-2MmsucaaYjqLgMww1492gNmHmvBJm/NED+VV5pZDnBY=";
    })
  ];

  postPatch = ''
    # set compiled-in DATA_DIR so resources can be found
    substituteInPlace src/engine/shared/storage.cpp \
      --replace '#define DATA_DIR "data"' \
                '#define DATA_DIR "${placeholder "out"}/share/teeworlds/data"'

    # Quote nonsense is a workaround for https://github.com/NixOS/nix/issues/661
    substituteInPlace 'other/bundle/client/Info.plist.in' \
      --replace ${"'"}''${TARGET_CLIENT}' 'teeworlds' \
      --replace ${"'"}''${PROJECT_VERSION}' '${version}'

    # Make sure some bundled dependencies are actually unbundled.
    # This will fail compilation if one of these dependencies could not
    # be found, instead of falling back to the bundled version.
    rm -rf 'src/engine/external/wavpack/'
    rm -rf 'src/engine/external/zlib/'
    # md5, pnglite and json-parser (https://github.com/udp/json-parser)
    # don't seem to be packaged in Nixpkgs, so don't unbundle them.
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optionals (buildClient && stdenv.hostPlatform.isLinux) [
    icoutils
  ];

  buildInputs = [
    python3 lua5_3 zlib
    wavpack
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Cocoa
  ] ++ lib.optionals buildClient ([
    SDL2
    freetype
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGLU
    alsa-lib
    libX11
  ]);

  cmakeFlags = [
    "-DCLIENT=${if buildClient then "ON" else "OFF"}"
  ];

  postInstall = lib.optionalString buildClient (lib.optionalString stdenv.hostPlatform.isLinux ''
    # Convert and install desktop icon
    mkdir -p $out/share/pixmaps
    icotool --extract --index 1 --output $out/share/pixmaps/teeworlds.png $src/other/icons/teeworlds.ico

    # Install menu item
    install -D $src/other/teeworlds.desktop $out/share/applications/teeworlds.desktop
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications/teeworlds.app/Contents/MacOS"
    mkdir -p "$out/Applications/teeworlds.app/Contents/Resources"

    cp '../other/icons/teeworlds.icns' "$out/Applications/teeworlds.app/Contents/Resources/"
    cp '../other/bundle/client/Info.plist.in' "$out/Applications/teeworlds.app/Contents/Info.plist"
    cp '../other/bundle/client/PkgInfo' "$out/Applications/teeworlds.app/Contents/"
    ln -s "$out/bin/teeworlds" "$out/Applications/teeworlds.app/Contents/MacOS/"
    ln -s "$out/share/teeworlds/data" "$out/Applications/teeworlds.app/Contents/Resources/data"
  '');

  passthru.tests.teeworlds = nixosTests.teeworlds;

  meta = {
    description = "Retro multiplayer shooter game";
    mainProgram = "teeworlds_srv";

    longDescription = ''
      Teeworlds is a free online multiplayer game, available for all
      major operating systems.  Battle with up to 12 players in a
      variety of game modes, including Team Deathmatch and Capture The
      Flag.  You can even design your own maps!
    '';

    homepage = "https://teeworlds.com/";
    license = with lib.licenses; [
      # See https://github.com/teeworlds/teeworlds/blob/master/license.txt
      lib.licenses.zlib # Main license
      cc-by-sa-30 # All content under 'datasrc' except the fonts
      ofl  # datasrc/fonts/SourceHanSans.ttc
      free # datasrc/fonts/DejaVuSans.ttf
      bsd2 # src/engine/external/json-parser/
      bsd3 # src/engine/external/wavpack
      # zlib src/engine/external/md5/
      # zlib src/engine/external/pnglite/
      # zlib src/engine/external/zlib/
    ];
    maintainers = with lib.maintainers; [ astsmtl Luflosi ];
    platforms = lib.platforms.unix;
  };
}
