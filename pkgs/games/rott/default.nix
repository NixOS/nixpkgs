{stdenv, lib, fetchurl, SDL, SDL_mixer, makeDesktopItem, copyDesktopItems, runtimeShell, buildShareware ? false}:

stdenv.mkDerivation rec {
  pname = "rott";
  version = "1.1.2";

  src = fetchurl {
    url = "https://icculus.org/rott/releases/${pname}-${version}.tar.gz";
    sha256 = "1zr7v5dv2iqx40gzxbg8mhac7fxz3kqf28y6ysxv1xhjqgl1c98h";
  };

  nativeBuildInputs = [ copyDesktopItems ];
  buildInputs = [ SDL SDL_mixer ];

  preBuild = ''
    cd rott
    make clean
    make SHAREWARE=${if buildShareware then "1" else "0"}
  '';

  # Include a wrapper script to allow the game to be launched from a user's PATH and load the game data from the user's home directory.

  installPhase = ''
    mkdir -p $out/bin
    cp rott $out/bin

    cat > $out/bin/launch-rott <<EOF
    #! ${runtimeShell} -e
    cd ~/.rott/data
    exec $out/bin/rott
    EOF

    chmod +x $out/bin/launch-rott

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "rott";
      exec = "launch-rott";
      desktopName = "Rise of the Triad: ${if buildShareware then "The HUNT Begins" else "Dark War"}";
      categories = [ "Game" ];
    })
  ];

  meta = with lib; {
    description = "SDL port of Rise of the Triad";
    homepage = "https://icculus.org/rott/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sander ];
    platforms = platforms.all;
  };
}
