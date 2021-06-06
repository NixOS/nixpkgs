{
  lib, stdenv, makeWrapper, fetchFromGitHub,
  imagemagick, i3lock-color, xdpyinfo, xrandr, bc, feh, procps, xrdb
}:

stdenv.mkDerivation rec {
  pname = "betterlockscreen";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "pavanjadhaw";
    repo = "betterlockscreen";
    rev = version;
    sha256 = "sha256-UOMCTHtw1C+MiJL6AQ+8gqmmbqrs1QTzEi1Ar03PyMs=";
  };

  nativeBuildInputs = [ makeWrapper ];

  patches = [ ./replace-i3lock.patch ];

  installPhase =
    let
      PATH =
        lib.makeBinPath
        [imagemagick i3lock-color xdpyinfo xrandr bc feh procps xrdb];
    in ''
      mkdir -p $out/bin
      cp betterlockscreen $out/bin/betterlockscreen
      wrapProgram "$out/bin/betterlockscreen" --prefix PATH : "$out/bin:${PATH}"
    '';

  meta = with lib; {
    description = "A simple minimal lock screen which allows you to cache images with different filters and lockscreen with blazing speed";
    homepage = "https://github.com/pavanjadhaw/betterlockscreen";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eyjhb ];
  };
}
