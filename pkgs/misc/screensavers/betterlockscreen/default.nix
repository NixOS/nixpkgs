{ fetchFromGitHub
, lib
, makeWrapper
, stdenv

  # Dependencies (@see https://github.com/pavanjadhaw/betterlockscreen/blob/master/shell.nix)
, bc
, coreutils
, dbus
, withDunst ? true
, dunst
, i3lock-color
, gawk
, gnugrep
, gnused
, imagemagick
, procps
, xorg
}:

let
  runtimeDeps =
    [ bc coreutils dbus i3lock-color gawk gnugrep gnused imagemagick procps xorg.xdpyinfo xorg.xrandr xorg.xset ]
    ++ lib.optionals withDunst [ dunst ];
in

stdenv.mkDerivation rec {
  pname = "betterlockscreen";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "pavanjadhaw";
    repo = "betterlockscreen";
    rev = "v${version}";
    sha256 = "sha256-e/NyUxrN18+x2zt+JzqVA00P8VdHo8oj9Bx09XKI+Eg=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp betterlockscreen $out/bin/betterlockscreen
    wrapProgram "$out/bin/betterlockscreen" \
      --prefix PATH : "$out/bin:${lib.makeBinPath runtimeDeps}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fast and sweet looking lockscreen for linux systems with effects!";
    homepage = "https://github.com/pavanjadhaw/betterlockscreen";
    mainProgram = "betterlockscreen";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eyjhb sebtm ];
  };
}
