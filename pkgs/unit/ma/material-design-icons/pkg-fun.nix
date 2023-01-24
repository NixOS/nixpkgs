{ lib, fetchFromGitHub, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "material-design-icons";
  version = "7.1.96";

  dontBuild = true;

  src = fetchFromGitHub {
    owner = "Templarian";
    repo = "MaterialDesign-Webfont";
    rev = "v${version}";
    sha256 = "sha256-qS7zJQkd0Q5wYLgYXa63fD3Qi2T5JWD6vXW2FoFzZxo=";
    sparseCheckout = [ "fonts" ];
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/fonts/"{eot,truetype,woff,woff2}
    cp fonts/*.eot "$out/share/fonts/eot/"
    cp fonts/*.ttf "$out/share/fonts/truetype/"
    cp fonts/*.woff "$out/share/fonts/woff/"
    cp fonts/*.woff2 "$out/share/fonts/woff2/"

    runHook postInstall
  '';

  meta = with lib; {
    description = "7000+ Material Design Icons from the Community";
    longDescription = ''
      Material Design Icons' growing icon collection allows designers and
      developers targeting various platforms to download icons in the format,
      color and size they need for any project.
    '';
    homepage = "https://materialdesignicons.com";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ vlaci PlayerNameHere ];
  };
}
