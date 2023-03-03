{ lib, stdenv, fetchFromGitHub, pkg-config, gtk2 }:

stdenv.mkDerivation rec {
  pname = "colorpicker";
  version = "unstable-2018-01-14";

  src = fetchFromGitHub {
    owner = "Ancurio";
    repo = "colorpicker";
    rev = "287676947e6e3b5b0cee784aeb1638cf22f0ce17";
    sha256 = "1kj1dpb79llrfpszraaz6r7ci114zqi5rmqxwsvq2dnnpjxyi29r";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 ];

  installPhase = ''
    install -Dt $out/bin colorpicker
  '';

  meta = with lib; {
    description = "Click on a pixel on your screen and print its color value in RGB";
    homepage = "https://github.com/Ancurio/colorpicker";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.mit;
    mainProgram = "colorpicker";
  };
}
