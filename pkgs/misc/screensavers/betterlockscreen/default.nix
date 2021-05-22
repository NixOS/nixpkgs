{
  lib, stdenv, makeWrapper, fetchFromGitHub,
  imagemagick, i3lock-color, xdpyinfo, xrandr, bc, feh, procps, xrdb
}:

stdenv.mkDerivation rec {
  pname = "betterlockscreen";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "pavanjadhaw";
    repo = "betterlockscreen";
    rev = version;
    sha256 = "14vkgdzw7mprjsvmhm3aav8gds73ngn2xxij4syq7l1mhk701wak";
  };

  nativeBuildInputs = [ makeWrapper ];

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
