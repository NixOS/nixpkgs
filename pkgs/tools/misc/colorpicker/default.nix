{ lib, stdenv, fetchFromGitHub, pkg-config, gtk2 }:

stdenv.mkDerivation rec {
  pname = "colorpicker";
  version = "unstable-2017-09-01";

  src = fetchFromGitHub {
    owner = "Jack12816";
    repo = "colorpicker";
    rev = "a4455b92fde1dfbac81e7852f171093932154a30";
    sha256 = "z2asxTIP8WcsWcePmIg0k4bOF2JwkqOxNqSpQv4/a40=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 ];

  installPhase = ''
    install -Dt $out/bin colorpicker
  '';

  meta = with lib; {
    description = "Click on a pixel on your screen and print its color value in RGB";
    homepage = "https://github.com/Jack12816/colorpicker";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.mit;
    mainProgram = "colorpicker";
  };
}
