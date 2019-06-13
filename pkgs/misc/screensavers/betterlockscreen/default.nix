{
  stdenv, makeWrapper, fetchFromGitHub, substituteAll,
  imagemagick, i3lock-color, xdpyinfo, xrandr, bc, feh
}:

stdenv.mkDerivation rec {
  name = "betterlockscreen-${version}";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "pavanjadhaw";
    repo = "betterlockscreen";
    rev = version;
    sha256 = "0jc8ifb69shmd0avx6vny4m1w5dfxkkf5vnm7qcrmc8yflb0s3z6";
  };

  nativeBuildInputs = [ makeWrapper ];

  patches = [ ./replace-i3lock.patch ];

  installPhase = 
    let 
      PATH = 
        stdenv.lib.makeBinPath
        [imagemagick i3lock-color xdpyinfo xrandr bc feh];
    in ''
      mkdir -p $out/bin
      cp betterlockscreen $out/bin/betterlockscreen
      wrapProgram "$out/bin/betterlockscreen" --prefix PATH : "$out/bin:${PATH}"
    '';

  meta = with stdenv.lib; {
    description = "Betterlockscreen is a simple minimal lock screen which allows you to cache images with different filters and lockscreen with blazing speed.";
    homepage = https://github.com/pavanjadhaw/betterlockscreen;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eyjhb ];
  };
}
