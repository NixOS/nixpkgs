{ lib, stdenv, fetchFromGitHub, libusb1, pkg-config, ... }:

stdenv.mkDerivation rec {
  pname = "blink1";
  version = "1.98a";

  src = fetchFromGitHub {
    owner = "todbot";
    repo = "blink1";
    rev = "v${version}";
    sha256 = "sha256-o4pOF6Gp70AL63ih6BNOpRTCs7+qzeZrEqaR4hYDTG8=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ];

  configurePhase = ''
    cd commandline
  '';

  installPhase = ''
    PREFIX=$out make install
  '';

  meta = {
    description = "Command line client for the blink(1) notification light";
    homepage = "https://blink1.thingm.com/";
    license = lib.licenses.cc-by-sa-30;
    maintainers = [ lib.maintainers.cransom ];
    platforms = lib.platforms.linux;
  };
}
