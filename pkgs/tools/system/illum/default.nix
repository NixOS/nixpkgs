{ lib, stdenv, fetchFromGitHub, pkg-config, ninja, libevdev, libev, udev }:

stdenv.mkDerivation rec {
  pname = "illum";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "jmesmon";
    repo = "illum";
    rev = "v${version}";
    sha256 = "S4lUBeRnZlRUpIxFdN/bh979xvdS7roF6/6Dk0ZUrnM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ninja libevdev libev udev ];

  configurePhase = ''
    bash ./configure
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv illum-d $out/bin
  '';

  meta = {
    homepage = "https://github.com/jmesmon/illum";
    description = "Daemon that wires button presses to screen backlight level";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.dancek ];
    license = lib.licenses.agpl3;
  };
}
