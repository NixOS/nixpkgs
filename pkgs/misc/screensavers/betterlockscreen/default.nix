{ fetchFromGitHub
, lib
, makeWrapper
, stdenv

  # Dependencies (@see https://github.com/pavanjadhaw/betterlockscreen/blob/master/shell.nix)
, bc
, coreutils
, dbus
<<<<<<< HEAD
, withDunst ? true
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, dunst
, i3lock-color
, gawk
, gnugrep
, gnused
, imagemagick
, procps
, xorg
}:

<<<<<<< HEAD
let
  runtimeDeps =
    [ bc coreutils dbus i3lock-color gawk gnugrep gnused imagemagick procps xorg.xdpyinfo xorg.xrandr xorg.xset ]
    ++ lib.optionals withDunst [ dunst ];
in

stdenv.mkDerivation rec {
  pname = "betterlockscreen";
  version = "4.2.0";
=======
stdenv.mkDerivation rec {
  pname = "betterlockscreen";
  version = "4.0.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pavanjadhaw";
    repo = "betterlockscreen";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-e/NyUxrN18+x2zt+JzqVA00P8VdHo8oj9Bx09XKI+Eg=";
=======
    sha256 = "sha256-ZZnwByxfESE8ZOOh1vnbphUHDolo9MIQh3erjtBLmWQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp betterlockscreen $out/bin/betterlockscreen
    wrapProgram "$out/bin/betterlockscreen" \
<<<<<<< HEAD
      --prefix PATH : "$out/bin:${lib.makeBinPath runtimeDeps}"
=======
      --prefix PATH : "$out/bin:${lib.makeBinPath [ bc coreutils dbus dunst i3lock-color gawk gnugrep gnused imagemagick procps xorg.xdpyinfo xorg.xrandr xorg.xset ]}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fast and sweet looking lockscreen for linux systems with effects!";
    homepage = "https://github.com/pavanjadhaw/betterlockscreen";
<<<<<<< HEAD
    mainProgram = "betterlockscreen";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eyjhb sebtm ];
  };
}
