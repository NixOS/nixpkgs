{ stdenv
, lib
, fetchFromGitHub
, fetchurl
, cmake
, makeWrapper
, copyDesktopItems
, makeDesktopItem
, physfs
, SDL2
, SDL2_mixer
, tinyxml-2
, utf8cpp
, Foundation
, IOKit
, makeAndPlay ? false
}:

stdenv.mkDerivation rec {
  pname = "vvvvvv";
  version = "2.3.6";

  src = fetchFromGitHub {
    owner = "TerryCavanagh";
    repo = "VVVVVV";
    rev = version;
    sha256 = "sha256-sLNO4vkmlirsqJmCV9YWpyNnIiigU1KMls7rOgWgSmQ=";
  };
  sourceRoot = "source/desktop_version";
  dataZip = fetchurl {
    url = "https://thelettervsixtim.es/makeandplay/data.zip";
    name = "data.zip";
    sha256 = "sha256-x2eAlZT2Ry2p9WE252ZX44ZA1YQWSkYRIlCsYpPswOo=";
    meta.license = lib.licenses.unfree;
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    physfs
    SDL2
    SDL2_mixer
    tinyxml-2
    utf8cpp
  ] ++ lib.optionals stdenv.isDarwin [ Foundation IOKit ];

  # Help CMake find SDL_mixer.h
  NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL2_mixer}/include/SDL2";

  cmakeFlags = [ "-DBUNDLE_DEPENDENCIES=OFF" ] ++ lib.optional makeAndPlay "-DMAKEANDPLAY=ON";

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "VVVVVV";
      desktopName = "VVVVVV";
      comment = meta.description;
      exec = pname;
      icon = "VVVVVV";
      terminal = false;
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 VVVVVV $out/bin/${pname}
    install -Dm644 "$src/desktop_version/icon.ico" "$out/share/pixmaps/VVVVVV.png"

    wrapProgram $out/bin/${pname} --add-flags "-assets ${dataZip}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A retro-styled platform game" + lib.optionalString makeAndPlay " (redistributable, without original levels)";
    longDescription = ''
      VVVVVV is a platform game all about exploring one simple mechanical
      idea - what if you reversed gravity instead of jumping?
    '' + lib.optionalString makeAndPlay ''
      (Redistributable version, doesn't include the original levels.)
    '';
    homepage = "https://thelettervsixtim.es";
    license = licenses.unfree;
    maintainers = with maintainers; [ martfont ];
    platforms = platforms.unix;
  };
}
