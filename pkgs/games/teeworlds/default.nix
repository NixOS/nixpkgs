{ fetchFromGitHub, stdenv, cmake, pkgconfig, python3, alsaLib
, libX11, libGLU, SDL2, lua5_3, zlib, freetype, wavpack, icoutils
, nixosTests
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

  postPatch = ''
    # set compiled-in DATA_DIR so resources can be found
    substituteInPlace src/engine/shared/storage.cpp \
      --replace '#define DATA_DIR "data"' \
                '#define DATA_DIR "${placeholder "out"}/share/teeworlds/data"'
  '';

  nativeBuildInputs = [ cmake pkgconfig icoutils ];

  buildInputs = [
    python3 alsaLib libX11 libGLU SDL2 lua5_3 zlib freetype wavpack
  ];

  postInstall = ''
    # Convert and install desktop icon
    mkdir -p $out/share/pixmaps
    icotool --extract --index 1 --output $out/share/pixmaps/teeworlds.png $src/other/icons/teeworlds.ico

    # Install menu item
    install -D $src/other/teeworlds.desktop $out/share/applications/teeworlds.desktop
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
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = stdenv.lib.platforms.linux;
  };
}
