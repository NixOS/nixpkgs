{
  stdenv,
  lib,
  fetchurl,
  writeShellScript,
  SDL,
  SDL_mixer,
  makeDesktopItem,
  copyDesktopItems,
  runtimeShell,
  buildShareware ? false,
}:

let
  # Allow the game to be launched from a user's PATH and load the game data from the user's home directory.
  launcher = writeShellScript "rott" ''
    set -eEuo pipefail
    dir=$HOME/.rott/data
    test -e $dir || mkdir -p $dir
    cd $dir
    exec @out@/libexec/rott "$@"
  '';

in
stdenv.mkDerivation rec {
  pname = "rott";
  version = "1.1.2";

  src = fetchurl {
    url = "https://icculus.org/rott/releases/${pname}-${version}.tar.gz";
    sha256 = "1zr7v5dv2iqx40gzxbg8mhac7fxz3kqf28y6ysxv1xhjqgl1c98h";
  };

  nativeBuildInputs = [ copyDesktopItems ];

  buildInputs = [
    SDL
    SDL_mixer
  ];

  sourceRoot = "rott-${version}/rott";

  makeFlags = [
    "SHAREWARE=${if buildShareware then "1" else "0"}"
  ];

  # when using SDL_compat instead of SDL_classic, SDL_mixer isn't correctly
  # detected, but there is no harm just specifying it
  env.NIX_CFLAGS_COMPILE = toString [
    "-I${lib.getDev SDL_mixer}/include/SDL"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/libexec rott
    install -Dm555 ${launcher} $out/bin/${launcher.name}
    substituteInPlace $out/bin/rott --subst-var out

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "rott";
      exec = "rott";
      desktopName = "Rise of the Triad: ${if buildShareware then "The HUNT Begins" else "Dark War"}";
      categories = [ "Game" ];
    })
  ];

  meta = with lib; {
    description = "SDL port of Rise of the Triad";
    mainProgram = "rott";
    homepage = "https://icculus.org/rott/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sander ];
    platforms = platforms.all;
  };
}
