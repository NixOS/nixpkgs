{ fetchFromGitHub, lib, stdenv, cmake, pkg-config, python3, alsa-lib
, libX11, libGLU, SDL2, lua5_3, zlib, freetype, wavpack, icoutils
, nixosTests
, Carbon
, Cocoa
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
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optionals stdenv.isLinux [
    icoutils
  ];

  buildInputs = [
    python3 libGLU SDL2 lua5_3 zlib freetype wavpack
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
    libX11
  ] ++ lib.optionals stdenv.isDarwin [
    Carbon
    Cocoa
  ];

  postInstall = lib.optionalString stdenv.isLinux ''
    # Convert and install desktop icon
    mkdir -p $out/share/pixmaps
    icotool --extract --index 1 --output $out/share/pixmaps/teeworlds.png $src/other/icons/teeworlds.ico

    # Install menu item
    install -D $src/other/teeworlds.desktop $out/share/applications/teeworlds.desktop
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p "$out/Applications/teeworlds.app/Contents/MacOS"
    mkdir -p "$out/Applications/teeworlds.app/Contents/Resources"

    cp '../other/icons/teeworlds.icns' "$out/Applications/teeworlds.app/Contents/Resources/"
    cp '../other/bundle/client/Info.plist.in' "$out/Applications/teeworlds.app/Contents/Info.plist"
    cp '../other/bundle/client/PkgInfo' "$out/Applications/teeworlds.app/Contents/"
    ln -s "$out/bin/teeworlds" "$out/Applications/teeworlds.app/Contents/MacOS/"
    ln -s "$out/share/teeworlds/data" "$out/Applications/teeworlds.app/Contents/Resources/data"
  '';

  passthru.tests.teeworlds = nixosTests.teeworlds;

  meta = {
    description = "Retro multiplayer shooter game";

    longDescription = ''
      Teeworlds is a free online multiplayer game, available for all
      major operating systems.  Battle with up to 12 players in a
      variety of game modes, including Team Deathmatch and Capture The
      Flag.  You can even design your own maps!
    '';

    homepage = "https://teeworlds.com/";
    license = "BSD-style, see `license.txt'";
    maintainers = with lib.maintainers; [ astsmtl Luflosi ];
    platforms = lib.platforms.unix;
  };
}
