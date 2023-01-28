{ lib
, stdenv
, fetchFromGitHub
, dos2unix
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, SDL2
, libGL
, curl
, openal
, liberation_ttf
}:

stdenv.mkDerivation rec {
  pname = "ClassiCube";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "UnknownShadow200";
    repo = "ClassiCube";
    rev = version;
    sha256 = "sha256-m7pg9OL2RuCVKgFD3hMtIeY0XdJ1YviXBFVJH8/T5gI=";
  };

  nativeBuildInputs = [ dos2unix makeWrapper copyDesktopItems ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = pname;
      genericName = "Sandbox Block Game";
      exec = "ClassiCube";
      icon = "CCicon";
      comment = "Minecraft Classic inspired sandbox game";
      categories = [ "Game" ];
    })
  ];

  prePatch = ''
    # The ClassiCube sources have DOS-style newlines
    # which causes problems with diff/patch.
    dos2unix 'src/Platform_Posix.c' 'src/Core.h'
  '';

  patches = [
    # Fix hardcoded font paths
    ./font-location.patch
    # ClassiCube doesn't compile with its X11 backend
    # because of issues with libXi.
    ./use-sdl.patch
    # For some reason, the Makefile doesn't link
    # with libcurl and openal when ClassiCube requires them.
    # Also links with SDL2 instead of libX11 and libXi.
    ./fix-linking.patch
  ];

  font_path = "${liberation_ttf}/share/fonts/truetype";

  enableParallelBuilding = true;

  postPatch = ''
    # ClassiCube hardcodes locations of fonts.
    # This changes the hardcoded location
    # to the path of liberation_ttf instead
    substituteInPlace src/Platform_Posix.c \
      --replace '%NIXPKGS_FONT_PATH%' "${font_path}"
    # ClassiCube's Makefile hardcodes JOBS=1 for some reason,
    # even though it works perfectly well multi-threaded.
    substituteInPlace src/Makefile \
      --replace 'JOBS=1' "JOBS=$NIX_BUILD_CORES"
  '';

  buildInputs = [ SDL2 libGL curl openal liberation_ttf ];

  preBuild = "cd src";

  postBuild = "cd -";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp 'src/ClassiCube' "$out/bin"
    # ClassiCube puts downloaded resources
    # next to the location of the executable by default.
    # This doesn't work with Nix
    # as the location of the executable is read-only.
    # We wrap the program to make it put its resources
    # in ~/.local/share instead.
    wrapProgram "$out/bin/ClassiCube" \
      --run 'mkdir -p "$HOME/.local/share/ClassiCube"' \
      --run 'cd       "$HOME/.local/share/ClassiCube"'

    mkdir -p "$out/share/icons/hicolor/256x256/apps"
    cp misc/CCicon.png "$out/share/icons/hicolor/256x256/apps"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.classicube.net/";
    description = "A lightweight, custom Minecraft Classic/ClassiCube client with optional additions written from scratch in C";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ _360ied ];
  };
}
