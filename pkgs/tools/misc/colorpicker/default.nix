{ lib, stdenv, fetchFromGitHub, pkg-config, gtk2 }:

stdenv.mkDerivation rec {
  pname = "colorpicker";
<<<<<<< HEAD
  version = "unstable-2017-09-01";

  src = fetchFromGitHub {
    owner = "Jack12816";
    repo = "colorpicker";
    rev = "a4455b92fde1dfbac81e7852f171093932154a30";
    sha256 = "z2asxTIP8WcsWcePmIg0k4bOF2JwkqOxNqSpQv4/a40=";
=======
  version = "unstable-2018-01-14";

  src = fetchFromGitHub {
    owner = "Ancurio";
    repo = "colorpicker";
    rev = "287676947e6e3b5b0cee784aeb1638cf22f0ce17";
    sha256 = "1kj1dpb79llrfpszraaz6r7ci114zqi5rmqxwsvq2dnnpjxyi29r";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 ];

  installPhase = ''
    install -Dt $out/bin colorpicker
  '';

  meta = with lib; {
    description = "Click on a pixel on your screen and print its color value in RGB";
<<<<<<< HEAD
    homepage = "https://github.com/Jack12816/colorpicker";
=======
    homepage = "https://github.com/Ancurio/colorpicker";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ jb55 ];
    license = licenses.mit;
    mainProgram = "colorpicker";
  };
}
