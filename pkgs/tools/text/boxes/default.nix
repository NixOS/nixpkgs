{ lib, stdenv, fetchFromGitHub, bison, flex }:

stdenv.mkDerivation rec {
  pname = "boxes";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "ascii-boxes";
    repo = "boxes";
    rev = "v${version}";
    sha256 = "0b12rsynrmkldlwcb62drk33kk0aqwbj10mq5y5x3hjf626gjwsi";
  };

  # Building instructions:
  # https://boxes.thomasjensen.com/build.html#building-on-linux--unix
  nativeBuildInputs = [ bison flex ];

  dontConfigure = true;

  # Makefile references a system wide config file in '/usr/share'. Instead, we
  # move it within the store by default.
  preBuild = ''
    substituteInPlace Makefile \
      --replace "GLOBALCONF = /usr/share/boxes" \
                "GLOBALCONF=${placeholder "out"}/share/boxes/boxes-config"
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    install -Dm755 -t $out/bin src/boxes
    install -Dm644 -t $out/share/boxes boxes-config
    install -Dm644 -t $out/share/man/man1 doc/boxes.1
  '';

  meta = with lib; {
    description = "A command line program which draws, removes, and repairs ASCII art boxes";
    homepage = "https://boxes.thomasjensen.com";
    license = licenses.gpl2;
    maintainers = with maintainers; [ waiting-for-dev ];
    platforms = platforms.unix;
  };
}
