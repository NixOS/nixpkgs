{ fetchFromGitHub
, lib
, makeWrapper
, stdenv

  # Dependencies (@see https://github.com/pavanjadhaw/betterlockscreen/blob/master/shell.nix)
, bc
, coreutils
, i3lock-color
, gawk
, gnugrep
, gnused
, imagemagick
, procps
, xdpyinfo
, xrandr
, xset
}:

stdenv.mkDerivation rec {
  pname = "betterlockscreen";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "pavanjadhaw";
    repo = "betterlockscreen";
    rev = "v${version}";
    sha256 = "1ha1yddrcmbsdljdg3gn7i42csbw8h3zgf4i3mcsmbz8nsvc2wdc";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp betterlockscreen $out/bin/betterlockscreen
    wrapProgram "$out/bin/betterlockscreen" --prefix PATH : "$out/bin:${lib.makeBinPath [ bc coreutils i3lock-color gawk gnugrep gnused imagemagick procps xdpyinfo xrandr xset ]}"

    runHook preInstall
  '';

  meta = with lib; {
    description = "Fast and sweet looking lockscreen for linux systems with effects!";
    homepage = "https://github.com/pavanjadhaw/betterlockscreen";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eyjhb sebtm ];
  };
}
