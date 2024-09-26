{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "darwin-stubs";
  version = "10.13.6";

  src = fetchurl {
    url = "https://github.com/toonn/darwin-stubs/archive/macOS-10.13.tar.gz";
    sha256 = "sha256-aNPybi1326JbW3MxsmhttGKIQ4s0XBit850Ptoj5beI=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir $out
    mv stubs/${version}/* $out
  '';

  meta = {
    maintainers = with lib.maintainers; [ toonn ];
  };
}
