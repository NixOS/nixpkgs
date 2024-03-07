{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "mushroom";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "piitaya";
    repo = "lovelace-mushroom";
    rev = "v${version}";
    hash = "sha256-qLJQ4Mrngd6I3Y5iS4eZGPxla14pQaTnCNH+m69d+yY=";
  };

  npmDepsHash = "sha256-qO3FC+ONfAbEGPD76RBtJjoZ7vC33Bg3tGl4N7AZPzo=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    install -m0644 dist/mushroom.js $out

    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/piitaya/lovelace-mushroom/releases/tag/v${version}";
    description = "Mushroom Cards - Build a beautiful dashboard easily";
    homepage = "https://github.com/piitaya/lovelace-mushroom";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
