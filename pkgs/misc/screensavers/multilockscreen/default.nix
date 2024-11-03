{
  lib, stdenv, makeWrapper, fetchFromGitHub, writeShellScriptBin,
  imagemagick, i3lock-color, xdpyinfo, xrandr, bc, feh, procps, xrdb, xset,
  gnused, gnugrep, coreutils
}:
let
  i3lock = writeShellScriptBin "i3lock" ''
    ${i3lock-color}/bin/i3lock-color "$@"
  '';
  binPath = lib.makeBinPath [
    imagemagick i3lock
    xdpyinfo xrandr xset
    bc feh procps xrdb
    gnused gnugrep coreutils
  ];
in
stdenv.mkDerivation rec {
  pname = "multilockscreen";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "jeffmhubbard";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bfpbazvhaz9x356nsghz0czysh9b75g79cd9s35v0x0rrzdr9qj";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp multilockscreen $out/bin/multilockscreen
    wrapProgram "$out/bin/multilockscreen" --prefix PATH : "${binPath}"
  '';

  meta = with lib; {
    description = "Wrapper script for i3lock-color";
    mainProgram = "multilockscreen";
    longDescription = ''
      multilockscreen is a wrapper script for i3lock-color.
      It allows you to cache background images for i3lock-color with a variety of different effects and adds a stylish indicator.
    '';
    homepage = "https://github.com/jeffmhubbard/multilockscreen";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kylesferrazza ];
  };
}
